---
name: code-pruning
description: Dead code detection strategies, safe removal processes, dependency pruning, and bloat metrics for systematically reducing codebase dead weight. Use when evaluating codebase health during architecture-audit, performing cleanup during cook, reviewing unused dependencies, removing commented-out code, or measuring code bloat. Covers static and dynamic analysis, language-specific tool recommendations, the identify-verify-deprecate-delete-test-audit removal process, and the lava flow antipattern.
---

# Code Pruning

Strategies for detecting and safely removing dead code, unused dependencies, and accumulated bloat. The cure that complements YAGNI's prevention — while YAGNI stops unnecessary code from being written, pruning removes unnecessary code that already exists.

`(see code-yagni -> YAGNI vs. Good Design)`

## Quick Reference

### Pruning Checklist

Run this during architecture review or scheduled maintenance:

- [ ] **Dead code scan** — Run static analysis for unreachable code, unused exports, dead functions
- [ ] **Dependency audit** — Check for unused direct dependencies and outdated transitive deps
- [ ] **Commented-out code** — Search for disabled code blocks; delete or move to a branch
- [ ] **Speculative abstractions** — Find single-implementation interfaces, unused extension points
- [ ] **Coverage gaps** — Cross-reference uncovered code with production usage data
- [ ] **Build time check** — Compare current build/test time against baseline

### Detection Approach Table

| Approach | Finds | Misses | Best For |
|----------|-------|--------|----------|
| **Static analysis** | Unreachable code, unused exports, dead imports | Dynamically dispatched code, reflection | Day-to-day development, CI gates |
| **Dynamic analysis** | Code never executed in production | Rarely-used but necessary paths (error handlers, migration code) | Production systems with traffic data |
| **Combined (static + dynamic)** | Highest-confidence dead code | Still misses edge cases | Large-scale cleanup campaigns |
| **Manual review** | Intent-level dead code (obsolete features, outdated workarounds) | Requires human judgment, doesn't scale | Code review, refactoring sessions |

## Dead Code Detection

### Static Analysis

Static analysis examines code structure without executing it. Tools parse the AST or dependency graph to find symbols that no code path reaches.

**What it finds:**
- Unused functions, classes, and variables
- Unreachable code after unconditional returns or throws
- Unused imports and exports
- Dead branches in conditionals (e.g., `if False:`)

**What it misses:**
- Reflection and dynamic dispatch (`getattr`, `eval`, `require(variable)`)
- Framework magic (decorators, dependency injection, annotation-based wiring)
- Entry points not visible to the tool (CLI handlers, signal handlers, cron jobs)

**Reducing false positives:**
1. Configure known entry points (test runners, CLI commands, framework hooks)
2. Use allowlists for intentionally dynamic patterns
3. Treat low-confidence results as candidates for manual review, not automatic deletion

`(see refactoring-patterns -> Try Delete Then Compile)`

### Dynamic Analysis

Dynamic analysis instruments running code to record which paths execute in production. What never executes is a strong dead code signal — but only for the traffic patterns observed.

**What it finds:**
- Features deployed but never triggered by real users
- API endpoints with zero traffic
- Code paths that exist but aren't exercised in production

**What it misses:**
- Seasonal code (year-end reporting, holiday features)
- Error handlers that activate only during outages
- Migration code run once per deployment
- Disaster recovery paths

**Observation window:** Log suspected dead code for 1-4 weeks before removal. Shorter windows miss infrequent paths. Longer windows delay cleanup without proportional confidence gain.

**The coverage trap:** 100% test coverage does not mean 100% of code is needed. Tests can cover dead code, making it look alive. Cross-reference test coverage with production coverage for accurate signals.

### Combined Approach: The SCARF Pattern

Meta's Systematic Code and Asset Removal Framework (SCARF) demonstrates the gold standard for large-scale dead code removal. Over five years, SCARF deleted 100M+ lines of code across 370,000+ automated change requests.

