---
name: code-review
description: Code review process, effective feedback, PR best practices, team working agreements, review automation, AI-augmented review, and review antipatterns. Use when reviewing code, preparing PRs, giving review feedback, setting up review processes, writing review comments, or conducting code reviews during serve phase.
---

# Code Review

How to review code effectively, give actionable feedback, and build review processes that improve both code and teams.

## Quick Reference

### Review Goals (Priority Order)

| Goal | What You're Checking | Time Allocation |
|------|---------------------|-----------------|
| **Correctness** | Does it work? Edge cases, off-by-ones, null handling | 40% |
| **Design** | Right abstractions? Fits the architecture? | 25% |
| **Security** | Auth, input validation, data exposure, injection | 15% |
| **Maintainability** | Readable? Testable? Future-developer-friendly? | 15% |
| **Style** | Naming, formatting, conventions | 5% (automate this) |

### Effective Comment Templates (Triple-R Pattern)

Structure every non-trivial comment as **Request → Rationale → Result**:

| Component | Purpose | Example |
|-----------|---------|---------|
| **Request** | What to change | "Can we rename `item` to something more descriptive?" |
| **Rationale** | Why it matters | "`item` is vague and doesn't convey its role in discount calculation." |
| **Result** | What good looks like | "Something like `discountEligibleItem` captures the context." |

### Comment Severity Labels

Label comments so the author knows what's required vs. optional:

| Label | Meaning | Author Action |
|-------|---------|---------------|
| **blocker** | Must fix before merge | Address or discuss |
| **suggestion** | Improvement worth considering | Decide and respond |
| **nitpick** | Minor style/preference | Optional — take or leave |
| **question** | Need to understand intent | Explain the reasoning |
| **praise** | Something done well | Acknowledge (builds trust) |

## Review Process

### Before You Review

1. **Read the PR description** — understand the *why* before judging the *how*
2. **Check the scope** — is this PR a single logical change? Flag if too large
3. **Run the code** — for non-trivial changes, check out and test locally
4. **Check tests** — are new behaviors covered? Do existing tests still pass?

### During Review

Focus on **one pass per concern** to avoid cognitive overload:

1. **First pass: Correctness** — Does the logic handle all cases? What breaks?
2. **Second pass: Design** — Does this fit the codebase architecture?
3. **Third pass: Everything else** — Naming, tests, docs, edge cases

### After Review

