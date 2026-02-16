#!/usr/bin/env bash
# Smoke test for Feature 5.1: Plugin documented and marketplace-ready
# Validates README.md, AGENTS.md, CHANGELOG.md, and marketplace entry
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PASS=0
FAIL=0
WARN=0

pass() { echo "  [PASS] $1"; PASS=$((PASS + 1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL + 1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN + 1)); }

echo "Feature 5.1 Smoke Test"
echo "━━━━━━━━━━━━━━━━━━━━━━"

# --- README.md ---
echo ""
echo "README.md:"

README="$REPO_ROOT/README.md"

if [ -f "$README" ]; then
  pass "README.md exists"
else
  fail "README.md missing"
fi

# Installation instructions
if grep -q "Quick Start\|installation\|install" "$README"; then
  pass "installation instructions present"
else
  fail "installation instructions missing"
fi

# Skills table (10 skills)
SKILL_COUNT=$(grep -c "^\| \*\*.*\*\*" "$REPO_ROOT/README.md" | head -1 || echo "0")
# Count skill rows specifically in the What's Inside table
SKILL_ROWS=$(sed -n '/## What.*Inside/,/^## /p' "$README" | grep -c "^\| \*\*" || echo "0")
if [ "$SKILL_ROWS" -ge 10 ]; then
  pass "skills table has $SKILL_ROWS entries (expected 10)"
else
  fail "skills table has $SKILL_ROWS entries (expected 10)"
fi

# All 10 skills listed
for skill in "code-quality-foundations" "code-readability" "code-naming" "refactoring-patterns" "error-handling-patterns" "code-antipatterns" "code-review" "code-testing-quality" "software-tradeoffs" "code-plan-audit"; do
  if grep -q "$skill" "$README"; then
    pass "skill '$skill' listed"
  else
    fail "skill '$skill' missing"
  fi
done

# Commands table (3 commands)
for cmd in "/code:tradeoff" "/code:smell" "/code:review-prep"; do
  if grep -q "$cmd" "$README"; then
    pass "command '$cmd' listed"
  else
    fail "command '$cmd' missing"
  fi
done

# Agent
if grep -q "code-quality-critic" "$README"; then
  pass "code-quality-critic agent described"
else
  fail "code-quality-critic agent missing"
fi

# Summary line
if grep -q "10 skills, 3 commands, 1 agent" "$README"; then
  pass "summary line '10 skills, 3 commands, 1 agent' present"
else
  fail "summary line missing"
fi

# --- AGENTS.md ---
echo ""
echo "AGENTS.md:"

AGENTS="$REPO_ROOT/AGENTS.md"

if [ -f "$AGENTS" ]; then
  pass "AGENTS.md exists"
else
  fail "AGENTS.md missing"
fi

# Development workflow
if grep -q "Development Workflow\|development workflow" "$AGENTS"; then
  pass "development workflow section present"
else
  fail "development workflow section missing"
fi

# Skill authoring conventions
if grep -q "Skill Authoring Conventions\|skill authoring" "$AGENTS"; then
  pass "skill authoring conventions present"
else
  fail "skill authoring conventions missing"
fi

# Smoke testing guidance
if grep -q "Smoke Testing\|smoke test" "$AGENTS"; then
  pass "smoke testing guidance present"
else
  fail "smoke testing guidance missing"
fi

# Command authoring
if grep -q "Command Authoring\|command authoring" "$AGENTS"; then
  pass "command authoring section present"
else
  fail "command authoring section missing"
fi

# Agent authoring
if grep -q "Agent Authoring\|agent authoring" "$AGENTS"; then
  pass "agent authoring section present"
else
  fail "agent authoring section missing"
fi

# --- CHANGELOG.md ---
echo ""
echo "CHANGELOG.md:"

CHANGELOG="$REPO_ROOT/CHANGELOG.md"

if [ -f "$CHANGELOG" ]; then
  pass "CHANGELOG.md exists"
else
  fail "CHANGELOG.md missing"
fi

# v0.1.0 entry
if grep -q "\[0\.1\.0\]" "$CHANGELOG"; then
  pass "v0.1.0 entry present"
else
  fail "v0.1.0 entry missing"
fi

# Lists skills
if grep -q "code-quality-foundations" "$CHANGELOG"; then
  pass "skills listed in changelog"
else
  fail "skills missing from changelog"
fi

# Lists commands
if grep -q "/code:tradeoff\|code:tradeoff\|Interactive Commands" "$CHANGELOG"; then
  pass "commands listed in changelog"
else
  fail "commands missing from changelog"
fi

# Lists agent
if grep -q "code-quality-critic" "$CHANGELOG"; then
  pass "agent listed in changelog"
else
  fail "agent missing from changelog"
fi

# --- Marketplace Entry ---
echo ""
echo "Marketplace Entry:"

MARKETPLACE="$REPO_ROOT/docs/marketplace-entry.json"

if [ -f "$MARKETPLACE" ]; then
  pass "marketplace-entry.json exists"
else
  fail "marketplace-entry.json missing"
fi

if python3 -c "import json; json.load(open('$MARKETPLACE'))" 2>/dev/null; then
  pass "marketplace-entry.json is valid JSON"
else
  fail "marketplace-entry.json is not valid JSON"
fi

MKT_NAME=$(python3 -c "import json; print(json.load(open('$MARKETPLACE'))['name'])" 2>/dev/null || echo "")
if [ "$MKT_NAME" = "code-spice" ]; then
  pass "name field is 'code-spice'"
else
  fail "name field is '$MKT_NAME' (expected 'code-spice')"
fi

MKT_CAT=$(python3 -c "import json; print(json.load(open('$MARKETPLACE'))['category'])" 2>/dev/null || echo "")
if [ "$MKT_CAT" = "domain-knowledge" ]; then
  pass "category is 'domain-knowledge'"
else
  fail "category is '$MKT_CAT' (expected 'domain-knowledge')"
fi

MKT_TAGS=$(python3 -c "import json; print(' '.join(json.load(open('$MARKETPLACE'))['tags']))" 2>/dev/null || echo "")
for tag in "code-quality" "spice"; do
  if echo "$MKT_TAGS" | grep -q "$tag"; then
    pass "tag '$tag' present"
  else
    fail "tag '$tag' missing"
  fi
done

# Required fields check
for field in "name" "source" "description" "category" "tags"; do
  HAS_FIELD=$(python3 -c "import json; d=json.load(open('$MARKETPLACE')); print('yes' if '$field' in d else 'no')" 2>/dev/null || echo "no")
  if [ "$HAS_FIELD" = "yes" ]; then
    pass "required field '$field' present"
  else
    fail "required field '$field' missing"
  fi
done

# --- Summary ---
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "Results: $PASS passed, $FAIL failed, $WARN warnings"

if [ "$FAIL" -gt 0 ]; then
  echo "STATUS: FAILED"
  exit 1
else
  echo "STATUS: PASSED"
  exit 0
fi
