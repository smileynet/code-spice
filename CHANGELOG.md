# Changelog

All notable changes to Code Spice will be documented in this file.

## [Unreleased]

### Added
- Implementation guidance activates during cook (cs-ilx.2)
  - `refactoring-patterns` skill with 13-pattern catalog, code smell triggers, and decision framework
  - `error-handling-patterns` skill with strategy decision table, recoverability framework, and 5 signaling techniques
  - Both skills activate via frontmatter keywords during /line:cook
  - Smoke test suite for feature 2.2 validation (35 checks)
- Phase 1: Plugin Foundation & Tracer (cs-jwh)
  - Installable Claude Code plugin with code quality knowledge
  - Features: Installable plugin with first knowledge skill (cs-jwh.1)
  - `.claude-plugin/plugin.json` manifest with code quality keywords
  - `code-quality-foundations` skill synthesizing Good Code Bad Code Ch 1-2 and Software Mistakes & Tradeoffs Ch 1
  - Quality pillars, abstraction layers, tradeoff thinking, and decision tables
  - Language backfill tracking for Python, Rust, Go, C++
  - Smoke test suite for plugin validation (39 checks)