**How it works:**
1. **Static graph** — Build a dependency graph from compiler data (AST, import graph)
2. **Dynamic overlay** — Annotate the graph with production traffic and runtime usage data
3. **Semantic rules** — Apply domain-specific rules (e.g., "class referenced but never instantiated" = dead)
4. **Automated removal** — Generate change requests that delete identified dead code
5. **Confidence tiers** — High-confidence changes merge automatically; lower-confidence changes require human review

**Key insight:** Moving from symbol-level to full graph analysis increased dead code detection by ~50% on Meta's largest codebases. The combination of static structure and dynamic runtime data catches what neither approach finds alone.

<details>
<summary>Adapting SCARF for smaller teams</summary>

You don't need Meta's infrastructure to apply the pattern:

1. **Static graph** — Use language-specific tools (see tool table below) to find unreferenced code
2. **Dynamic overlay** — Add logging to suspected dead code: `log.warn("DEAD_CODE_CANDIDATE: feature_x called")`. Monitor for 2-4 weeks.
3. **Semantic rules** — Check framework-specific patterns manually (unused routes, unregistered handlers, orphaned templates)
4. **Removal** — Delete with confidence after the observation window passes silently
5. **Verification** — Run full test suite after removal; monitor production for regressions

The principle scales down: combine what the tools tell you (static) with what production tells you (dynamic) before deleting.
</details>

## Language-Specific Tool Recommendations

*Recommendations current as of February 2026. Tool ecosystems change — verify before adopting.*

| Language | Tool | What It Does | Notes |
|----------|------|-------------|-------|
| **JS/TS** | Knip | Finds unused files, exports, and dependencies via module graph analysis | Zero-config for most projects; supersedes ts-prune (archived). 100+ framework plugins. |
| **JS/TS** | depcheck | Finds unused and missing npm dependencies | Analyzes `package.json` against actual `require`/`import` usage |
| **Python** | Vulture | Finds unused functions, classes, variables, and unreachable code | Confidence-scored results (60-100%); lightweight, fast |
| **Python** | deadcode | Scope-aware dead code detection with auto-fix | Improves on Vulture with namespace tracking; `--fix` option for automatic removal |
| **Python** | autoflake | Removes unused imports and variables | Auto-fixer powered by pyflakes; safe defaults (stdlib-only) |
| **Java** | PMD | 400+ static analysis rules including dead code detection | v7.x; supports incremental analysis for large codebases |
| **Go** | deadcode (`golang.org/x/tools`) | Finds unreachable functions using call graph analysis | Part of the official Go tools ecosystem |
| **Multi** | SonarQube | Dead code, smells, vulnerabilities across 35+ languages | Enterprise-grade; CI/CD quality gate enforcement |

**Choosing a tool:**
- **Single project, one language:** Use the language-specific tool for the fastest, most accurate results
- **Monorepo, multiple languages:** SonarQube for unified reporting; supplement with language-specific tools for deeper analysis
- **CI integration:** Most tools above support CI runners — add dead code checks alongside linting

## Safe Removal Process

Deleting code feels risky. This process manages the risk systematically.

### Step 1: Identify Candidates

Run static analysis tools to generate a candidate list. Categorize findings:

| Category | Confidence | Action |
|----------|-----------|--------|
| **Unreachable code** (after unconditional return/throw) | High | Delete immediately |
| **Unused private functions/variables** | High | Delete immediately |
| **Unused exports with no external consumers** | Medium | Verify no dynamic imports, then delete |
| **Low-confidence static findings** | Low | Move to Step 2 for dynamic verification |

### Step 2: Verify with Dynamic Data

For medium and low-confidence candidates, add production instrumentation:

```python
# Add logging to suspected dead code
import logging
logger = logging.getLogger(__name__)

def maybe_dead_function():
    logger.warning("DEAD_CODE_CANDIDATE: maybe_dead_function called at %s", __name__)
    # ... original implementation ...
```

Monitor for 1-4 weeks. If the log never fires, proceed to removal. If it fires, investigate — the code is alive but perhaps should be refactored.

### Step 3: Deprecate (for public APIs)

For code with external consumers (libraries, APIs, shared packages):

