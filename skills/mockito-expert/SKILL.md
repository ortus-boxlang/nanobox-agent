---
name: mockito-expert
description: Use when mocking, stubbing, spying, or verifying collaborator behavior in Java unit tests. Invoke for mock creation, argument matchers, stubbing strategies, verification, argument captors, answer implementations, strict stubbing, spy objects, and Mockito extensions with JUnit 5.
license: MIT
metadata:
  author: https://github.com/Ortus-Solutions
  version: "1.0.0"
  domain: testing
  triggers: mockito, mock, stub, spy, verify, argumentcaptor, @mock, @injectmocks, @spy, @captor, doreturn, whenthenreturn, strict stubbing, mockito extension, mockito junit5, mocking, test double
  role: expert
  scope: implementation
  output-format: code
  related-skills: junit-expert, testcontainers-expert, java-expert, code-reviewer
---

# Mockito Expert

Mockito specialist for precise, maintainable test doubles in Java unit tests.

## Role Definition

Designs and implements Mockito-based test doubles that isolate units from collaborators without over-specifying implementation details. Applies stubbing, verification, capturing, and custom answering strategies with strict discipline to keep tests meaningful and refactor-safe.

## When to Use This Skill

- Isolating a class under test from its dependencies
- Simulating error conditions and edge cases from collaborators
- Capturing arguments passed to a dependency for detailed assertion
- Verifying interaction contracts without testing return values
- Replacing partial implementations with spies
- Configuring Mockito for JUnit 5 projects

## Dependency Setup

### Maven
```xml
<dependency>
  <groupId>org.mockito</groupId>
  <artifactId>mockito-core</artifactId>
  <version>5.12.0</version>
  <scope>test</scope>
</dependency>

<!-- JUnit 5 integration -->
<dependency>
  <groupId>org.mockito</groupId>
  <artifactId>mockito-junit-jupiter</artifactId>
  <version>5.12.0</version>
  <scope>test</scope>
</dependency>
```

### Gradle
```kotlin
dependencies {
    testImplementation("org.mockito:mockito-core:5.12.0")
    testImplementation("org.mockito:mockito-junit-jupiter:5.12.0")
}
```

## JUnit 5 Integration

Always use `@ExtendWith(MockitoExtension.class)` instead of manual `MockitoAnnotations.openMocks()`.

```java
@ExtendWith(MockitoExtension.class)
class OrderServiceTest {

    @Mock
    private OrderRepository repository;

    @Mock
    private PaymentGateway paymentGateway;

    @InjectMocks
    private OrderService orderService;  // Mockito injects @Mock fields

    @Captor
    private ArgumentCaptor<Order> orderCaptor;

    @Test
    void shouldSaveOrderAfterPayment() {
        // stub
        when(paymentGateway.charge(any())).thenReturn(PaymentResult.success("txn-1"));

        // act
        orderService.place(Order.of("item-1", 2));

        // verify
        verify(repository).save(orderCaptor.capture());
        assertThat(orderCaptor.getValue().status()).isEqualTo(OrderStatus.ACCEPTED);
    }
}
```

## Mock Creation

### Annotation-based (preferred)
```java
@Mock
private UserRepository userRepository;

@Spy
private AuditLogger auditLogger = new AuditLogger();  // real object, partial mock

@InjectMocks
private UserService userService;
```

### Programmatic (when annotations are unavailable)
```java
UserRepository userRepository = mock(UserRepository.class);
AuditLogger auditLogger = spy(new AuditLogger());
UserService userService = new UserService(userRepository, auditLogger);
```

### Mocking with settings
```java
// with a name (improves error messages)
UserRepository repo = mock(UserRepository.class, "userRepository");

// lenient mock (disables strict stubbing for this mock only)
UserRepository repo = mock(UserRepository.class, withSettings().lenient());

// mock with default answer
UserRepository repo = mock(UserRepository.class, RETURNS_DEEP_STUBS);
```

## Stubbing

