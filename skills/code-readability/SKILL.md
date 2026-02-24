---
name: code-readability
description: Code readability patterns covering comments, function decomposition, nesting, naming conventions, and code structure. Use when evaluating whether code is easy to understand, deciding when and how to write comments, decomposing functions, reducing nesting depth, improving code structure, or reviewing code for readability. Covers comment strategy, function length, abstraction level mixing, nesting reduction, anonymous function readability, and making bad code visually obvious.
---

# Code Readability

## Quick Reference

### The Readability Checklist

| Dimension | Question | If No... |
|-----------|----------|----------|
| **Names** | Can I understand what this does from the names alone? | Rename variables, functions, classes |
| **Comments** | Do comments explain *why*, never *what*? | Delete "what" comments; improve names instead |
| **Function length** | Does each function do one thing at one abstraction level? | Extract methods |
| **Nesting** | Is nesting 2 levels or fewer? | Use early returns, extract helper functions |
| **Consistency** | Does this code follow the same style as surrounding code? | Adopt the project's conventions |
| **Surprise factor** | Would another engineer expect this behavior from reading the signature? | Rename or restructure to match expectations |

### The Comment Decision Table

| Situation | Action | Example |
|-----------|--------|---------|
| Code does something non-obvious | Write a *why* comment | `// Retry limit set to 3 per SLA with payments team` |
| Name doesn't convey intent | Fix the name, don't add a comment | Rename `d` to `elapsedDays` |
| Complex algorithm or formula | Comment the approach, not the steps | `// Uses Dijkstra's — graph is sparse` |
| Workaround for a bug or limitation | Comment what and why | `// Safari doesn't support ResizeObserver in iframes (WebKit #219765)` |
| Legal or licensing requirement | Keep the comment | `// SPDX-License-Identifier: MIT` |
| Commented-out code | Delete it | Version control remembers |
| TODO or FIXME | Include a ticket reference | `// TODO(CS-142): Replace with batch API` |
| Section header in a long function | Extract a function instead | The function name becomes the "header" |

### Documentation Value Hierarchy

| Level | Reach | Maintenance Cost | Reliability |
|-------|-------|-----------------|-------------|
| **Good names** | Every call site | Zero (name *is* the code) | Always current |
| **Type signatures** | Every caller, IDE | Low (compiler verifies) | Enforced |
| **Comments** | Readers of this file only | Medium (can drift) | Trust but verify |
| **External docs** | Those who find them | High (often forgotten) | Frequently stale |

## Decision Tables

### "Should I write a comment?"

| The comment would explain... | Write it? | Instead... |
|-----------------------------|-----------|------------|
| What the code does | No | Improve the name or extract a function |
| Why the code does it this way | Yes | — |
| What a variable holds | No | Rename the variable |
| A workaround or hack | Yes | Include link to issue/ticket |
| The algorithm being used | Yes (if non-obvious) | — |
| A section of a long function | No | Extract the section into a named function |

### "Is this function too long?"

| Signal | Verdict |
|--------|---------|
| Can describe in one sentence without "and" | Length is fine |
| Has blank-line-separated sections | Extract sections |
| Mixes abstraction levels | Split by level |
| Requires scrolling and mental bookmarking | Extract for readability |
| Every line contributes to one operation | Length is fine |

## Readability Checklist

Before committing code, verify:

- [ ] Names reveal intent without needing comments
- [ ] Comments explain *why*, not *what*
- [ ] No commented-out code
- [ ] Functions operate at a single abstraction level
- [ ] Nesting is 2 levels or fewer
- [ ] Anonymous functions are short and their purpose is obvious
- [ ] Formatting follows project conventions
- [ ] Code follows the same patterns as surrounding code
