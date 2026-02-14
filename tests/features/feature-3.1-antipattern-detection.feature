Feature: Antipattern detection during plan-audit
  As a Line Cook user
  I want antipattern detection and plan quality checklists during plan-audit
  So that I catch code quality issues before implementation

  Scenario: Antipatterns skill has categorized catalog
    Given the file skills/code-antipatterns/SKILL.md exists
    When I read the skill content
    Then it should organize antipatterns into categories
    And categories should include Surprise, Misuse, Complexity, and Premature patterns
    And it should list at least 10 antipatterns

  Scenario: Antipatterns include symptoms, examples, fixes
    Given the code-antipatterns skill exists
    When I check individual antipattern entries
    Then each should include symptoms to watch for
    And each should include a before example
    And each should include a fix or after example

  Scenario: Plan audit has structured scorecard
    Given the file skills/code-plan-audit/SKILL.md exists
    When I read the skill content
    Then it should contain a plan quality scorecard
    And the scorecard should include at least 10 critical checks
    And it should produce an actionability score

  Scenario: Plan audit maps to Line Cook workflow
    Given the code-plan-audit skill exists
    When I check for workflow integration
    Then it should reference /line:plan-audit workflow
    And it should check for error handling strategy completeness
    And it should check for naming and readability considerations
