Feature: YAGNI and scope analysis during planning phases
  As a Line Cook user
  I want YAGNI decision frameworks during brainstorm and scope and scope boundary analysis during architecture-audit
  So that I avoid building unnecessary features and can identify when a project needs splitting

  Scenario: YAGNI skill covers four costs framework
    Given the file skills/code-yagni/SKILL.md exists
    When I read the skill content
    Then it should describe the four costs of presumptive features
    And the costs should include build, delay, carry, and repair

  Scenario: YAGNI skill has build-vs-not-build decision table
    Given the code-yagni skill exists
    When I check for decision guidance
    Then it should contain a "build vs. not build" decision table
    And criteria should include concrete requirement, cost of later addition, and codebase malleability

  Scenario: YAGNI skill includes speculative generality detection
    Given the code-yagni skill exists
    When I check for detection signals
    Then it should list signals for speculative generality
    And signals should include one-implementation interfaces and unused extension points
    And it should include bloat antipatterns like gold plating and premature abstraction

  Scenario: Scope boundaries skill has cohesion test
    Given the file skills/code-scope-boundaries/SKILL.md exists
    When I read the skill content
    Then it should describe the cohesion test for project scope
    And it should reference the Single Responsibility Principle at project level

  Scenario: Scope boundaries skill has split-vs-keep framework
    Given the code-scope-boundaries skill exists
    When I check for splitting guidance
    Then it should include a split-vs-keep decision framework
    And it should describe when to split and when NOT to split
    And it should reference the Strangler Fig pattern for safe splitting

  Scenario: Scope boundaries skill includes scope creep warning signs
    Given the code-scope-boundaries skill exists
    When I check for warning signs
    Then it should list scope creep warning signs
    And signs should include expanding scope without schedule adjustment
    And signs should include the growing utils folder signal

  Scenario: Both skills cross-reference existing MLP skills
    Given the code-yagni and code-scope-boundaries skills exist
    When I check for cross-references
    Then code-yagni should reference code-antipatterns
    And code-yagni should reference software-tradeoffs
    And code-scope-boundaries should reference code-yagni
    And code-scope-boundaries should reference software-tradeoffs
