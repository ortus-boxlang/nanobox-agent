---
name: junit-expert
description: Use when writing, reviewing, or structuring JUnit 5 tests for Java applications. Invoke for test lifecycle, parameterized tests, test extensions, assertions, test organization, parallel execution, test suites, dynamic tests, and integration with build tools.
license: MIT
metadata:
  author: https://github.com/Ortus-Solutions
  version: "1.0.0"
  domain: testing
  triggers: junit, junit5, jupiter, test, unit test, parameterized test, test extension, assertions, test lifecycle, @test, @beforeeach, @aftereach, @nested, @parameterizedtest, @dynamictest
  role: expert
  scope: implementation
  output-format: code
  related-skills: mockito-expert, testcontainers-expert, java-expert, code-reviewer
---

# JUnit Expert

JUnit 5 (Jupiter) specialist for comprehensive, maintainable, and expressive Java test suites.

## Role Definition

Designs and implements JUnit 5 test suites that are fast, isolated, readable, and aligned with the test pyramid. Applies the full JUnit 5 API surface pragmatically — from basic lifecycle management to advanced extension authoring and dynamic test generation.

## When to Use This Skill

- Writing new unit or integration tests for Java classes
- Restructuring disorganized or fragile test classes
- Implementing parameterized or data-driven test scenarios
- Authoring custom JUnit 5 extensions for cross-cutting concerns
- Configuring parallel test execution and test suite composition
- Diagnosing flaky or slow test behavior

## Core Workflow

1. Identify the unit under test and its collaborators
2. Define test scope: unit, slice, or integration
3. Structure the test class with appropriate lifecycle hooks
4. Write focused, single-assertion-per-test cases
5. Cover edge cases with parameterized inputs
6. Validate build integration and execution time

## JUnit 5 Architecture

JUnit 5 = **JUnit Platform** + **JUnit Jupiter** + **JUnit Vintage**

| Component | Role |
|---|---|
| Platform | Test engine launcher, IDE/build integration |
| Jupiter | New programming and extension model (use this) |
| Vintage | Backward compatibility runner for JUnit 3/4 |

## Dependency Setup

### Maven
```xml
<dependency>
  <groupId>org.junit.jupiter</groupId>
  <artifactId>junit-jupiter</artifactId>
  <version>5.11.0</version>
  <scope>test</scope>
</dependency>

<!-- Maven Surefire plugin must be 2.22.0+ -->
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-surefire-plugin</artifactId>
  <version>3.2.5</version>
</plugin>
```

### Gradle
```kotlin
dependencies {
    testImplementation("org.junit.jupiter:junit-jupiter:5.11.0")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

tasks.withType<Test> {
    useJUnitPlatform()
}
```

## Test Lifecycle Annotations

| Annotation | Scope | Runs |
|---|---|---|
| `@Test` | method | marks a test method |
| `@BeforeAll` | static method | once before all tests in the class |
| `@AfterAll` | static method | once after all tests in the class |
| `@BeforeEach` | method | before each test method |
| `@AfterEach` | method | after each test method |
| `@Disabled` | class or method | skips the test |
| `@Tag` | class or method | categorizes for filtering |
| `@Timeout` | method | fails if execution exceeds duration |

### Lifecycle Example
```java
@Tag("unit")
class OrderServiceTest {

    private OrderService service;

    @BeforeEach
    void setUp() {
        service = new OrderService(new InMemoryOrderRepository());
    }

    @AfterEach
    void tearDown() {
        // release resources if needed
    }

    @Test
    void shouldAcceptValidOrder() {
        var order = Order.of("item-1", 3);
        var result = service.place(order);
        assertThat(result.status()).isEqualTo(OrderStatus.ACCEPTED);
    }

    @Test
    @Disabled("pending inventory service integration")
    void shouldRejectOutOfStockOrder() { }
}
```

## Assertions (JUnit Jupiter + AssertJ)

Prefer **AssertJ** for rich, fluent assertions. Use JUnit built-ins for basic cases.

