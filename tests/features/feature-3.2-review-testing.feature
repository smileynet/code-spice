Feature: Code review and testing guidance during serve and cook
  As a Line Cook user
  I want code review best practices during serve and testing quality guidance during cook
  So that reviews are more effective and tests are higher quality

  Scenario: Review skill covers process, feedback, automation
    Given the file skills/code-review/SKILL.md exists
    When I read the skill content
    Then it should cover code review process and goals
    And it should include effective feedback templates
    And it should discuss review automation

  Scenario: Review skill includes AI review guidance
    Given the code-review skill exists
    When I check for AI-specific content
    Then it should include a section on AI-augmented code review
    And it should reference how AI tools complement human review

  Scenario: Testing skill covers principles and practices
    Given the file skills/code-testing-quality/SKILL.md exists
    When I read the skill content
    Then it should cover unit testing principles (isolation, repeatability, clarity)
    And it should cover test structure patterns (AAA or GWT)
    And it should identify testing antipatterns

  Scenario: Testing skill enhances taster agent
    Given the code-testing-quality skill exists
    When I check the skill description keywords
    Then it should include keywords relevant to the taster agent phase
    And it should contain a testing quality checklist usable during code review
