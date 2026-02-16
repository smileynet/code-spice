# Changelog

All notable changes to Code Spice will be documented in this file.

## [Unreleased]

### Added
- Feature 4.2: Code smell detection command (cs-hdb.2)
  - `/code:smell` command for detecting implementation-level antipatterns
  - 20-pattern antipattern catalog across 4 categories: Surprise, Misuse, Complexity, Premature
  - Severity classification: Critical, Warning, Note with verdict logic
  - Scans git diff or user-specified files with structured report output
- Feature 4.1: Tradeoff analysis command (cs-hdb.1)
  - `/code:tradeoff` command for systematic design decision analysis
  - Structured 5-step process: gather context, identify dimensions, evaluate, analyze, record
  - 6 tradeoff dimensions: DRY, flexibility, extensibility, performance, build-vs-buy, consistency
  - Integration with `/line:decision` for optional ADR recording
  - Updated architecture.md constraint to reflect commands and agents as additive layers
- Phase 1: Plugin Foundation & Tracer (cs-jwh)
  - Installable Claude Code plugin with code quality knowledge
  - Features: Installable plugin with first knowledge skill (cs-jwh.1)
  - `.claude-plugin/plugin.json` manifest with code quality keywords
  - `code-quality-foundations` skill synthesizing Good Code Bad Code Ch 1-2 and Software Mistakes & Tradeoffs Ch 1
  - Quality pillars, abstraction layers, tradeoff thinking, and decision tables
  - Language backfill tracking for Python, Rust, Go, C++
  - Smoke test suite for plugin validation (39 checks)