- **Summarize** — leave a top-level comment with your overall assessment
- **Be explicit about approval** — "Approved with nitpicks" vs. "Needs changes before merge"
- **Follow up** — check that requested changes were addressed (don't rubber-stamp re-reviews)

## PR Best Practices (For Authors)

### The PR Contract

Every PR should communicate:

| Element | Purpose | Example |
|---------|---------|---------|
| **Title** | What changed (imperative mood) | "Add rate limiting to auth endpoints" |
| **Description** | Why and how | Problem, approach, tradeoffs, alternatives considered |
| **Proof** | Evidence it works | Tests passing, manual verification, screenshots/logs |
| **Risk** | What could go wrong | "Touches auth flow — needs security-focused review" |
| **Review focus** | Where human judgment matters most | "Please check the retry logic in lines 42-68" |

### Size Guidelines

| PR Size | Lines Changed | Review Quality | Recommendation |
|---------|--------------|----------------|----------------|
| Small | < 200 | High attention | Ideal |
| Medium | 200-400 | Good attention | Acceptable |
| Large | 400-800 | Declining attention | Split if possible |
| Huge | > 800 | Superficial at best | Must split |

Research shows reviewer attention drops sharply after ~400 lines. A 2000-line PR gets "LGTM" because nobody can review it properly.

### Self-Review Checklist (Before Requesting Review)

- [ ] PR description explains the *why*, not just the *what*
- [ ] Changes are a single logical unit (one concern per PR)
- [ ] Tests cover new behavior and edge cases
- [ ] No debug code, commented-out blocks, or TODOs without tickets
- [ ] Naming is clear and consistent with codebase conventions
- [ ] No secrets, credentials, or PII in the diff

## Team Working Agreement (TWA)

A Team Working Agreement (TWA) is a collaboratively created document that sets shared expectations for how the team does reviews. Create one together — never impose it top-down.

### TWA Template

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

### Review Cadence

Blocked PRs block features. Establish review rhythms:

- **SLA target:** First response within 4 hours (business hours)
- **Review windows:** Dedicated review time (e.g., first hour of day)
- **Rotation:** Distribute reviews to avoid bottlenecks on senior devs
- **Escalation:** If a PR has no reviewer after N hours, auto-assign or notify

## Review Automation

### What to Automate vs. What Needs Human Judgment

| Automate (Machines) | Human Review (Judgment) |
|---------------------|------------------------|
| Style and formatting (linters) | Architecture and design fit |
| Common bug patterns (static analysis) | Business logic correctness |
| Security vulnerability scanning | Naming and abstraction quality |
| Test coverage thresholds | Test *quality* (not just coverage) |
| PR size / complexity alerts | Knowledge sharing and mentoring |
| Dependency vulnerability checks | Tradeoff evaluation |

**Rule:** If a review comment could be written by a regex, it should be automated. Free human reviewers for judgment calls.

### Automation Layers

| Layer | Tool Category | Purpose |
|-------|--------------|---------|
| **Pre-commit** | Formatters, linters | Catch style issues before push |
| **CI pipeline** | Tests, SAST, coverage | Gate on correctness and security |
| **PR bot** | Size checks, label enforcement | Enforce PR hygiene |
| **Post-merge** | Dependency scanning, DAST | Catch deployment-time issues |

## AI-Augmented Code Review

AI review tools are rapidly maturing (2025-2026), but the collaboration model matters more than the tool choice.

### The AI-Human Review Partnership

| Phase | AI Role | Human Role |
|-------|---------|------------|
| **First pass** | Flag bugs, style issues, missing tests, security patterns | Skip — let AI handle the mechanical scan |
| **Deep review** | Suggest refactoring, identify duplication | Architecture fit, business logic, naming quality |
| **Final sign-off** | Summarize findings, check coverage | Approve or request changes — always human |

**AI is a reviewer, not an approver.** AI catches what humans miss (patterns across thousands of lines). Humans catch what AI misses (intent, context, organizational knowledge). Neither replaces the other.

### What AI Catches Well

- Common bug patterns (null derefs, off-by-ones, resource leaks)
- Style violations and inconsistencies
- Missing error handling
- Test gaps and edge cases
- Security vulnerability patterns (injection, XSS, auth issues)
- Code duplication across files

### What AI Misses

- Whether the code solves the *right problem*
- Architectural fit with the broader system
- Business rule correctness
- Naming quality and abstraction appropriateness
- Institutional context ("we tried this before and it failed because...")
- Whether the change aligns with the team's roadmap

### AI Review Pitfalls

| Pitfall | Problem | Mitigation |
|---------|---------|------------|
| **Alert fatigue** | Too many low-value comments | Tune thresholds; suppress nitpicks |
| **False authority** | Team treats AI comments as mandates | Label AI suggestions clearly; human decides |
| **Deskilling** | Reviewers defer to AI on everything | Require human summary comment on every PR |
| **Larger PRs** | AI makes writing easy, PRs grow ~18% | Enforce size limits regardless of authorship |

### AI-Generated Code Review

Code written by AI requires *more* review rigor, not less:

- AI-generated code has 1.75x more logic errors than human code
- 45% of AI-generated code contains security vulnerabilities
- Authors must understand and explain every line — "the AI wrote it" is not a defense
- Require proof (tests, manual verification) before review begins

`(see code-quality-foundations -> Code Should Work, Code Should Keep Working)`

## Review Antipatterns

### The Eight Review Antipatterns

| Antipattern | Symptom | Fix |
|-------------|---------|-----|
| **Rubber-stamping** | "LGTM" without reading the code | Require specific comment on at least one aspect |
| **Nitpicking** | 20 comments about spacing, zero about logic | Automate style; focus comments on design |
| **Gatekeeping** | One person blocks all merges with personal preferences | TWA defines objective standards; rotate reviewers |
| **Ghost reviewing** | Review assigned, no response for days | SLA with escalation; review rotation |
| **Bike-shedding** | Lengthy debate on trivial decisions | Time-box discussions; "author decides" for preferences |
| **Drive-by reviewing** | Comments without context or follow-up | Require summary; follow up on requested changes |
| **Scope creep** | "While you're here, can you also..." | New work gets its own PR and ticket |
| **Approval hoarding** | Requiring 4+ approvals "for safety" | 1-2 approvals with clear ownership; more is friction |

`(see code-antipatterns -> Pattern Recognition)`

<details>
<summary>The emergency playbook</summary>

Sometimes you need to bypass normal review. Have a pre-agreed protocol:

| Situation | Process | Safeguards |
|-----------|---------|------------|
| **Production outage** | Single senior approval + deploy | Post-incident review within 24h |
| **Security patch** | Security team fast-track | Audit log; full review within 48h |
| **Time-critical hotfix** | Pair with reviewer in real-time | Document the bypass; retroactive PR |

**Rules for emergency bypasses:**
1. Never skip review silently — always document
2. Retroactive review is mandatory, not optional
3. If you bypass more than once a month, your process has a deeper problem
</details>

<details>
<summary>Code reviews and pair/mob programming</summary>

Pair and mob programming can complement or partially replace traditional async review:

| Mode | When It Fits | Review Implication |
|------|-------------|-------------------|
| **Solo + async review** | Independent work, distributed teams | Standard PR review process |
| **Pair programming** | Complex features, onboarding, knowledge transfer | Lighter review (real-time feedback already happened) |
| **Mob programming** | Critical architecture, team alignment | Minimal review (whole team already participated) |

Pair/mob sessions don't eliminate the value of a fresh-eyes review, but they reduce the need for extensive async feedback because design discussions happened in real time.
</details>

## Decision Tables

### "What Should I Focus on in This Review?"

| Signal | Focus Area | Why |
|--------|-----------|-----|
| New contributor's PR | Correctness + mentoring | Build their understanding of conventions |
| Touches auth/payments/security | Security-first review | High-impact failure domain |
| Large refactoring | Design + test coverage | Structural changes need architectural validation |
| Bug fix | Correctness + regression tests | Verify root cause addressed, not just symptom |
| New feature | Design + maintainability | Will this age well? Is it tested? |
| Performance-critical path | Correctness + efficiency | Algorithmic review, benchmark evidence |
| AI-generated code | Everything + extra scrutiny | Higher defect rate; verify author understands it |
| Dependency update | Security + compatibility | Check changelogs, breaking changes, CVEs |

### "Should I Approve This PR?"

| Condition | Decision |
|-----------|----------|
| All blockers addressed, tests pass, design is sound | Approve |
| Minor nitpicks only, no functional concerns | Approve with comments |
| Design concerns but implementation is correct | Request changes (design discussion needed) |
| Missing tests for new behavior | Request changes |
| Security concerns | Request changes (escalate if needed) |
| Too large to review effectively | Request split |
| Don't understand the domain well enough | Defer to qualified reviewer |

## Checklists

### Reviewer Checklist

- [ ] PR description explains intent clearly
- [ ] Changes are appropriately scoped (single concern)
- [ ] Logic handles edge cases and error paths
- [ ] New behavior has test coverage
- [ ] No security concerns (auth, injection, data exposure)
- [ ] Naming and abstractions fit the codebase
- [ ] No performance regressions in hot paths
- [ ] Comments use severity labels (blocker/suggestion/nitpick)

### Review Culture Health Check

- [ ] Average first-response time < 4 hours
- [ ] Reviews include praise, not just criticism
- [ ] Junior developers review senior developers' code (both directions)
- [ ] Disagreements resolved by TWA standards, not authority
- [ ] Automation handles style enforcement (humans focus on design)
- [ ] Emergency bypasses are documented and retroactively reviewed

## See Also

- **code-quality-foundations** — Quality pillars and goals that reviews enforce `(see code-quality-foundations -> The Six Pillars)`
- **code-antipatterns** — Common patterns to watch for during review `(see code-antipatterns -> Pattern Recognition)`
- **code-readability** — Readability standards to apply in review `(see code-readability -> Naming and Structure)`
- **code-testing-quality** — Evaluating test quality during review `(see code-testing-quality -> Test Strategy)`