1. Mark with `@deprecated` or language equivalent
2. Document the alternative in the deprecation message
3. Communicate the timeline (one major version cycle is conventional)
4. Remove in the next major version

For internal code with no external consumers, skip this step — deprecation is overhead without an audience.

### Step 4: Delete

**Delete, don't comment out.** Version control is your safety net.

```bash
# To recover deleted code later:
git log -G "function_name" --all        # Find the commit that deleted it
git show <commit>~1:path/to/file.py     # View the file before deletion
```

**Delete atomically:** One concern per commit. "Remove unused PaymentV1 module" is reviewable. "Clean up various dead code" across 50 files is not.

### Step 5: Test

Run the full test suite after removal. If tests fail:
- **Test tested dead code:** The test itself is dead — delete it too
- **Test depends on removed code:** The test has a hidden coupling — fix the test
- **Production code depends on removed code:** Your static analysis had a false positive — restore and investigate

### Step 6: Audit

Schedule periodic pruning (quarterly or per-release):
- Re-run static analysis tools
- Review dependency manifests
- Check build time and test time trends
- Document what was removed and why (commit messages suffice)

Goldman Sachs advocates that "delete" should be a recognized stage in the software component lifecycle, not an afterthought. Regular pruning prevents accumulation.

## Dependency Pruning

Unused dependencies are invisible weight — they increase install time, expand attack surface, and add transitive dependency risk.

### Finding Unused Dependencies

| Approach | What It Catches |
|----------|----------------|
| **Manifest vs. imports** | Dependencies declared in `package.json`/`requirements.txt` but never imported |
| **Transitive analysis** | Dependencies you use only because another dep re-exports them (fragile) |
| **Bundle analysis** | Dependencies included in the build output but never called at runtime |

### Common False Positives

| Situation | Why It Looks Unused | What To Do |
|-----------|-------------------|------------|
| **Peer dependency** | Not imported directly, but required by another package | Keep — check framework docs |
| **CLI tool** | Used in npm scripts or CI, not imported in source | Keep — verify scripts reference it |
| **Type-only import** | Imported only in `.d.ts` or type annotations | Check if types are used; move to `devDependencies` if build-only |
| **Plugin/loader** | Referenced in config file, not source code | Keep — verify config references it |
| **Runtime-only** | Loaded via dynamic `require()` or env-based imports | Keep — add to tool's allowlist |

### Safe Dependency Removal

1. Remove the dependency from the manifest
2. Run `install` to verify no peer dependency errors
3. Build the project
4. Run the full test suite
5. If everything passes, the dependency was genuinely unused

## Commented-Out Code

Commented-out code is dead code that pretends it might be useful someday. It almost never is.

**Why it should be deleted:**

| Problem | Impact |
|---------|--------|
| **Cognitive load** | Developers stop to read it, wondering if it matters, derailing their workflow |
| **Visual clutter** | Large commented blocks hide the active code that actually matters |
| **Becomes outdated** | It is never tested, linted, or executed — APIs it references may no longer exist |
| **False safety** | "I'll just comment it out in case we need it" — but version control already preserves everything |

**The rule:** Delete it. `git log` remembers. If you need the code back, it's one `git show` away.

<details>
<summary>The one exception</summary>

Code waiting on an incomplete third-party integration may temporarily live in a feature branch. The TODO should be tracked in an issue tracker, not in a code comment. Once the integration is ready, the code moves to main as active code, not commented-out code.
</details>

`(see code-antipatterns -> Lava Flow)`

## Bloat Metrics

Track these metrics over time to detect accumulation before it becomes a crisis.

### Key Indicators

| Metric | What It Measures | Warning Sign |
|--------|-----------------|--------------|
| **Dead code %** | Ratio of unreachable code to total codebase | Rising trend over multiple releases |
| **Dependency count** | Number of direct dependencies | Growing without corresponding feature growth |
| **Inverse churn rate** | Files that haven't been modified in 6+ months | High ratio of untouched files suggests dead or forgotten code |
| **Build time** | Time from source to deployable artifact | Increasing build time with stable feature set |
| **Test time** | Full test suite execution time | Tests growing faster than features |
| **Install size** | Size of installed dependencies | Growing without new features |

