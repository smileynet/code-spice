#!/usr/bin/env bash
# Smoke test for Feature 3.1: Antipattern detection during plan-audit
# Validates code-antipatterns and code-plan-audit skill content
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PASS=0
FAIL=0
WARN=0

pass() { echo "  [PASS] $1"; PASS=$((PASS + 1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL + 1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN + 1)); }

echo "Feature 3.1 Smoke Test"
echo "━━━━━━━━━━━━━━━━━━━━━━"

# --- code-antipatterns Skill ---
echo ""
echo "Code Antipatterns Skill:"

AP_SKILL="$REPO_ROOT/skills/code-antipatterns/SKILL.md"

if [ -f "$AP_SKILL" ]; then
  pass "SKILL.md exists"
else
  fail "SKILL.md missing"
fi

# YAML frontmatter
if head -1 "$AP_SKILL" | grep -q "^---"; then
  pass "YAML frontmatter present"
else
  fail "YAML frontmatter missing"
fi

FM_NAME=$(sed -n '/^---$/,/^---$/p' "$AP_SKILL" | grep "^name:" | sed 's/name: *//')
if [ "$FM_NAME" = "code-antipatterns" ]; then
  pass "frontmatter name matches directory"
else
  fail "frontmatter name is '$FM_NAME' (expected 'code-antipatterns')"
fi

FM_DESC=$(sed -n '/^---$/,/^---$/p' "$AP_SKILL" | grep "^description:" | head -1)
for kw in "antipattern" "plan-audit" "severity"; do
  if echo "$FM_DESC" | grep -qi "$kw"; then
    pass "frontmatter description contains '$kw'"
  else
    fail "frontmatter description missing '$kw'"
  fi
done

# Antipattern categories
for cat in "Surprise Antipatterns" "Misuse Antipatterns" "Complexity Antipatterns" "Premature Antipatterns"; do
  if grep -q "## $cat" "$AP_SKILL"; then
    pass "category '$cat' present"
  else
    fail "category '$cat' missing"
  fi
done

# Quick reference table with at least 10 antipatterns
TABLE_ROWS=$(grep -c "^| [0-9]" "$AP_SKILL" || echo "0")
if [ "$TABLE_ROWS" -ge 10 ]; then
  pass "quick reference table has $TABLE_ROWS antipatterns (≥10)"
else
  fail "quick reference table has $TABLE_ROWS antipatterns (expected ≥10)"
fi

# Individual antipatterns have symptoms and examples
SYMPTOM_COUNT=$(grep -c "^\*\*Symptoms:\*\*" "$AP_SKILL" || echo "0")
if [ "$SYMPTOM_COUNT" -ge 10 ]; then
  pass "at least 10 antipatterns have symptoms ($SYMPTOM_COUNT found)"
else
  fail "only $SYMPTOM_COUNT antipatterns have symptoms (expected ≥10)"
fi

BEFORE_COUNT=$(grep -c "^\*\*Before:\*\*" "$AP_SKILL" || echo "0")
if [ "$BEFORE_COUNT" -ge 5 ]; then
  pass "at least 5 antipatterns have before examples ($BEFORE_COUNT found)"
else
  fail "only $BEFORE_COUNT antipatterns have before examples (expected ≥5)"
fi

AFTER_COUNT=$(grep -c "^\*\*After:\*\*" "$AP_SKILL" || echo "0")
if [ "$AFTER_COUNT" -ge 5 ]; then
  pass "at least 5 antipatterns have after examples ($AFTER_COUNT found)"
else
  fail "only $AFTER_COUNT antipatterns have after examples (expected ≥5)"
fi

PREVENTION_COUNT=$(grep -c "^\*\*Prevention:\*\*" "$AP_SKILL" || echo "0")
if [ "$PREVENTION_COUNT" -ge 5 ]; then
  pass "at least 5 antipatterns have prevention guidance ($PREVENTION_COUNT found)"
else
  fail "only $PREVENTION_COUNT antipatterns have prevention guidance (expected ≥5)"
fi

# Severity classification
if grep -q "Severity Classification" "$AP_SKILL"; then
  pass "severity classification table present"
else
  fail "severity classification table missing"
fi

# Decision table
if grep -q "Decision Table" "$AP_SKILL"; then
  pass "decision table present"
else
  fail "decision table missing"
fi

# Cross-references
if grep -q "(see code-" "$AP_SKILL"; then
  pass "cross-references to other skills present"
