Feature: Code quality guidance activates during brainstorm and scope
  As a Line Cook user
  I want code readability, naming, and tradeoff knowledge to activate during planning
  So that I plan higher-quality code from the start

  Scenario: Readability skill covers naming, comments, structure, nesting
    Given the file skills/code-readability/SKILL.md exists
    When I read the skill content
    Then it should contain guidance on comments (when helpful vs harmful)
    And it should cover code structure (nesting depth, function length)
    And it should have a Quick Reference readability checklist

  Scenario: Naming skill covers descriptive names, conventions, magic values
    Given the file skills/code-naming/SKILL.md exists
    When I read the skill content
    Then it should contain a naming decision table
    And it should cover descriptive names vs comments tradeoff
    And it should identify naming antipatterns

  Scenario: Tradeoffs skill covers duplication, flexibility, optimization, API design
    Given the file skills/software-tradeoffs/SKILL.md exists
    When I read the skill content
    Then it should contain a tradeoff decision matrix
    And it should cover duplication vs DRY
    And it should cover flexibility vs complexity
    And it should cover performance optimization tradeoffs

  Scenario: All skills have quick reference and decision tables
    Given all three planning skills exist
    When I check each skill's structure
    Then each should have a "Quick Reference" section
    And each should contain at least one decision table
    And each should have cross-references to related skills

  Scenario: All skills contain book-specific language examples
    Given all three planning skills exist
    When I check for language-specific content
    Then at least one skill should contain Java pseudocode examples
    And at least one skill should contain TypeScript examples
