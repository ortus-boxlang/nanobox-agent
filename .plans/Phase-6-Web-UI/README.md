# Phase 6 — Web Foundation

**Objective:** Complete the ColdBox 8 BoxLang web application backend, APIs, security boundary, real-time contracts, and operational integration. The visual UI is intentionally deferred to Phase 9.

**Dependencies:** Phase 5 must be complete with all tests passing.

> This phase does not build the dashboard, chat screens, navigation, visual design system, or other user-facing UI. Those belong in `Phase-9-Web-UI` after the backend and packaging work are complete.

## Tasks

| # | Task | Test | Depends On |
|---|------|------|------------|
| 1 | ColdBox 8 BoxLang tiered scaffold, `box.json`, `server.json`, and public web root | Manual | Phase 5 |
| 2 | ColdBox, Router, WireBox, CacheBox, Scheduler, and LogBox configuration | Unit/config tests | 1 |
| 3 | Main handler lifecycle, exception handling, and request correlation | `tests/integration/WebLifecycleTest.bx` | 2 |
| 4 | API response/error contract and base API handler | `tests/unit/ApiResponseTest.bx` | 3 |
| 5 | Health, status, process, and configuration read APIs | `tests/integration/RestApiTest.bx` | 4 |
| 6 | Authentication, authorization, sessions, and CSRF boundary | `tests/integration/AuthTest.bx` | 4 |
| 7 | Domain APIs for sessions, agents, automations, gateways, vault, usage, and security | `tests/integration/DomainApiTest.bx` | 5, 6 |
| 8 | SSE event contract, streaming endpoints, heartbeats, and reconnect behavior | `tests/integration/SSETest.bx` | 7 |
| 9 | LogBox/audit events and operational audit persistence | `tests/integration/AuditTest.bx` | 7 |
| 10 | API documentation and backend acceptance tests | TestBox + manual | 1-9 |

## ColdBox Convention

Use the ColdBox 8 BoxLang template as the source of truth:

```text
app/
├── Application.bx
├── config/
├── handlers/
├── helpers/
├── interceptors/
├── layouts/
├── models/
├── modules/
└── views/

public/
├── Application.bx
├── index.bxm
└── includes/
```

The web application is a single ColdBox application. Vite, Bootstrap, Alpine.js, and Phosphor Icons are deferred to Phase 9 and are not part of this phase.

## Backend Acceptance

```text
$ nanobox web start
🌐 ColdBox web application started

→ /healthcheck responds successfully
→ /api/v1/status returns the documented JSON contract
→ protected mutations enforce authorization and CSRF
→ SSE endpoints emit documented events and heartbeats
→ no dashboard or visual UI is required in this phase
```

## Deferred to Phase 9

- Vite asset pipeline
- Bootstrap/Sass design system
- Alpine.js behavior
- Phosphor icons
- Light/dark/system themes
- ColdBox layout and navigation shell
- Dashboard, chat, sessions, agents, automations, gateways, vault, security, usage, and settings screens
- Accessibility and browser UX verification
