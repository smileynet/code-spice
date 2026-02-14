Feature: Code smell detection command
  As a developer
  I want to run /code:smell on my recent changes
  So that I can detect implementation-level antipatterns before code review

  Scenario: Command scans recent changes
    Given the file commands/smell.md exists
    When I read the command instructions
    Then it should collect recent changes via git diff
    And it should read changed files for analysis

  Scenario: Detection references antipattern catalog
    Given the smell command exists
    When I check for antipattern references
    Then it should reference the code-antipatterns skill
    And it should scan for Surprise, Misuse, Complexity, and Premature patterns

  Scenario: Output categorized by severity
    Given the smell command exists
    When I check the output format
    Then findings should be categorized as Critical, Warning, or Note

  Scenario: Findings include name, location, fix
    Given the smell command exists
    When I check individual finding format
    Then each should include the antipattern name
    And each should include file and line reference
    And each should include a suggested fix
