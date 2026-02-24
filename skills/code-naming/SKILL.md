---
name: code-naming
description: Naming decisions for variables, functions, classes, constants, and APIs. Use when choosing names, reviewing naming quality, refactoring unclear names, or establishing naming conventions. Covers descriptive naming, naming as documentation, language-specific conventions, and common naming antipatterns.
---

# Code Naming

## The Naming Decision Table

| You're naming a... | It should read like... | Form | Examples |
|---------------------|----------------------|------|----------|
| **Class / Type** | A noun or noun phrase | PascalCase (most langs) | `UserProfile`, `HttpClient`, `InvoiceParser` |
| **Function / Method** | A verb or verb phrase | camelCase or snake_case | `validateEmail`, `send_invoice`, `calculateTotal` |
| **Boolean** | A yes/no question | `is`/`has`/`can`/`should` prefix | `isActive`, `hasPermission`, `canRetry` |
| **Collection** | A plural noun | Plural form | `users`, `pendingOrders`, `activeConnections` |
| **Constant** | A named fact | UPPER_SNAKE_CASE (most langs) | `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT_MS` |
| **Interface** | A capability or contract | Language-specific | `Serializable`, `IDisposable`, `Reader` |
| **Enum** | A set of named options | PascalCase values | `Color.Red`, `RetryPolicy.ALLOW_RETRY` |
| **Event / Callback** | What happened or will happen | Past/present tense | `onClick`, `onUserCreated`, `handleSubmit` |

## The Three Questions Test

Before committing to a name, verify it answers all three:

1. **What is it?** — The name identifies what the thing represents
2. **What does it do?** — For functions: the action is clear from the name alone
3. **What are the boundaries?** — The name hints at scope, lifetime, or constraints

If a name requires a comment to be understood, the name is wrong.

## Naming Antipatterns

### Names That Lie

| Antipattern | Problem | Fix |
|-------------|---------|-----|
| `accountList` when it's a Set | Wrong data structure in name | `accounts` (just use plural) |
| `processData_v2` | Version control in names | Use version control, not naming |
| `getUser()` that also logs and caches | Name doesn't reveal side effects | `fetchAndCacheUser()` or split |
| `isEnabled` that modifies state | Query name hides a command | Separate query from mutation |

### Names That Don't Try

| Antipattern | Problem | Fix |
|-------------|---------|-----|
| `data`, `info`, `item`, `thing` | Generic to the point of meaningless | Use domain-specific terms |
| `tmp`, `val`, `x` beyond tiny scope | Forces reader to track mentally | `currentTemperature`, `retryCount` |
| `manager`, `handler`, `processor` | Vague role descriptions | Describe *what* it manages |
| `utils`, `helpers`, `misc` | Grab-bag namespaces | Group by domain or operation |

### Names That Mislead

| Antipattern | Problem | Fix |
|-------------|---------|-----|
| Inconsistent casing | Readers assume variables are lowercase | Follow language conventions exactly |
| Abbreviations (`usrRepo`, `passwd`) | Ambiguous unless universally known | Spell it out: `userRepository`, `password` |
| Noise words (`UserData` vs `UserInfo`) | Indistinguishable without reading code | Pick one and be consistent |
| Negated booleans (`isNotActive`) | Double negatives in conditions | Use positive: `isActive` |

### Names That Over-Specify

| Antipattern | Problem | Fix |
|-------------|---------|-----|
| Hungarian notation (`strName`, `iCount`) | Type system already encodes types | Just `name`, `count` |
| Gratuitous prefix (`GSDAccountService`) | Every class in app has same prefix | Use namespaces/packages |
| `AbstractBase` + `Impl` suffix | Naming the pattern not the concept | `UserService` + `DefaultUserService` |

## Decision Checklist

- [ ] Name reveals intent without needing a comment
- [ ] Name uses domain vocabulary where applicable
- [ ] Name follows language/project conventions
- [ ] Name is distinguishable from similar names nearby
- [ ] Boolean names read as yes/no questions
- [ ] Function names describe the action (verb phrases)
- [ ] Class names describe the thing (noun phrases)
- [ ] No abbreviations unless universally understood (`URL`, `HTTP`, `API`)