### `when(...).thenReturn(...)` — return a value
```java
when(repository.findById("user-1")).thenReturn(Optional.of(alice));
when(repository.findById("missing")).thenReturn(Optional.empty());

// chain for consecutive calls
when(clock.now())
    .thenReturn(Instant.parse("2024-01-01T00:00:00Z"))
    .thenReturn(Instant.parse("2024-01-02T00:00:00Z"));
```

### `when(...).thenThrow(...)` — simulate exceptions
```java
when(paymentGateway.charge(any())).thenThrow(new PaymentException("card declined"));

// throw checked exceptions
when(fileStore.read("missing.txt")).thenThrow(IOException.class);
```

### `when(...).thenAnswer(...)` — dynamic response
```java
when(idGenerator.next()).thenAnswer(inv -> UUID.randomUUID().toString());

when(repository.findAll()).thenAnswer(inv -> {
    // simulate delay or side effects
    return List.of(alice, bob);
});
```

### `doReturn / doThrow / doAnswer` — for void methods and spies

Use `do*` form when stubbing `void` methods or when the method is called on a `@Spy`.

```java
// void method stubbing
doNothing().when(emailService).send(any());
doThrow(new MailException("server down")).when(emailService).send(any());

// spy — prevents real method from executing before stub
doReturn(42).when(spyService).computeScore();

// doAnswer for void methods with side effects
doAnswer(inv -> {
    Order order = inv.getArgument(0);
    order.markProcessed();
    return null;
}).when(repository).save(any(Order.class));
```

### Stubbing void methods with lambdas
```java
doAnswer(invocation -> {
    Consumer<String> callback = invocation.getArgument(1);
    callback.accept("processed");
    return null;
}).when(asyncProcessor).process(eq("job-1"), any());
```

## Argument Matchers

Matchers make stubs flexible and verifications readable.

```java
import static org.mockito.ArgumentMatchers.*;

// any type
when(repo.findById(anyString())).thenReturn(Optional.of(user));
when(repo.findAll(anyList())).thenReturn(users);

// specific equality
when(repo.findById(eq("user-42"))).thenReturn(Optional.of(alice));

// type-based
when(processor.process(any(Order.class))).thenReturn(result);

// null / non-null
when(service.lookup(isNull())).thenThrow(IllegalArgumentException.class);
when(service.lookup(notNull())).thenReturn(result);

// string matchers
when(repo.search(startsWith("order-"))).thenReturn(orders);
when(repo.search(endsWith("-v2"))).thenReturn(drafts);
when(repo.search(contains("2024"))).thenReturn(yearOrders);
when(repo.search(matches("ORD-\\d{6}"))).thenReturn(formattedOrders);

// custom predicate
when(repo.findBy(argThat(spec -> spec.minAmount().compareTo(BigDecimal.TEN) > 0)))
    .thenReturn(highValueOrders);
```

**Rule:** When you use any matcher in an invocation, ALL arguments must be matchers.
```java
// WRONG
verify(service).transfer("acc-1", anyString());

// CORRECT
verify(service).transfer(eq("acc-1"), anyString());
```

## Verification

### Basic verification
```java
// called exactly once (default)
verify(repository).save(any(Order.class));

// exact count
verify(emailService, times(2)).send(any());

// never called
verify(auditLogger, never()).logFailure(any());

// at least / at most
verify(cache, atLeast(1)).evict(any());
verify(rateLimiter, atMost(3)).acquire();

// no more interactions
verifyNoMoreInteractions(repository);

// zero interactions at all
verifyNoInteractions(emailService);
```

### Verification order
```java
InOrder inOrder = inOrder(repository, emailService);
inOrder.verify(repository).save(any());
inOrder.verify(emailService).send(any());
```

### Verify with timeout (async code)
```java
verify(eventBus, timeout(500)).publish(any(OrderPlacedEvent.class));
verify(eventBus, timeout(500).times(2)).publish(any());
```

## Argument Captors

Capture arguments for detailed assertion when matchers alone are insufficient.