### JUnit Built-in Assertions
```java
import static org.junit.jupiter.api.Assertions.*;

// equality
assertEquals(expected, actual);
assertEquals(expected, actual, "message on failure");

// nullability
assertNotNull(result);
assertNull(result);

// boolean
assertTrue(condition);
assertFalse(condition);

// exceptions
assertThrows(IllegalArgumentException.class, () -> service.place(null));
var ex = assertThrows(OrderException.class, () -> service.cancel(closedOrder));
assertEquals("Order already closed", ex.getMessage());

// grouped assertions — all run even if one fails
assertAll(
    () -> assertEquals("Alice", user.name()),
    () -> assertEquals("alice@example.com", user.email()),
    () -> assertTrue(user.isActive())
);

// timeout
assertTimeout(Duration.ofMillis(200), () -> service.process(largeOrder));
```

### AssertJ (Preferred)
```java
import static org.assertj.core.api.Assertions.*;

// object
assertThat(result).isNotNull().isInstanceOf(Order.class);

// strings
assertThat(result.id()).startsWith("ORD-").hasSize(10);

// collections
assertThat(orders).hasSize(3).extracting(Order::status)
    .containsExactly(ACCEPTED, ACCEPTED, REJECTED);

// exceptions
assertThatThrownBy(() -> service.place(null))
    .isInstanceOf(IllegalArgumentException.class)
    .hasMessageContaining("order must not be null");

// optionals
assertThat(service.findById("missing")).isEmpty();
```

## Nested Tests (`@Nested`)

Use `@Nested` to express hierarchical test structure for complex units.

```java
class PaymentProcessorTest {

    @Nested
    @DisplayName("when payment method is credit card")
    class CreditCardPayment {

        @Test
        void shouldAuthorizeValidCard() { ... }

        @Test
        void shouldDeclineExpiredCard() { ... }

        @Nested
        @DisplayName("and 3DS is required")
        class With3DS {
            @Test
            void shouldTrigger3DSChallenge() { ... }
        }
    }

    @Nested
    @DisplayName("when payment method is bank transfer")
    class BankTransfer {
        @Test
        void shouldQueueTransfer() { ... }
    }
}
```

## Parameterized Tests

### `@ValueSource` — single primitive/string argument
```java
@ParameterizedTest
@ValueSource(strings = {"", " ", "\t", "\n"})
void shouldRejectBlankNames(String name) {
    assertThatThrownBy(() -> new User(name, "email@example.com"))
        .isInstanceOf(IllegalArgumentException.class);
}

@ParameterizedTest
@ValueSource(ints = {-1, 0, Integer.MIN_VALUE})
void shouldRejectNonPositiveQuantity(int qty) {
    assertThatThrownBy(() -> Order.of("item", qty))
        .isInstanceOf(IllegalArgumentException.class);
}
```

### `@CsvSource` — multiple inline arguments
```java
@ParameterizedTest
@CsvSource({
    "STANDARD, 3, 9.99",
    "EXPRESS, 1, 19.99",
    "OVERNIGHT, 0, 34.99"
})
void shouldCalculateShippingCost(String tier, int days, double expectedCost) {
    var cost = shippingCalculator.calculate(ShippingTier.valueOf(tier), days);
    assertThat(cost).isEqualByComparingTo(BigDecimal.valueOf(expectedCost));
}
```

### `@CsvFileSource` — CSV from classpath file
```java
@ParameterizedTest
@CsvFileSource(resources = "/test-data/orders.csv", numLinesToSkip = 1)
void shouldProcessOrderFromFile(String orderId, int quantity, String expected) { ... }
```

### `@MethodSource` — complex object arguments
```java
@ParameterizedTest
@MethodSource("invalidOrders")
void shouldRejectInvalidOrders(Order order, String expectedMessage) {
    assertThatThrownBy(() -> service.place(order))
        .hasMessageContaining(expectedMessage);
}

static Stream<Arguments> invalidOrders() {
    return Stream.of(
        Arguments.of(Order.of(null, 1), "item must not be null"),
        Arguments.of(Order.of("", 1), "item must not be blank"),
        Arguments.of(Order.of("item", 0), "quantity must be positive")
    );
}
```

### `@EnumSource` — enum values
```java
@ParameterizedTest
@EnumSource(value = OrderStatus.class, names = {"CANCELLED", "REJECTED"})
void shouldNotAllowModificationOfTerminalOrders(OrderStatus status) {
    var order = Order.withStatus(status);
    assertThatThrownBy(() -> service.modify(order))
        .isInstanceOf(IllegalStateException.class);
}
```

