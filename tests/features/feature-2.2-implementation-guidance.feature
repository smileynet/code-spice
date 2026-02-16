Feature: Implementation guidance activates during cook
  As a Line Cook user
  I want refactoring patterns and error handling guidance during cook
  So that I write better code during implementation

  Scenario: Refactoring skill activates for refactoring and code structure work
    Given the file skills/refactoring-patterns/SKILL.md exists
    When I read the YAML frontmatter description field
    Then the description should contain "refactoring" as an activation keyword
    And the description should contain "code structure" or "code smells"
    And the description should contain "complexity" or "extraction"

  Scenario: Refactoring skill has named pattern catalog
    Given the file skills/refactoring-patterns/SKILL.md exists
    When I read the skill content
    Then it should contain a pattern catalog table
    And each pattern should have a name and description
    And the catalog should include at least 10 named patterns

  Scenario: Refactoring skill includes trigger rules for when to apply
    Given the file skills/refactoring-patterns/SKILL.md exists
    When I read the Code Smell Triggers section
    Then it should include the five-line rule for method length
    And it should include type code smell detection
    And each trigger should map to specific refactoring patterns

  Scenario: Error handling skill activates for error handling and exception work
    Given the file skills/error-handling-patterns/SKILL.md exists
    When I read the YAML frontmatter description field
    Then the description should contain "error handling" as an activation keyword
    And the description should contain "exceptions" or "error codes"
    And the description should contain "result types" or "signaling"

  Scenario: Error handling skill covers exceptions, result types, robustness
    Given the file skills/error-handling-patterns/SKILL.md exists
    When I read the skill content
    Then it should cover exception-based error handling
    And it should cover Result/Outcome type patterns
    And it should discuss fail-fast vs robustness tradeoffs

  Scenario: Error handling skill has decision framework for strategy selection
    Given the file skills/error-handling-patterns/SKILL.md exists
    When I read the skill content
    Then it should contain an error strategy decision table
    And it should include recoverability as a key decision factor
    And it should help choose between different error handling strategies

  Scenario: Skill files have valid YAML frontmatter
    Given the file skills/refactoring-patterns/SKILL.md exists
    And the file skills/error-handling-patterns/SKILL.md exists
    When I check the YAML frontmatter of each skill
    Then each skill should have a name field matching its directory
    And each skill should have a description field of at least 50 characters
    And each frontmatter should start and end with triple dashes

  Scenario: Skills include cross-references to related skills
    Given the file skills/refactoring-patterns/SKILL.md exists
    And the file skills/error-handling-patterns/SKILL.md exists
    When I read the See Also sections
    Then refactoring-patterns should cross-reference related skills
    And error-handling-patterns should cross-reference related skills
