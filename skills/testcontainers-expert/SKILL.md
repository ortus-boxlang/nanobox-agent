---
name: testcontainers-expert
description: Use when writing integration tests that require real infrastructure dependencies such as databases, message brokers, caches, cloud service emulators, or any Dockerized service. Invoke for container lifecycle management, reusable containers, network configuration, wait strategies, custom images, and Testcontainers modules for PostgreSQL, MySQL, Kafka, Redis, LocalStack, and more.
license: MIT
metadata:
  author: https://github.com/Ortus-Solutions
  version: "1.0.0"
  domain: testing
  triggers: testcontainers, integration test, docker, container, postgresql container, mysql container, kafka container, redis container, localstack, mongodb container, elasticsearch, wait strategy, ryuk, reusable container, @container, genericcontainer, compose container, network
  role: expert
  scope: implementation
  output-format: code
  related-skills: junit-expert, mockito-expert, java-expert, code-reviewer
---

# Testcontainers Expert

Testcontainers specialist for reliable, reproducible Java integration tests against real infrastructure.

## Role Definition

Designs integration test suites that use real infrastructure in Docker containers to eliminate the gap between mocked behavior and production reality. Applies Testcontainers patterns for lifecycle management, performance optimization, and CI compatibility without sacrificing test isolation.

## When to Use This Skill

- Testing repository or DAO layers against a real database
- Validating message-driven flows with a real Kafka or RabbitMQ broker
- Testing against cloud service APIs with LocalStack (AWS) or Azurite (Azure)
- Running full-stack Spring Boot slice tests with live dependencies
- Replacing brittle embedded databases (H2) with production-equivalent engines
- Configuring Testcontainers in CI/CD pipelines

## Dependency Setup

### Maven (BOM approach — recommended)
```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.testcontainers</groupId>
      <artifactId>testcontainers-bom</artifactId>
      <version>1.20.1</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>

<dependencies>
  <!-- Core -->
  <dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>testcontainers</artifactId>
    <scope>test</scope>
  </dependency>
  <!-- JUnit 5 integration -->
  <dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>junit-jupiter</artifactId>
    <scope>test</scope>
  </dependency>
  <!-- Module examples — add only what you need -->
  <dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>postgresql</artifactId>
    <scope>test</scope>
  </dependency>
  <dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>kafka</artifactId>
    <scope>test</scope>
  </dependency>
  <dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>localstack</artifactId>
    <scope>test</scope>
  </dependency>
</dependencies>
```

### Gradle
```kotlin
val testcontainersVersion = "1.20.1"

dependencies {
    testImplementation(platform("org.testcontainers:testcontainers-bom:$testcontainersVersion"))
    testImplementation("org.testcontainers:testcontainers")
    testImplementation("org.testcontainers:junit-jupiter")
    testImplementation("org.testcontainers:postgresql")
    testImplementation("org.testcontainers:kafka")
    testImplementation("org.testcontainers:localstack")
}
```

## JUnit 5 Integration

### `@Testcontainers` + `@Container`
```java
@Testcontainers
class OrderRepositoryIT {

    // static = shared across all tests in the class (faster)
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine")
        .withDatabaseName("orders_test")
        .withUsername("test")
        .withPassword("test");

    // instance = new container per test (more isolated, slower)
    @Container
    RedisContainer redis = new RedisContainer("redis:7-alpine");

    @Test
    void shouldPersistOrder() {
        var dataSource = buildDataSource(postgres);
        var repo = new OrderRepository(dataSource);
        // ...
    }
}
```

**Rule:** Use `static @Container` unless you need a fresh container state for every test.

## Container Lifecycle

| Lifecycle | Annotation combo | Container scope |
|---|---|---|
| Per test class (shared) | `static @Container` | started once, stopped after class |
| Per test method | instance `@Container` | started and stopped per test |
| Global (singleton) | Singleton pattern (see below) | started once, reused across classes |
| Manual | `container.start()` / `container.stop()` | fully controlled |

