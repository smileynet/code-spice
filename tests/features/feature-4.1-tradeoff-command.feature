Feature: Tradeoff analysis command
  As a developer facing a design decision
  I want to run /code:tradeoff
  So that I can systematically evaluate options using structured tradeoff frameworks

  Scenario: Command is invokable and produces output
    Given the file commands/tradeoff.md exists
    When I check the command frontmatter
    Then it should have a valid name and description
    And it should list allowed tools

  Scenario: Command references tradeoff frameworks
    Given the tradeoff command exists
    When I read the command instructions
    Then it should reference the software-tradeoffs skill
    And it should include a catalog of tradeoff dimensions

  Scenario: Command asks clarifying questions
    Given the tradeoff command exists
    When I check the process steps
    Then it should ask the user to describe the design decision
    And it should walk through relevant dimensions with questions

  Scenario: Output includes recommendation with rationale
    Given the tradeoff command exists
    When I check the output format
    Then it should produce a structured analysis
    And it should include pros and cons for each option
    And it should include a recommendation with rationale

  Scenario: Command without YAML frontmatter should fail validation
    Given a tradeoff command file without YAML frontmatter
    When I validate it against command requirements
    Then validation should report missing frontmatter

  Scenario: Command missing AskUserQuestion in allowed-tools should be flagged
    Given a tradeoff command without AskUserQuestion in allowed-tools
    When I validate it against command requirements
    Then validation should report the missing tool as required for interactive flow
