Feature: Plugin documented and marketplace-ready
  As a Line Cook user
  I want to discover Code Spice in the marketplace and understand what it provides
  So that I can install and use it effectively

  Scenario: README covers installation, skills, commands, agent
    Given the file README.md exists
    When I read its content
    Then it should explain what Code Spice does
    And it should include installation instructions
    And it should list all 10 skills with descriptions
    And it should list all 3 commands with descriptions
    And it should describe the code-quality-critic agent

  Scenario: AGENTS.md provides development guidance
    Given the file AGENTS.md exists
    When I read its content
    Then it should describe the development workflow
    And it should include skill authoring conventions

  Scenario: CHANGELOG documents v0.1.0
    Given the file CHANGELOG.md exists
    When I read its content
    Then it should have a v0.1.0 entry
    And it should list all skills, commands, and agent

  Scenario: Marketplace entry ready
    Given the file docs/marketplace-entry.json exists
    When I parse the JSON
    Then the name field should be "code"
    And the category should be "domain-knowledge"
    And it should include relevant tags