### Manual lifecycle (programmatic)
```java
class ProductServiceIT {

    static PostgreSQLContainer<?> postgres;

    @BeforeAll
    static void startInfrastructure() {
        postgres = new PostgreSQLContainer<>("postgres:16-alpine")
            .withReuse(true);
        postgres.start();
    }

    @AfterAll
    static void stopInfrastructure() {
        if (postgres != null) postgres.stop();
    }
}
```

## Database Containers

### PostgreSQL
```java
static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine")
    .withDatabaseName("testdb")
    .withUsername("user")
    .withPassword("pass")
    .withInitScript("db/schema.sql");  // run SQL on startup

// Access connection info
String jdbcUrl   = postgres.getJdbcUrl();      // jdbc:postgresql://localhost:PORT/testdb
String username  = postgres.getUsername();
String password  = postgres.getPassword();
```

### MySQL
```java
static MySQLContainer<?> mysql = new MySQLContainer<>("mysql:8.0")
    .withDatabaseName("testdb")
    .withUsername("user")
    .withPassword("pass");
```

### MongoDB
```java
static MongoDBContainer mongo = new MongoDBContainer("mongo:7.0");

// Access URI
String mongoUri = mongo.getReplicaSetUrl();  // mongodb://localhost:PORT/test
```

### Microsoft SQL Server
```java
static MSSQLServerContainer<?> mssql = new MSSQLServerContainer<>("mcr.microsoft.com/mssql/server:2022-latest")
    .acceptLicense()
    .withPassword("Strong!Password1");
```

### Database initialization strategies

**Option 1: `withInitScript`** — run a classpath SQL file
```java
.withInitScript("db/init.sql")
```

**Option 2: Flyway / Liquibase** — apply migrations automatically
```java
@BeforeAll
static void runMigrations() {
    Flyway.configure()
          .dataSource(postgres.getJdbcUrl(), postgres.getUsername(), postgres.getPassword())
          .load()
          .migrate();
}
```

**Option 3: `@Sql`** (Spring) — run SQL per test method
```java
@Test
@Sql("/test-data/orders.sql")
void shouldListOrders() { ... }
```

## Spring Boot Integration

### Approach 1: `@DynamicPropertySource`
```java
@SpringBootTest
@Testcontainers
class OrderServiceIT {

    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    @DynamicPropertySource
    static void configureProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url",      postgres::getJdbcUrl);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.datasource.password", postgres::getPassword);
    }

    @Autowired
    private OrderService orderService;

    @Test
    void shouldPersistAndRetrieveOrder() {
        var placed = orderService.place(Order.of("item-1", 3));
        var found  = orderService.findById(placed.id());
        assertThat(found).isPresent().get().extracting(Order::status)
            .isEqualTo(OrderStatus.ACCEPTED);
    }
}
```

### Approach 2: Spring Boot 3.1+ `ServiceConnection`
```java
@SpringBootTest
@Testcontainers
class OrderServiceIT {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    // No @DynamicPropertySource needed — Spring auto-configures the datasource
}
```

### Approach 3: Reusable `@TestConfiguration` base class
```java
@TestConfiguration(proxyBeanMethods = false)
public class TestInfrastructureConfiguration {

    @Bean
    @ServiceConnection
    PostgreSQLContainer<?> postgresContainer() {
        return new PostgreSQLContainer<>("postgres:16-alpine");
    }

    @Bean
    @ServiceConnection
    KafkaContainer kafkaContainer() {
        return new KafkaContainer(DockerImageName.parse("confluentinc/cp-kafka:7.6.0"));
    }
}

// Use in tests
@SpringBootTest
@Import(TestInfrastructureConfiguration.class)
class ApplicationIT { ... }
```

## Singleton Container Pattern (Cross-class Reuse)

Avoid starting a new container per test class. Start once, share across all tests in a JVM run.

