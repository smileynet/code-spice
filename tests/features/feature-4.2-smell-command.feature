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

  Scenario: Findings include name, location, category, and fix
    Given the smell command exists
    When I check individual finding format
    Then each should include the antipattern name
    And each should include file and line reference
    And each should include the category (Surprise, Misuse, Complexity, or Premature)
    And each should include a description
    And each should include a suggested fix

  Scenario: Command supports explicit file path arguments
    Given the smell command exists
    When I check for file path input support
    Then it should accept file paths as arguments
    And it should accept glob patterns

  Scenario: Clean scan produces CLEAN verdict
    Given the smell command exists
    When I check the output format for no findings
    Then it should display a CLEAN verdict
    And the output should indicate no findings detected

  Scenario: Verdict reflects severity of findings
    Given the smell command exists
    When I check the verdict logic
    Then CLEAN should mean no findings or only Notes
    And HAS_WARNINGS should mean Warnings but no Critical findings
    And HAS_CRITICAL should mean one or more Critical findings

  Scenario: No recent changes detected should inform the user
    Given no recent changes in the working tree
    When the smell command runs without arguments
    Then it should inform the user that no changes were detected
    And it should suggest specifying files to scan

  Scenario: Command without YAML frontmatter should fail validation
    Given a smell command file without YAML frontmatter
    When I validate it against command requirements
    Then validation should report missing frontmatter
