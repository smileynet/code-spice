---
name: error-handling-patterns
description: Error handling strategy selection, recoverability analysis, and signaling techniques. Use when choosing between exceptions, result types, error codes, or other error handling approaches, designing error-handling APIs, wrapping third-party library errors, or evaluating whether errors should be explicit or implicit.
---

# Error Handling Patterns

## Error Strategy Decision Table

| Situation | Strategy | Why |
|-----------|----------|-----|
| Invalid user input | Validate and return descriptive error | User can fix it; fail fast at boundary |
| Programming error (bug) | Crash / unchecked exception | Don't mask bugs; fix them |
| External system failure | Retry with backoff or circuit-break | Transient failures resolve; permanent ones need escalation |
| Expected business case (not found) | Return empty/Optional/Result | Not an error — it's a valid outcome |
| Security violation | Log, deny, alert | Don't reveal details to caller |
| Resource exhaustion (OOM, disk) | Fail fast with clear message | Can't recover; make the failure diagnosable |

## Recoverability Framework

```
Can the caller realistically recover?
├── Yes → Use explicit signaling (Result type, checked exception)
│   ├── Expected failure (not found, validation) → Return type encodes the failure
│   └── Transient failure (timeout, rate limit) → Retry with backoff
├── No → Let it propagate (unchecked exception, panic)
│   ├── Bug → Crash and fix the code
│   └── Infrastructure failure → Propagate to top-level handler
└── Caller determines → Provide both options (Result + throw helper)
```

## Signaling Comparison Table

| Technique | Explicit? | Composable? | Performance | Best For |
|-----------|-----------|-------------|-------------|----------|
| Checked exceptions | Yes (compiler-enforced) | No | Moderate | Public APIs, Java |
| Unchecked exceptions | No (caller may miss) | No | Moderate | Bugs, unrecoverable |
| Result/Either types | Yes (type-enforced) | Yes (map/flatMap) | Low overhead | Functional style, Rust/Kotlin |
| Optional/Nullable | Partial | Partial | Low overhead | "Not found" cases only |
| Error codes | No (easy to ignore) | No | Minimal | Low-level, C interop, hot paths |

## Error-Hiding Antipatterns

| Antipattern | Symptom | Severity | Fix |
|-------------|---------|----------|-----|
| **Empty catch block** | `catch (e) {}` — error vanishes | Critical | Handle, log, or propagate |
| **Swallow and return null** | `catch → return null` hides root cause | Critical | Distinguish "not found" from "system error" |
| **Log and continue** | Error logged but execution continues in broken state | Warning | Decide: recover meaningfully or propagate |
| **Generic catch-all** | `catch (Exception e)` masks different failure modes | Warning | Catch specific exceptions; let unexpected ones propagate |
| **Error as magic value** | Return `-1` or `""` to signal failure | Warning | Use typed error channels (Result, Optional, exceptions) |
| **Exception wrapping without context** | `throw new RuntimeException(e)` | Note | Add domain context: `throw new PaymentFailedException("charge declined", e)` |

## Strategy Selection Flowchart

```
What kind of code are you writing?
├── Public API / library
│   ├── Caller must handle → Checked exception or Result type
│   └── Caller can't handle → Unchecked exception (document it)
├── Internal service code
│   ├── Expected failure → Result type
│   └── Bug / unexpected → Let it propagate
├── Hot path (measured)
│   └── Error codes or Result types (avoid exception overhead)
└── Script / CLI
    └── Crash with clear message (fail fast)
```

## Checklist

Before shipping error handling code:

- [ ] Every catch block either recovers, propagates, or fails explicitly
- [ ] No empty catch blocks
- [ ] "Not found" and "system failure" use different error channels
- [ ] Error messages are actionable (what happened, what to do)
- [ ] Third-party exceptions wrapped in domain types at boundaries
- [ ] Error paths have test coverage
