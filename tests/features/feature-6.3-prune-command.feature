Feature: Interactive pruning analysis command
  As a developer
  I want to run /code:prune on my codebase
  So that I get a structured analysis of dead code, unused dependencies, and scope issues with a prioritized removal plan

  Scenario: Command is invokable and produces output
    Given the file commands/prune.md exists
    When I read the command definition
    Then it should have valid YAML frontmatter with name and description
    And it should define a structured process with steps

  Scenario: Command walks through detection categories
    Given the /code:prune command exists
    When I check the process steps
    Then it should include dead code scan guidance
    And it should include unused dependency check
    And it should include speculative abstraction detection
    And it should include scope boundary analysis
    And it should include commented-out code review

  Scenario: Command asks clarifying questions
    Given the /code:prune command exists
    When I check for user interaction
    Then it should ask about primary languages
    And it should ask about project context

  Scenario: Output includes prioritized removal candidates
    Given the /code:prune command exists
    When I check the output format
    Then it should categorize findings by safety level
    And it should categorize findings by effort level
    And it should recommend a removal order

  Scenario: Output includes safety assessment
    Given the /code:prune command exists
    When I check the safety guidance
    Then it should classify candidates as Safe, Moderate, or Risky
    And it should recommend safe quick wins first