## Dynamic Tests (`@TestFactory`)

Generate tests at runtime when the set of cases is not known statically.

```java
@TestFactory
Stream<DynamicTest> shouldValidateAllCountryCodes() {
    return CountryRegistry.allCodes().stream()
        .map(code -> dynamicTest(
            "should accept country code: " + code,
            () -> assertThat(validator.isValid(code)).isTrue()
        ));
}

@TestFactory
Collection<DynamicContainer> shouldValidateProductRules() {
    return List.of(
        dynamicContainer("physical products", Stream.of(
            dynamicTest("requires weight", () -> ...),
            dynamicTest("requires dimensions", () -> ...)
        )),
        dynamicContainer("digital products", Stream.of(
            dynamicTest("requires download URL", () -> ...)
        ))
    );
}
```

## JUnit 5 Extensions

Extensions replace JUnit 4 `@Rule` / `@ClassRule`. Implement one or more extension interfaces.

### Common Extension Interfaces
| Interface | Purpose |
|---|---|
| `BeforeEachCallback` | before each test |
| `AfterEachCallback` | after each test |
| `BeforeAllCallback` | before all tests in class |
| `AfterAllCallback` | after all tests in class |
| `ParameterResolver` | inject parameters into test methods |
| `TestExecutionExceptionHandler` | handle/transform exceptions |
| `TestInstancePostProcessor` | post-process test instance after creation |
| `ConditionEvaluationResult` | control whether test runs |

### Custom Extension Example — Database Cleanup
```java
public class DatabaseCleanupExtension implements BeforeEachCallback, AfterEachCallback {

    @Override
    public void beforeEach(ExtensionContext context) {
        getDatabase(context).beginTransaction();
    }

    @Override
    public void afterEach(ExtensionContext context) {
        getDatabase(context).rollback();
    }

    private Database getDatabase(ExtensionContext ctx) {
        return ctx.getStore(Namespace.create(getClass(), ctx.getRequiredTestClass()))
                  .getOrComputeIfAbsent("db", k -> Database.connect(), Database.class);
    }
}
```

```java
@ExtendWith(DatabaseCleanupExtension.class)
class OrderRepositoryTest { ... }
```

### `@RegisterExtension` (programmatic)
```java
class UserServiceTest {

    @RegisterExtension
    static WireMockExtension wireMock = WireMockExtension.newInstance()
        .options(wireMockConfig().dynamicPort())
        .build();

    @Test
    void shouldCallExternalApi() {
        wireMock.stubFor(get("/users/1").willReturn(okJson("{\"name\":\"Alice\"}")));
        var user = service.fetchUser(1L);
        assertThat(user.name()).isEqualTo("Alice");
    }
}
```

## Conditional Test Execution

```java
@Test
@EnabledOnOs(OS.LINUX)
void shouldUseLinuxFilePermissions() { ... }

@Test
@EnabledOnJre(JRE.JAVA_21)
void shouldUseVirtualThreads() { ... }

@Test
@EnabledIfSystemProperty(named = "env", matches = "ci")
void shouldRunOnlyInCI() { ... }

@Test
@EnabledIfEnvironmentVariable(named = "RUN_SLOW_TESTS", matches = "true")
void shouldRunSlowIntegrationTest() { ... }
```

## Parallel Test Execution

Enable in `src/test/resources/junit-platform.properties`:
```properties
junit.jupiter.execution.parallel.enabled=true
junit.jupiter.execution.parallel.mode.default=concurrent
junit.jupiter.execution.parallel.mode.classes.default=concurrent
junit.jupiter.execution.parallel.config.strategy=dynamic
junit.jupiter.execution.parallel.config.dynamic.factor=2
```

Control per-class or per-method:
```java
@Execution(ExecutionMode.CONCURRENT)
class FastIsolatedTest { ... }

@Execution(ExecutionMode.SAME_THREAD)
class SharedStateTest { ... }
```

**Warning:** Do not enable concurrent mode for tests sharing mutable static state or external resources without synchronization.

## Test Suites

```java
@Suite
@SelectPackages("com.example.orders")
@IncludeTags("unit")
@ExcludeTags("slow")
class OrderUnitTestSuite { }

@Suite
@SelectClasses({OrderServiceTest.class, PaymentProcessorTest.class})
class SmokeTestSuite { }
```