```java
public abstract class PostgresIntegrationBase {

    static final PostgreSQLContainer<?> POSTGRES;

    static {
        POSTGRES = new PostgreSQLContainer<>("postgres:16-alpine")
            .withDatabaseName("testdb")
            .withReuse(true);
        POSTGRES.start();
    }

    @DynamicPropertySource
    static void overrideProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url",      POSTGRES::getJdbcUrl);
        registry.add("spring.datasource.username", POSTGRES::getUsername);
        registry.add("spring.datasource.password", POSTGRES::getPassword);
    }
}

// All tests extend the base
@SpringBootTest
class OrderRepositoryIT extends PostgresIntegrationBase { ... }

@SpringBootTest
class ProductRepositoryIT extends PostgresIntegrationBase { ... }
```

Enable container reuse in `~/.testcontainers.properties`:
```properties
testcontainers.reuse.enable=true
```

## Message Brokers

### Kafka
```java
static KafkaContainer kafka = new KafkaContainer(
    DockerImageName.parse("confluentinc/cp-kafka:7.6.0")
);

// Access bootstrap servers
String bootstrapServers = kafka.getBootstrapServers();

// Spring Boot 3.1+ ServiceConnection
@Container
@ServiceConnection
static KafkaContainer kafka = new KafkaContainer(
    DockerImageName.parse("confluentinc/cp-kafka:7.6.0")
);
```

### RabbitMQ
```java
static RabbitMQContainer rabbitmq = new RabbitMQContainer("rabbitmq:3.13-management")
    .withVhost("test-vhost")
    .withUser("admin", "admin");

// Access AMQP URL
String amqpUrl = rabbitmq.getAmqpUrl();
```

### Redis
```java
// Requires testcontainers-redis or use GenericContainer
static GenericContainer<?> redis = new GenericContainer<>("redis:7-alpine")
    .withExposedPorts(6379)
    .waitingFor(Wait.forListeningPort());

int redisPort = redis.getMappedPort(6379);
String redisHost = redis.getHost();
```

## Cloud Service Emulators

### LocalStack (AWS)
```java
static LocalStackContainer localstack = new LocalStackContainer(
    DockerImageName.parse("localstack/localstack:3.0")
).withServices(S3, SQS, DYNAMODB);

// Build AWS clients pointing to LocalStack
S3Client s3 = S3Client.builder()
    .endpointOverride(localstack.getEndpoint())
    .credentialsProvider(StaticCredentialsProvider.create(
        AwsBasicCredentials.create(localstack.getAccessKey(), localstack.getSecretKey())
    ))
    .region(Region.of(localstack.getRegion()))
    .build();
```

### Azurite (Azure Storage)
```java
static GenericContainer<?> azurite = new GenericContainer<>("mcr.microsoft.com/azure-storage/azurite:3.30.0")
    .withExposedPorts(10000, 10001, 10002)
    .withCommand("azurite --blobHost 0.0.0.0 --queueHost 0.0.0.0 --tableHost 0.0.0.0")
    .waitingFor(Wait.forListeningPort());
```

## Wait Strategies

Wait strategies prevent test failures caused by containers not being ready.

```java
// Wait for a port to be listening (default for most containers)
.waitingFor(Wait.forListeningPort())

// Wait for an HTTP endpoint to return 200
.waitingFor(Wait.forHttp("/health").forStatusCode(200))

// Wait for HTTPS
.waitingFor(Wait.forHttps("/health").allowInsecure())

// Wait for a log message
.waitingFor(Wait.forLogMessage(".*database system is ready.*", 1))

// Wait for all of the above
.waitingFor(new WaitAllStrategy()
    .withStrategy(Wait.forListeningPort())
    .withStrategy(Wait.forLogMessage(".*ready.*", 1))
    .withStartupTimeout(Duration.ofSeconds(60))
)

// Custom wait with startup timeout
.waitingFor(Wait.forListeningPort()
    .withStartupTimeout(Duration.ofMinutes(2)))
```

## GenericContainer — Custom Images

Use when no dedicated Testcontainers module exists.

```java
static GenericContainer<?> wiremock = new GenericContainer<>("wiremock/wiremock:3.5.4")
    .withExposedPorts(8080)
    .withClasspathResourceMapping("wiremock", "/home/wiremock", BindMode.READ_ONLY)
    .waitingFor(Wait.forHttp("/__admin/health").forStatusCode(200));

int wiremockPort = wiremock.getMappedPort(8080);
String wiremockUrl = "http://" + wiremock.getHost() + ":" + wiremockPort;
```