```java
@Captor
private ArgumentCaptor<Order> orderCaptor;

@Captor
private ArgumentCaptor<EmailMessage> emailCaptor;

@Test
void shouldSendConfirmationWithCorrectContent() {
    orderService.place(Order.of("item-1", 5));

    verify(emailService).send(emailCaptor.capture());
    EmailMessage sent = emailCaptor.getValue();

    assertThat(sent.to()).isEqualTo("customer@example.com");
    assertThat(sent.subject()).startsWith("Order confirmed");
    assertThat(sent.body()).contains("item-1", "5");
}

@Test
void shouldSaveAllItems() {
    orderService.placeAll(List.of(order1, order2, order3));

    verify(repository, times(3)).save(orderCaptor.capture());
    List<Order> saved = orderCaptor.getAllValues();

    assertThat(saved).extracting(Order::status)
        .containsOnly(OrderStatus.ACCEPTED);
}
```

## Spy — Partial Mocking

Spies wrap a real object. Only explicitly stubbed methods are overridden.

```java
@Spy
private AuditLogger auditLogger = new AuditLogger();

@Test
void shouldAuditOrderPlacement() {
    // real send() still runs unless stubbed
    orderService.place(order);
    verify(auditLogger).log(contains("ORDER_PLACED"));
}
```

```java
// Stub one method, keep others real
doReturn("mocked-id").when(auditLogger).generateCorrelationId();
```

**Warning:** Do not use `when(spy.method()).thenReturn(...)` — it calls the real method first. Always use `doReturn(...).when(spy).method()`.

## Strict Stubbing

`MockitoExtension` enforces strict stubbing by default:
- Fails tests with **unnecessary stubs** (stubbed but never called)
- Fails with **stubbing argument mismatch** (stubbed with A, called with B)

This prevents test rot from accumulating dead stubs.

```java
// This will fail if someMethod() is never called in the test
when(mock.someMethod()).thenReturn("value");
```

To selectively relax:
```java
// Option 1: per-mock lenient setting
@Mock(lenient = true)
private UserRepository repository;

// Option 2: per-stub lenient wrapping
lenient().when(repository.findById(any())).thenReturn(Optional.empty());

// Option 3: class-level (use sparingly)
@MockitoSettings(strictness = Strictness.LENIENT)
class LegacyTest { ... }
```

## Mocking Static Methods (Mockito 3.4+)

Requires `mockito-inline` dependency (included in mockito-core 5+).

```java
@Test
void shouldUseCurrentTime() {
    try (MockedStatic<Instant> mockedInstant = mockStatic(Instant.class)) {
        var fixedTime = Instant.parse("2024-06-01T12:00:00Z");
        mockedInstant.when(Instant::now).thenReturn(fixedTime);

        var result = service.createTimestampedRecord("data");

        assertThat(result.createdAt()).isEqualTo(fixedTime);
    }
}
```

**Caution:** Prefer injecting `Clock` or `Supplier<Instant>` over mocking static `Instant.now()` in production design.

## Mocking Constructors (`MockedConstruction`)

```java
@Test
void shouldInitializeConnectorWithCorrectConfig() {
    try (MockedConstruction<DatabaseConnector> mocked = mockConstruction(
            DatabaseConnector.class,
            (mock, ctx) -> when(mock.isConnected()).thenReturn(true)
    )) {
        service.initialize();

        assertThat(mocked.constructed()).hasSize(1);
        verify(mocked.constructed().get(0)).connect(any());
    }
}
```

## Custom Answers

```java
// Return first argument
when(formatter.format(anyString())).thenAnswer(AdditionalAnswers.returnsFirstArg());

// Return argument at index
when(mapper.map(any(), anyInt())).thenAnswer(AdditionalAnswers.returnsArgAt(1));

// Delegate to real implementation
when(service.compute(any())).thenAnswer(AdditionalAnswers.delegatesTo(realService));

// Custom Answer
when(cache.get(anyString())).thenAnswer(inv -> {
    String key = inv.getArgument(0);
    return backingMap.get(key);
});
```

## Reset and Clear

Avoid `reset()` — it indicates the test is doing too much. Split into smaller tests instead.

```java
// Only if absolutely necessary (e.g., shared mock across @Nested classes)
reset(repository);
clearInvocations(repository); // clears recorded calls but keeps stubs
```

## Common Pitfalls and Solutions