else
  fail "cross-references missing"
fi

# Checklist
if grep -q "Code Review Antipattern Scan" "$AP_SKILL"; then
  pass "review checklist present"
else
  fail "review checklist missing"
fi

# --- code-plan-audit Skill ---
echo ""
echo "Code Plan Audit Skill:"

PA_SKILL="$REPO_ROOT/skills/code-plan-audit/SKILL.md"

if [ -f "$PA_SKILL" ]; then
  pass "SKILL.md exists"
else
  fail "SKILL.md missing"
fi

# YAML frontmatter
if head -1 "$PA_SKILL" | grep -q "^---"; then
  pass "YAML frontmatter present"
else
  fail "YAML frontmatter missing"
fi

FM_NAME=$(sed -n '/^---$/,/^---$/p' "$PA_SKILL" | grep "^name:" | sed 's/name: *//')
if [ "$FM_NAME" = "code-plan-audit" ]; then
  pass "frontmatter name matches directory"
else
  fail "frontmatter name is '$FM_NAME' (expected 'code-plan-audit')"
fi

FM_DESC=$(sed -n '/^---$/,/^---$/p' "$PA_SKILL" | grep "^description:" | head -1)
for kw in "plan" "scorecard" "audit"; do
  if echo "$FM_DESC" | grep -qi "$kw"; then
    pass "frontmatter description contains '$kw'"
  else
    fail "frontmatter description missing '$kw'"
  fi
done

# Completeness Scorecard
if grep -q "Plan Completeness Scorecard" "$PA_SKILL"; then
  pass "plan completeness scorecard present"
else
  fail "plan completeness scorecard missing"
fi

SCORECARD_ITEMS=$(grep -c "^| [0-9]" "$PA_SKILL" || echo "0")
if [ "$SCORECARD_ITEMS" -ge 10 ]; then
  pass "scorecard has $SCORECARD_ITEMS items (≥10)"
else
  fail "scorecard has $SCORECARD_ITEMS items (expected ≥10)"
fi

# Scoring rubric
if grep -q "10/10" "$PA_SKILL" && grep -q "READY TO BUILD\|ready to build" "$PA_SKILL"; then
  pass "scoring rubric with thresholds present"
else
  fail "scoring rubric missing"
fi

# Actionability tests
if grep -q "Actionability Tests" "$PA_SKILL"; then
  pass "actionability tests section present"
else
  fail "actionability tests section missing"
fi

for test in "Verb Test" "Scope Test" "Test Test" "Dependency Test" "Edge Case Test"; do
  if grep -q "$test" "$PA_SKILL"; then
    pass "actionability test '$test' present"
  else
    fail "actionability test '$test' missing"
  fi
done

# Quality pre-checks
for check in "Readability Pre-Check" "Error Handling Strategy" "Modularity Pre-Check"; do
  if grep -q "$check" "$PA_SKILL"; then
    pass "quality pre-check '$check' present"
  else
    fail "quality pre-check '$check' missing"
  fi
done

# Antipattern risk assessment
if grep -q "Antipattern Risk Assessment" "$PA_SKILL"; then
  pass "antipattern risk assessment present"
else
  fail "antipattern risk assessment missing"
fi

# Plan-level antipatterns
for ap in "The Fog" "The Wishlist" "Missing Error Story"; do
  if grep -q "$ap" "$PA_SKILL"; then
    pass "plan-level antipattern '$ap' documented"
  else
    fail "plan-level antipattern '$ap' missing"
  fi
done

# Testing strategy evaluation
if grep -q "Testing Strategy Evaluation" "$PA_SKILL"; then
  pass "testing strategy evaluation present"
else
  fail "testing strategy evaluation missing"
fi

# Build readiness decision table
if grep -q "Is This Plan Ready to Build" "$PA_SKILL"; then
  pass "build readiness decision table present"
else
  fail "build readiness decision table missing"
fi

# Quick pre-implementation gate
if grep -q "Quick Pre-Implementation Gate" "$PA_SKILL"; then
  pass "quick pre-implementation gate present"
else
  fail "quick pre-implementation gate missing"
fi

# Cross-references
if grep -q "(see code-" "$PA_SKILL"; then
  pass "cross-references to other skills present"
else
  fail "cross-references missing"
fi

# Plan audit checklist
if grep -q "Plan Audit Checklist" "$PA_SKILL"; then
  pass "plan audit checklist present"
else
  fail "plan audit checklist missing"
fi

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
