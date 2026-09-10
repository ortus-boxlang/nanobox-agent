---
title: "Curator Report Delivery"
order: 14
description: "How curator reports are stored, imported into the vault, and optionally delivered via gateway."
---

# Curator report delivery

Curator reports are stored locally and imported into Vault. Optional gateway delivery can be enabled with:

```json
{
    "curator": {
        "reportDelivery": {
            "enabled": true,
            "gateway": "telegram",
            "recipient": "CHAT_ID",
            "mode": "summary"
        }
    }
}
```

Modes:

```text
summary  → sends a compact report notification
full     → sends the generated Markdown report content
```

Delivery uses the existing gateway registry and `gateway.send()` contract. Delivery failures are returned in the curator result but do not prevent report creation or Vault import.

When disabled, no gateway is contacted:

```json
{
    "enabled": false,
    "delivered": false
}
```

Tests:

```text
tests/specs/CuratorReportDeliverySpec.bx
```
