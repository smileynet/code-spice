# Changelog

All notable changes to Code Spice will be documented in this file.

## [Unreleased]

### Added
- Phase 3: Antipattern detection during plan-audit (cs-n4l.1)
  - `code-antipatterns` skill with 13+ categorized antipatterns (Surprise, Misuse, Complexity, Premature)
  - `code-plan-audit` skill with 10-point completeness scorecard and build-readiness decision support
  - Severity classification, decision tables, and actionability tests for plan quality assessment
- Phase 1: Plugin Foundation & Tracer (cs-jwh)
  - Installable Claude Code plugin with code quality knowledge
  - Features: Installable plugin with first knowledge skill (cs-jwh.1)
  - `.claude-plugin/plugin.json` manifest with code quality keywords
  - `code-quality-foundations` skill synthesizing Good Code Bad Code Ch 1-2 and Software Mistakes & Tradeoffs Ch 1
  - Quality pillars, abstraction layers, tradeoff thinking, and decision tables
  - Language backfill tracking for Python, Rust, Go, C++
  - Smoke test suite for plugin validation (39 checks)