### Executing commands inside container
```java
var result = container.execInContainer("pg_dump", "-U", "postgres", "testdb");
assertThat(result.getExitCode()).isZero();
String dump = result.getStdout();
```

### Copying files to/from container
```java
container.copyFileToContainer(MountableFile.forClasspathResource("data.json"), "/app/data.json");
container.copyFileFromContainer("/app/output.csv", "/tmp/local-output.csv");
```

## Docker Compose

```java
static DockerComposeContainer<?> environment = new DockerComposeContainer<>(
    new File("src/test/resources/docker-compose.yml")
)
    .withExposedService("postgres", 5432, Wait.forListeningPort())
    .withExposedService("redis", 6379, Wait.forListeningPort())
    .withLocalCompose(true);  // use local `docker compose` binary

// Access service info
String postgresHost = environment.getServiceHost("postgres", 5432);
int postgresPort    = environment.getServicePort("postgres", 5432);
```

## Container Networking

```java
// Put multiple containers on the same network
static Network network = Network.newNetwork();

static GenericContainer<?> appContainer = new GenericContainer<>("myapp:latest")
    .withNetwork(network)
    .withNetworkAliases("app")
    .dependsOn(postgresContainer);

static PostgreSQLContainer<?> postgresContainer = new PostgreSQLContainer<>("postgres:16-alpine")
    .withNetwork(network)
    .withNetworkAliases("db");

// App container can reach DB via jdbc:postgresql://db:5432/testdb
```

## Configuration and Environment Variables

```java
new GenericContainer<>("myapp:latest")
    .withEnv("APP_ENV", "test")
    .withEnv("DB_URL", "jdbc:postgresql://db:5432/testdb")
    .withEnv(Map.of(
        "FEATURE_FLAG_X", "true",
        "LOG_LEVEL", "DEBUG"
    ))
    .withLabel("test-group", "integration");
```

## Elasticsearch / OpenSearch
```java
static ElasticsearchContainer elasticsearch = new ElasticsearchContainer(
    DockerImageName.parse("docker.elastic.co/elasticsearch/elasticsearch:8.13.0")
)
    .withEnv("xpack.security.enabled", "false")
    .withEnv("discovery.type", "single-node");

String httpHostAddress = elasticsearch.getHttpHostAddress();
// e.g. localhost:9200
```

## Performance Optimization

| Technique | Impact | When to Use |
|---|---|---|
| Static `@Container` | High | Always, unless fresh state needed per test |
| Singleton pattern | Very High | When multiple test classes share infrastructure |
| `withReuse(true)` | Very High | Local dev; combine with `.testcontainers.properties` |
| `withImagePullPolicy(CACHED)` | Medium | CI with warm Docker cache |
| Parallel test execution | High | Independent test classes |
| Shared `Network` | Low | When containers must communicate |

### Reuse configuration (`~/.testcontainers.properties`)
```properties
testcontainers.reuse.enable=true
docker.client.strategy=org.testcontainers.dockerclient.UnixSocketClientProviderStrategy
```

## CI/CD Considerations

### GitHub Actions
```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          java-version: '21'
          distribution: 'temurin'
      - name: Run integration tests
        run: ./mvnw verify -Pintegration-tests
        # Docker is pre-installed on ubuntu-latest runners
        # Testcontainers works out of the box
```

### Ryuk (resource cleanup daemon)
Testcontainers starts a Ryuk container to clean up resources after tests. In restricted environments:
```java
// Disable Ryuk (containers survive JVM exit — use with caution)
System.setProperty("testcontainers.ryuk.disabled", "true");
// OR via environment variable: TESTCONTAINERS_RYUK_DISABLED=true
```

### Docker socket alternatives
```properties
# Use Podman socket
DOCKER_HOST=unix:///run/user/1000/podman/podman.sock
TESTCONTAINERS_RYUK_DISABLED=true
```

## Full Spring Boot Integration Test Example

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Testcontainers
@Transactional
class OrderApiIT {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine")
        .withInitScript("db/schema.sql");

