# Test Specification Template: Skill Creation Tasks

## Common Validation Criteria for All Skills

Every skill SKILL.md must pass these checks:

| Check | Expected | Notes |
|-------|----------|-------|
| YAML frontmatter | Valid with `name` and `description` | Description contains activation keywords |
| Quick Reference | Present near top of file | Scannable summary for quick use |
| Decision tables | At least one | Actionable guidance format |
| Cross-references | Links to related skills | `(see code-X -> Section)` format |
| Progressive disclosure | `<details>` tags for long sections | Keeps skill scannable |
| Line count | 200-400 lines | Fits context window |
| No copied text | Synthesized knowledge | Principles, not reproduced content |
| Research augmentation | Key concepts validated | Checked against current practices |
| Language examples | From source books where applicable | Java pseudocode, TypeScript, Java |

## Skill-Specific Criteria

### code-readability
- [ ] Covers comments (when helpful vs harmful)
- [ ] Covers code structure (nesting, function length)
- [ ] Includes readability checklist

### code-naming
- [ ] Naming decision table
- [ ] Boolean naming patterns
- [ ] Naming antipatterns catalog

### software-tradeoffs
- [ ] Tradeoff decision matrix
- [ ] Covers at least 5 tradeoff dimensions
- [ ] Each tradeoff has symptoms + decision criteria

### refactoring-patterns
- [ ] Named pattern catalog (10+ patterns)
- [ ] Rule-based triggers
- [ ] Before/After for each pattern

### error-handling-patterns
- [ ] Strategy comparison table
- [ ] Recoverability framework
- [ ] Modern error handling patterns (Result, Go errors)

### code-antipatterns
- [ ] Categorized catalog (Surprise/Misuse/Complexity/Premature)
- [ ] 10+ antipatterns
- [ ] Severity classification (Critical/Warning/Note)

### code-plan-audit
- [ ] Plan quality scorecard (10 checks)
- [ ] Maps to /line:plan-audit workflow
- [ ] Actionability score

### code-review
- [ ] Review process and goals
- [ ] Effective comment templates
- [ ] AI-augmented review section

### code-testing-quality
- [ ] Testing quality checklist
- [ ] Test structure patterns (AAA/GWT)
- [ ] Testing antipatterns
