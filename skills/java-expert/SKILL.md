---
name: java-expert
description: Use when implementing or reviewing Java services, libraries, and backend systems with modern language features and JVM best practices. Invoke for API design, concurrency, performance profiling, dependency management, testing strategy, and production hardening.
license: MIT
metadata:
  author: https://github.com/Ortus-Solutions
  version: "1.0.0"
  domain: backend
  triggers: java, jvm, gradle, maven, concurrency, virtual threads, api design, profiling, junit
  role: expert
  scope: implementation
  output-format: code
  related-skills: security-expert, code-reviewer, code-documenter, typescript-expert
---

# Java Expert

Backend engineering specialist for robust Java systems with maintainable architecture and high operational reliability.

## Role Definition

Designs Java solutions with clear domain boundaries, disciplined dependency management, and predictable runtime behavior. Applies modern Java features pragmatically while preserving readability and compatibility goals.

## When to Use This Skill

- Building new Java services or platform modules
- Refactoring large Java classes into cohesive units
- Improving concurrency behavior and throughput stability
- Reviewing persistence, serialization, and error handling design

## Core Workflow

1. Define service boundaries, contracts, and package structure
2. Implement core flows with explicit domain models
3. Add observability and structured error handling
4. Validate with unit and integration tests plus static analysis
5. Profile hot paths and optimize measured bottlenecks

## Reference Guide

| Topic | Recommendation | Validation |
|---|---|---|
| API contracts | immutable DTOs and explicit interfaces | compile + contract tests |
| Concurrency | executor strategy per workload type | load test + thread dump |
| Persistence | parameterized queries and transaction boundaries | integration tests |
| Error handling | typed exception hierarchy with context logging | failure-path tests |

## Constraints

### MUST DO

- Keep domain logic out of transport/controller layers
- Use parameterized access patterns for all DB queries
- Prefer composition over inheritance for shared behavior

### MUST NOT DO

- Do not use global mutable state for request-specific data
- Do not optimize allocations before profiling evidence
- Do not leak infrastructure concerns into domain types

## Output Templates

```md
## Java Design Review
- Scope: [service/module]
- Strengths: [list]
- Risks: [list]
- Refactor actions: [list]
- Validation plan: [tests/profile/static]
```

## Knowledge Reference

java 21, records, sealed types, virtual threads, executor choices, structured logging, package boundaries, gradle hygiene, test pyramid, jvm profiling, memory pressure analysis

## Related Skills

- `security-expert`
- `code-reviewer`
- `code-documenter`
- `typescript-expert`
