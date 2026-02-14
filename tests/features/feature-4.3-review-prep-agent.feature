Feature: Review preparation command and quality critic agent
  As a developer
  I want to prepare for code review and have enhanced quality critique
  So that my code reviews are more thorough and effective

  Scenario: Review prep generates context-aware checklist
    Given the file commands/review-prep.md exists
    When I read the command instructions
    Then it should analyze recent changes via git diff
    And it should identify change categories
    And it should generate a checklist tailored to the change type

  Scenario: Checklist references review and antipattern skills
    Given the review-prep command exists
    When I check for skill references
    Then it should reference the code-review skill
    And it should reference the code-antipatterns skill

  Scenario: Agent is available as subagent
    Given the file agents/code-quality-critic.md exists
    When I check the agent frontmatter
    Then it should have a valid name and description
    And it should list available tools

  Scenario: Agent applies quality criteria to code
    Given the code-quality-critic agent exists
    When I read the agent instructions
    Then it should apply readability criteria
    And it should apply naming quality criteria
    And it should apply antipattern detection
    And it should categorize findings by severity