| Pitfall | Cause | Fix |
|---|---|---|
| `UnnecessaryStubbingException` | Stub set up but method never called | Remove unused stub or use `lenient()` |
| `WrongTypeOfReturnValue` | Wrong return type in stub | Verify the stubbed method's return type |
| Spy calls real method unexpectedly | Using `when(spy.x())` instead of `doReturn` | Use `doReturn(...).when(spy).x()` |
| Matcher used with plain value | Mixed matcher and non-matcher args | Wrap plain values with `eq()` |
| Mock returns null instead of stubbed value | Stub not matching actual argument | Use `any()` or debug argument with captor |
| `final` class cannot be mocked | Mockito default doesn't support final | Add `mockito-extensions/org.mockito.plugins.MockMaker` with `mock-maker-inline` |

## Mocking Final Classes

Create file `src/test/resources/mockito-extensions/org.mockito.plugins.MockMaker`:
```
mock-maker-inline
```

Or use Mockito 5 which enables this by default via the subclass MockMaker.

## Reference Guide

| Scenario | Recommended Approach |
|---|---|
| Return a value | `when(...).thenReturn(...)` |
| Throw an exception | `when(...).thenThrow(...)` |
| Dynamic response | `when(...).thenAnswer(...)` |
| Void method stub | `doNothing/doThrow/doAnswer().when(mock).method()` |
| Spy void method | `doNothing().when(spy).method()` |
| Capture arguments | `ArgumentCaptor` + `capture()` / `getValue()` |
| Verify interaction | `verify(mock, times(n)).method(args)` |
| Verify order | `InOrder` |
| Verify async | `verify(mock, timeout(ms)).method()` |
| Mock static | `mockStatic(Class.class)` in try-with-resources |

## Constraints

### MUST DO

- Use `@ExtendWith(MockitoExtension.class)` for JUnit 5 integration
- Keep stubs close to the test that uses them (in `@BeforeEach` only for shared behavior)
- Assert on captured arguments rather than overusing `any()` in verifications
- Prefer state verification over interaction verification when both are possible

### MUST NOT DO

- Do not mock types you don't own (mock an adapter/wrapper instead)
- Do not mock value objects or entities — construct them directly
- Do not mock everything — isolate only external dependencies
- Do not use `reset()` as a substitute for splitting large tests
- Do not use `RETURNS_DEEP_STUBS` outside of fluent API chains — it hides design problems

## Output Templates

```md
## Mock Design Review
- Class under test: [ClassName]
- Mocked collaborators: [list with rationale]
- Stubbing strategy: [thenReturn / thenAnswer / thenThrow]
- Verification targets: [list]
- ArgumentCaptor usage: [yes/no with justification]
- Strict stubbing exceptions: [none / lenient mocks with reason]
```

```java
// Standard Mockito test template
@ExtendWith(MockitoExtension.class)
class TargetServiceTest {

    @Mock  RepositoryType repository;
    @Mock  GatewayType    gateway;
    @InjectMocks TargetService sut;
    @Captor ArgumentCaptor<DomainType> captor;

    @Test
    void shouldBehaviorWhenCondition() {
        // Arrange
        when(repository.findById(eq("id-1"))).thenReturn(Optional.of(entity));
        when(gateway.process(any())).thenReturn(successResult);

        // Act
        sut.execute("id-1");

        // Assert
        verify(repository).save(captor.capture());
        assertThat(captor.getValue().status()).isEqualTo(ExpectedStatus.DONE);
        verifyNoMoreInteractions(repository);
    }
}
```

## Knowledge Reference

mockito 5, mockito-junit-jupiter, @mock, @spy, @injectmocks, @captor, @extendwith, when thenreturn, thenthrow, thenanswer, doreturn dothrow, argument matchers, any eq startswith, verify times never, verifynointeractions, verifynomore interactions, inorder verification, argumentcaptor, spy partial mock, strict stubbing, lenient, unnecessarystubbingexception, mockedstatic, mockedconstruction, mock final class, mock-maker-inline, custom answer, returnsFirstArg, delegatesTo, mockitosettings

## Related Skills

- `junit-expert`
- `testcontainers-expert`
- `java-expert`
- `code-reviewer`
