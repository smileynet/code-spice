Feature: Installable plugin with first knowledge skill
  As a Line Cook user
  I want to install Code Spice
  So that code quality knowledge activates during my planning workflow

  Scenario: Plugin installs with valid plugin.json
    Given the code-spice repository is cloned
    When I inspect .claude-plugin/plugin.json
    Then the name field should be "code"
    And the version field should be "0.1.0"
    And keywords should include code quality terms

  Scenario: Skill activates on code quality keywords
    Given code-spice is installed as a plugin
    When I run /line:brainstorm on a coding project
    Then the code-quality-foundations skill should be loaded
    And the skill description should contain activation keywords like "quality", "abstraction", "code goals"

  Scenario: Skill covers quality pillars and abstraction
    Given the file skills/code-quality-foundations/SKILL.md exists
    When I read the skill content
    Then it should contain a Quick Reference section
    And it should cover code quality pillars
    And it should cover layers of abstraction
    And it should contain decision tables

  Scenario: Language backfill reference exists
    Given the file docs/language-backfill.md exists
    When I read its content
    Then it should list target languages for future supplemental files
    And it should track which skills need language-specific examples
