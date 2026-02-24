---
name: code-review
description: Code review process, effective feedback, PR best practices, team working agreements, review automation, AI-augmented review, and review antipatterns. Use when reviewing code, preparing PRs, giving review feedback, setting up review processes, writing review comments, or conducting code reviews during serve phase.
---

# Code Review

## Review Goals (Priority Order)

| Goal | What You're Checking | Time Allocation |
|------|---------------------|-----------------|
| **Correctness** | Does it work? Edge cases, off-by-ones, null handling | 40% |
| **Design** | Right abstractions? Fits the architecture? | 25% |
| **Security** | Auth, input validation, data exposure, injection | 15% |
| **Maintainability** | Readable? Testable? Future-developer-friendly? | 15% |
| **Style** | Naming, formatting, conventions | 5% (automate this) |

## Effective Comment Templates (Triple-R Pattern)

| Component | Purpose | Example |
|-----------|---------|---------|
| **Request** | What to change | "Can we rename `item` to something more descriptive?" |
| **Rationale** | Why it matters | "`item` is vague and doesn't convey its role in discount calculation." |
| **Result** | What good looks like | "Something like `discountEligibleItem` captures the context." |

## Comment Severity Labels

| Label | Meaning | Author Action |
|-------|---------|---------------|
| **blocker** | Must fix before merge | Address or discuss |
| **suggestion** | Improvement worth considering | Decide and respond |
| **nitpick** | Minor style/preference | Optional — take or leave |
| **question** | Need to understand intent | Explain the reasoning |
| **praise** | Something done well | Acknowledge (builds trust) |

## Team Working Agreement (TWA) Template

| Area | Questions to Answer |
|------|-------------------|
| **Response time** | How quickly should reviews start? (e.g., within 4 business hours) |
| **Review depth** | What's expected? (checklist-based? architecture-level?) |
| **PR size limits** | Maximum lines? When must PRs be split? |
| **Approval policy** | How many approvals to merge? Who can approve? |
| **Comment conventions** | Which severity labels? Required vs. optional feedback? |
| **Automation baseline** | What's automated? (linting, formatting, security scans) |
| **Escalation** | What if reviewer and author disagree? |
| **Exceptions** | Emergency/hotfix bypass process? |

## Review Antipatterns

| Antipattern | Symptom | Fix |
|-------------|---------|-----|
| **Rubber-stamping** | "LGTM" without reading the code | Require specific comment on at least one aspect |
| **Nitpicking** | 20 comments about spacing, zero about logic | Automate style; focus comments on design |
| **Gatekeeping** | One person blocks all merges with personal preferences | TWA defines objective standards; rotate reviewers |
| **Ghost reviewing** | Review assigned, no response for days | SLA with escalation; review rotation |
| **Bike-shedding** | Lengthy debate on trivial decisions | Time-box discussions; "author decides" for preferences |
| **Drive-by reviewing** | Comments without context or follow-up | Require summary; follow up on requested changes |
| **Scope creep** | "While you're here, can you also..." | New work gets its own PR and ticket |
| **Approval hoarding** | Requiring 4+ approvals "for safety" | 1-2 approvals with clear ownership |

## AI-Augmented Review (2025-2026)

| Concern | What AI Catches Well | What Needs Human Judgment |
|---------|---------------------|--------------------------|
| **Bugs** | Null derefs, off-by-ones, resource leaks | Business logic correctness |
| **Style** | Inconsistencies, formatting | Naming quality, abstraction appropriateness |
| **Security** | Injection, XSS, auth issues | Threat model fit |
| **Coverage** | Missing test coverage | Test *quality* |
| **Architecture** | Duplication across files | Whether the code solves the *right problem* |

**AI-generated code requires *more* review rigor:** 1.75x more logic errors than human code, 45% contain security vulnerabilities. Authors must understand and explain every line.

## Decision Tables

### "What Should I Focus on in This Review?"

| Signal | Focus Area |
|--------|-----------|
| New contributor's PR | Correctness + mentoring |
| Touches auth/payments/security | Security-first review |
| Large refactoring | Design + test coverage |
| Bug fix | Correctness + regression tests |
| AI-generated code | Everything + extra scrutiny |

### "Should I Approve This PR?"

| Condition | Decision |
|-----------|----------|
| All blockers addressed, tests pass, design is sound | Approve |
| Minor nitpicks only | Approve with comments |
| Design concerns but implementation is correct | Request changes |
| Missing tests for new behavior | Request changes |
| Too large to review effectively | Request split |

## Reviewer Checklist

- [ ] PR description explains intent clearly
- [ ] Changes are appropriately scoped (single concern)
- [ ] Logic handles edge cases and error paths
- [ ] New behavior has test coverage
- [ ] No security concerns (auth, injection, data exposure)
- [ ] Naming and abstractions fit the codebase
- [ ] Comments use severity labels (blocker/suggestion/nitpick)
