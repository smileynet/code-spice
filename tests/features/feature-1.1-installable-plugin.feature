Feature: Installable plugin with first knowledge skill
  As a Line Cook user
  I want to install Code Spice
  So that code quality knowledge activates during my planning workflow

  Scenario: Plugin installs with valid plugin.json
    Given the code-spice repository is cloned
    When I inspect .claude-plugin/plugin.json
    Then the file should be valid JSON
    And the name field should be "code"
    And the version field should be "0.1.0"
    And keywords should include "code-quality", "spice", and "line-cook"

  Scenario: Plugin directory structure is complete
    Given the code-spice repository is cloned
    When I inspect the directory structure
    Then skills/ directory should exist
    And commands/ directory should exist
    And agents/ directory should exist

  Scenario: Skill activates on code quality keywords
    Given code-spice is installed as a plugin
    When I inspect skills/code-quality-foundations/SKILL.md frontmatter
    Then the frontmatter name should be "code-quality-foundations"
    And the frontmatter description should contain "quality", "abstraction", and "pillars"
    # Note: Actual activation during /line:brainstorm requires manual verification
    # with a coding project. The skill is discoverable via keyword matching in the
    # frontmatter description field.

  Scenario: Skill covers quality pillars and abstraction
    Given the file skills/code-quality-foundations/SKILL.md exists
    When I read the skill content
    Then it should contain a "Quick Reference" section
    And it should cover all six pillars: Readable, No surprises, Hard to misuse, Modular, Reusable, Testable
    And it should contain a "Layers of Abstraction" section
    And it should contain a "Decision Tables" section
    And it should contain a "Tradeoff Thinking" section

  Scenario: Skill follows SKILL.md format standards
    Given the file skills/code-quality-foundations/SKILL.md exists
    When I validate the file format
    Then it should have YAML frontmatter with name and description fields
    And the file should be between 200 and 400 lines
    And it should use <details> tags for progressive disclosure
    And cross-references should use "(see code-X -> Section)" format

  Scenario: Language backfill reference exists
    Given the file docs/language-backfill.md exists
    When I read its content
    Then it should list 4 source book languages including Good Code Bad Code and Software Mistakes
    And it should list backfill target languages: Python, Rust, Go, and C++
    And it should contain a skill coverage matrix

  Scenario: Plugin.json with missing name field should fail validation
    Given a plugin.json without a name field
    When I validate it against plugin requirements
    Then validation should report the name field as missing

  Scenario: SKILL.md without YAML frontmatter should fail validation
    Given a SKILL.md file without YAML frontmatter delimiters
    When I validate it against skill requirements
    Then validation should report missing frontmatter

  Scenario: SKILL.md missing required sections should be flagged
    Given a SKILL.md missing the Quick Reference section
    When I validate it against skill requirements
    Then validation should report the missing section