### Reading the Signals

- **Dead code % rising:** Static analysis tools aren't running in CI, or results are being ignored
- **Dependencies growing:** New libraries added but old ones never removed. Run dependency audit.
- **Inverse churn high:** Code exists but nobody touches it. Either it's stable and correct, or it's dead. Investigate.
- **Build time increasing:** More code to compile, more dependencies to resolve. Prune to recover speed.

## The Lava Flow Antipattern

Dead code that nobody dares delete because nobody is sure if it's still needed. Named after volcanic lava that hardens into an immovable landscape.

**How it forms:**
1. Feature built during a crunch, with minimal documentation
2. Original author leaves the team
3. New developers encounter it, don't understand it, don't touch it
4. Code accumulates protective cruft ("don't modify — here be dragons")
5. Eventually the codebase routes around the dead code rather than through it

**How to break it:**
1. **Identify** — Use static analysis to find code with zero callers
2. **Instrument** — Add logging to verify it's truly unused in production
3. **Communicate** — Ask the team: "Does anyone know what this does? Does anyone use it?"
4. **Delete** — If nobody claims it and production logs are silent, remove it
5. **Trust version control** — If it turns out to be needed, `git revert` or `git show` recovers it

**Prevention:** Every feature needs a documented owner. When an owner leaves, ownership transfers explicitly. Orphaned code is the precondition for lava flow.

`(see refactoring-patterns -> Try Delete Then Compile)`

## Decision Tables

### "How confident am I that this code is dead?"

| Evidence | Confidence | Recommended Action |
|----------|-----------|-------------------|
| Static analysis: zero references, no dynamic dispatch | High | Delete and run tests |
| Static analysis: zero references, but uses reflection/eval | Medium | Instrument in production first |
| Dynamic analysis: zero production calls for 4+ weeks | High | Delete and run tests |
| Dynamic analysis: zero calls for <1 week | Low | Extend observation window |
| Only called from tests, never from production code | High | Delete the code and its tests |
| Not called, but similar to code that is called | Low | Investigate — might be a template or fallback |

### "Should I prune this dependency?"

| Situation | Action |
|-----------|--------|
| Not imported anywhere in source or config | Remove — unused |
| Only imported in deleted/dead code | Remove — cascading dead code |
| Used, but a lighter alternative exists | Evaluate — only if migration cost is low |
| Used transitively by another dep | Keep — but note the fragile coupling |
| Dev dependency in production deps | Move to devDependencies |
| Pinned to an old version with known CVEs | Update or replace — security risk |

## Common Mistakes

### Pruning Without Tests

Deleting code without a test suite is gambling. You have no automated verification that the remaining code still works. If your test coverage is low, write characterization tests for the code you're keeping before deleting the code you're removing.

### Deleting Seasonal or Disaster-Recovery Code

Some code runs once a year (tax calculations, year-end reports) or only during incidents (failover, data recovery). Short observation windows will classify this as dead. Extend the window, or explicitly tag this code as intentionally infrequent.

### Commenting Out Instead of Deleting

Commenting out code is a half-measure that creates lava flow. If you're unsure, instrument it. If it's truly unused, delete it. Version control exists precisely for this purpose.

### Pruning as a Solo Activity

Large-scale pruning benefits from team awareness. Before a major cleanup:
1. Announce what you're planning to remove
2. Give the team a window to object (1-2 days)
3. Remove in atomic commits with clear messages
4. Monitor production after deployment

## See Also

- **code-yagni** — Prevention: frameworks for deciding what not to build in the first place `(see code-yagni -> Build-vs-Not-Build Decision Framework)`
- **refactoring-patterns** — Techniques for restructuring code, including Try Delete Then Compile for safe removal `(see refactoring-patterns -> Try Delete Then Compile)`
- **code-antipatterns** — Lava flow and other patterns that produce dead code `(see code-antipatterns -> Lava Flow)`
- **code-scope-boundaries** — Project-level analysis: when the entire project has outgrown its boundaries `(see code-scope-boundaries -> The Cohesion Test)`