Requires:
```xml
<dependency>
  <groupId>org.junit.platform</groupId>
  <artifactId>junit-platform-suite</artifactId>
  <version>1.11.0</version>
  <scope>test</scope>
</dependency>
```

## Temporary Files and Directories

```java
@Test
void shouldWriteReportToFile(@TempDir Path tempDir) {
    var reportFile = tempDir.resolve("report.csv");
    reporter.write(data, reportFile);
    assertThat(reportFile).exists().isNotEmpty();
}
```

## Capturing Output

```java
@Test
void shouldLogWarningForLargeOrders(CapturedOutput output) {
    service.place(Order.of("item", 10_000));
    assertThat(output).contains("WARN: unusually large quantity");
}
// Requires Spring Boot test slice or OutputCaptureExtension
```

## Ordering Tests

Avoid ordering unless testing stateful workflows. Use `@TestMethodOrder` only when necessary:
```java
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class CheckoutFlowTest {
    @Test @Order(1) void shouldAddItemToCart() { ... }
    @Test @Order(2) void shouldApplyCoupon() { ... }
    @Test @Order(3) void shouldCompletePurchase() { ... }
}
```

## Reference Guide

| Topic | Recommendation | Validation |
|---|---|---|
| Test structure | Arrange-Act-Assert (AAA) | readable, one concept per test |
| Naming | `should<Behavior>When<Condition>()` | enforced via convention |
| Isolation | no shared mutable state between tests | parallel run green |
| Coverage | cover happy path, edge cases, and error paths | mutation testing |
| Speed | unit tests < 50ms each | CI timing gates |
| Assertions | prefer AssertJ for readability | code review |

## Constraints

### MUST DO

- Follow Arrange-Act-Assert layout in every test method
- Test one logical behavior per `@Test` method
- Keep tests independent — no execution order dependencies
- Use `@DisplayName` for non-obvious test names
- Assert on behavior, not on implementation details

### MUST NOT DO

- Do not use `Thread.sleep()` — use `@Timeout` or polling utilities
- Do not share mutable fields between test methods without `@BeforeEach` reset
- Do not skip `@AfterEach` cleanup for resources that can leak
- Do not test private methods directly — test through the public API
- Do not mix unit tests and integration tests in the same class

## Output Templates

```md
## Test Coverage Review
- Class under test: [ClassName]
- Test class: [ClassNameTest]
- Covered behaviors: [list]
- Missing cases: [list]
- Recommended parameterized expansions: [list]
- Lifecycle hooks needed: [BeforeEach/AfterAll/etc.]
```

```java
// Standard test class template
@Tag("unit")
@DisplayName("OrderService")
class OrderServiceTest {

    private OrderService sut;

    @BeforeEach
    void setUp() {
        sut = new OrderService(/* dependencies */);
    }

    @Nested
    @DisplayName("place()")
    class Place {

        @Test
        @DisplayName("should accept a valid order")
        void shouldAcceptValidOrder() {
            // Arrange
            var order = Order.of("item-1", 2);
            // Act
            var result = sut.place(order);
            // Assert
            assertThat(result.status()).isEqualTo(OrderStatus.ACCEPTED);
        }

        @ParameterizedTest(name = "should reject when quantity is {0}")
        @ValueSource(ints = {-5, -1, 0})
        void shouldRejectNonPositiveQuantity(int qty) {
            assertThatThrownBy(() -> sut.place(Order.of("item", qty)))
                .isInstanceOf(IllegalArgumentException.class);
        }
    }
}
```

## Knowledge Reference

junit5, junit jupiter, @test, @parameterizedtest, @nestedtest, @dynamictest, @testfactory, @extendwith, @registerextension, assertj, assertions, parameterized tests, test lifecycle, @beforeeach, @aftereach, @beforeall, @afterall, @tag, @disabled, @timeout, @tempdir, parallel execution, test suites, junit platform, extension model, condition annotations, @enabledonos, @enabledonjre, test ordering, @displayname, @methodsource, @csvsource, @valuesource, @enumsource, maven surefire, gradle junit platform

## Related Skills

- `mockito-expert`
- `testcontainers-expert`
- `java-expert`
- `code-reviewer`
