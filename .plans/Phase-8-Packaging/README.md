# Phase 8 — Packaging

**Objective:** Release-ready distribution with documentation.

**Dependencies:** All prior phases must be complete with all tests passing.

## Tasks

| # | Task | Test | Depends On |
|---|------|------|------------|
| 1 | Release tarball script | Manual | All |
| 2 | GitHub Releases setup | Manual | 1 |
| 3 | Setup wizard polish | Manual | All |
| 4 | Documentation for GitBook | Manual | All |

## Acceptance

```
$ curl -fsSL https://nanobox.io/install.sh | bash
→ NanoBox v0.1.0 installed successfully.
→ nanobox doctor passes all checks.
```