    @Container
    @ServiceConnection
    static KafkaContainer kafka = new KafkaContainer(
        DockerImageName.parse("confluentinc/cp-kafka:7.6.0")
    );

    @Autowired
    private TestRestTemplate restTemplate;

    @Autowired
    private OrderRepository orderRepository;

    @Test
    void shouldCreateOrderAndPublishEvent() throws Exception {
        var request = new PlaceOrderRequest("item-1", 5);
        var response = restTemplate.postForEntity("/api/orders", request, OrderResponse.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        assertThat(response.getBody()).isNotNull();
        assertThat(response.getBody().status()).isEqualTo("ACCEPTED");

        // Verify database state
        var saved = orderRepository.findById(response.getBody().id());
        assertThat(saved).isPresent();

        // Verify Kafka event (consume with test consumer)
        var consumer = buildTestConsumer(kafka.getBootstrapServers());
        consumer.subscribe(List.of("orders.placed"));
        var records = consumer.poll(Duration.ofSeconds(5));
        assertThat(records.count()).isEqualTo(1);
        assertThat(records.iterator().next().value()).contains("item-1");
    }
}
```

## Reference Guide

| Infrastructure | Module | Image recommendation |
|---|---|---|
| PostgreSQL | `testcontainers:postgresql` | `postgres:16-alpine` |
| MySQL | `testcontainers:mysql` | `mysql:8.0` |
| MongoDB | `testcontainers:mongodb` | `mongo:7.0` |
| Kafka | `testcontainers:kafka` | `confluentinc/cp-kafka:7.6.0` |
| RabbitMQ | `testcontainers:rabbitmq` | `rabbitmq:3.13-management` |
| Redis | `GenericContainer` | `redis:7-alpine` |
| Elasticsearch | `testcontainers:elasticsearch` | `docker.elastic.co/elasticsearch/elasticsearch:8.13.0` |
| LocalStack | `testcontainers:localstack` | `localstack/localstack:3.0` |
| WireMock | `GenericContainer` | `wiremock/wiremock:3.5.4` |

## Constraints

### MUST DO

- Use `static @Container` by default to share containers across test methods
- Apply the Singleton pattern for containers shared across test classes
- Use dedicated Testcontainers modules over `GenericContainer` when available
- Always configure an appropriate `waitingFor` strategy
- Use Alpine-based images in CI to reduce pull time

### MUST NOT DO

- Do not use H2 in-memory database as a substitute for PostgreSQL or MySQL in integration tests
- Do not start containers in `@BeforeEach` — use `@BeforeAll` with a static container
- Do not hardcode host or port — always use `container.getHost()` and `container.getMappedPort()`
- Do not disable Ryuk in production CI without explicit resource cleanup strategy
- Do not use `withReuse(true)` in CI pipelines where container state may pollute runs

## Output Templates

```md
## Integration Test Infrastructure Plan
- Test class: [ClassName]
- Required containers: [list with images and modules]
- Lifecycle: [static/singleton/per-test with justification]
- Spring integration: [@DynamicPropertySource / @ServiceConnection]
- Wait strategy: [per container]
- Data setup: [initScript / Flyway / @Sql]
- CI considerations: [runner, Ryuk, pull policy]
```

## Knowledge Reference

testcontainers 1.20, junit-jupiter integration, @testcontainers, @container, postgresqlcontainer, mysqlcontainer, mongodbcontainer, kafkacontainer, rabbitmqcontainer, localstackcontainer, genericcontainer, dockercomposecontainer, wait strategies, waitforlisteningport, waitforlogmessage, waitforhttp, singleton pattern, withreuse, servicecondition, @dynamicpropertysource, @serviceconnection, spring boot 3.1 integration, network, withnetworkaliases, dependson, execincontainer, copytofromcontainer, ryuk, ci github actions, podman socket, testcontainers.properties, flyway liquibase migration, alpine images, performance optimization

## Related Skills

- `junit-expert`
- `mockito-expert`
- `java-expert`
- `code-reviewer`
