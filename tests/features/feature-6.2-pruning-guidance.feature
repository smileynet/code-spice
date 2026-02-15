Feature: Dead code pruning guidance during maintenance
  As a developer maintaining a growing codebase
  I want dead code detection strategies and safe removal guidance
  So that I can systematically reduce bloat

  Scenario: Pruning skill covers static and dynamic detection
    Given the file skills/code-pruning/SKILL.md exists
    When I read the skill content
    Then it should describe static analysis detection approaches
    And it should describe dynamic analysis detection approaches
    And it should describe the combined approach pattern

  Scenario: Pruning skill has language-specific tool recommendations
    Given the code-pruning skill exists
    When I check for tool recommendations
    Then it should include tools for Python
    And it should include tools for JavaScript/TypeScript
    And it should include tools for Java
    And tool recommendations should include date stamps

  Scenario: Pruning skill has safe removal process
    Given the code-pruning skill exists
    When I check for removal guidance
    Then it should describe a multi-step safe removal process
    And steps should include identify, verify, deprecate, delete, and test
    And it should emphasize deleting over commenting out

  Scenario: Pruning skill covers dependency pruning
    Given the code-pruning skill exists
    When I check for dependency guidance
    Then it should address unused direct dependency detection
    And it should address transitive dependency awareness
    And it should address false positive handling

  Scenario: Pruning skill addresses commented-out code
    Given the code-pruning skill exists
    When I check for commented-out code guidance
    Then it should explain why commented-out code should be deleted
    And it should reference version control as the safety net
