Feature: Implementation guidance activates during cook
  As a Line Cook user
  I want refactoring patterns and error handling guidance during cook
  So that I write better code during implementation

  Scenario: Refactoring skill has named pattern catalog
    Given the file skills/refactoring-patterns/SKILL.md exists
    When I read the skill content
    Then it should contain a pattern catalog table
    And each pattern should have a name and description
    And the catalog should include at least 10 named patterns

  Scenario: Refactoring skill includes trigger rules for when to apply
    Given the refactoring-patterns skill exists
    When I check for trigger rules
    Then it should include the five-line rule
    And it should include type code smell detection
    And each trigger should map to specific refactoring patterns

  Scenario: Error handling skill covers exceptions, result types, robustness
    Given the file skills/error-handling-patterns/SKILL.md exists
    When I read the skill content
    Then it should cover exception-based error handling
    And it should cover Result/Outcome type patterns
    And it should discuss fail-fast vs robustness tradeoffs

  Scenario: Error handling skill has decision framework for strategy selection
    Given the error-handling-patterns skill exists
    When I check for decision framework
    Then it should contain an error strategy decision table
    And it should include recoverability as a key decision factor
    And it should help choose between different error handling strategies
