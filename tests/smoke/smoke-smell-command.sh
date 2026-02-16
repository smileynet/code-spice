#!/usr/bin/env bash
# Smoke test for cs-hdb.2.1: Create /code:smell command
# Validates command structure, frontmatter, antipattern catalog, severity categories, and output format
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PASS=0
FAIL=0
WARN=0

pass() { echo "  [PASS] $1"; PASS=$((PASS + 1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL + 1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN + 1)); }

echo "Code Smell Command Smoke Test"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

CMD="$REPO_ROOT/commands/smell.md"

# --- File Exists ---
echo ""
echo "File Structure:"

if [ -f "$CMD" ]; then
  pass "commands/smell.md exists"
else
  fail "commands/smell.md missing"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Results: $PASS passed, $FAIL failed, $WARN warnings"
  echo "STATUS: FAILED"
  exit 1
fi

# --- YAML Frontmatter ---
echo ""
echo "YAML Frontmatter:"

if head -1 "$CMD" | grep -q "^---"; then
  pass "YAML frontmatter present"
else
  fail "YAML frontmatter missing"
fi

FM_DESC=$(sed -n '/^---$/,/^---$/p' "$CMD" | grep "^description:" | head -1)
if [ -n "$FM_DESC" ]; then
  pass "frontmatter description field present"
else
  fail "frontmatter description field missing"
fi

FM_TOOLS=$(sed -n '/^---$/,/^---$/p' "$CMD" | grep "^allowed-tools:" | head -1)
if [ -n "$FM_TOOLS" ]; then
  pass "frontmatter allowed-tools field present"
else
  fail "frontmatter allowed-tools field missing"
fi

if echo "$FM_TOOLS" | grep -q "Read"; then
  pass "allowed-tools includes Read"
else
  fail "allowed-tools missing Read"
fi

if echo "$FM_TOOLS" | grep -q "Grep"; then
  pass "allowed-tools includes Grep"
else
  fail "allowed-tools missing Grep"
fi

# --- Antipattern Categories ---
echo ""
echo "Antipattern Categories:"

for cat in "Surprise" "Misuse" "Complexity" "Premature"; do
  if grep -qi "$cat" "$CMD"; then
    pass "antipattern category present: $cat"
  else
    fail "antipattern category missing: $cat"
  fi
done

# --- Antipattern Patterns (spot-check key patterns from each category) ---
echo ""
echo "Antipattern Patterns:"

PATTERN_COUNT=0
for pat in "Magic return" "Hidden side effect" "Silent failure" "Misleading name" \
           "Primitive obsession" "Mutable shared state" "Boolean blindness" \
           "Deep nesting" "God class" "Long parameter" \
           "Premature abstraction" "Speculative generality" "Over-engineering"; do
  if grep -qi "$pat" "$CMD"; then
    PATTERN_COUNT=$((PATTERN_COUNT + 1))
  fi
done

if [ "$PATTERN_COUNT" -ge 10 ]; then
  pass "10+ antipattern patterns cataloged ($PATTERN_COUNT found)"
else
  fail "fewer than 10 antipattern patterns ($PATTERN_COUNT found)"
fi

# --- Severity Categories ---
echo ""
echo "Severity Categories:"

for sev in "Critical" "Warning" "Note"; do
  if grep -qi "$sev" "$CMD"; then
    pass "severity category present: $sev"
  else
    fail "severity category missing: $sev"
  fi
done

# --- Input Collection ---
echo ""
echo "Input Collection:"

if grep -qi "git diff" "$CMD"; then
  pass "collects changes via git diff"
else
  fail "does not collect changes via git diff"
fi

if grep -qi "\$ARGUMENTS\|file.*path\|glob.*pattern" "$CMD"; then
  pass "supports file path arguments"
else
  fail "does not support file path arguments"
fi

# --- Output Format ---
echo ""
echo "Output Format:"

if grep -qi "CODE SMELL REPORT\|SMELL.*REPORT" "$CMD"; then
  pass "defines report output format"
else
  fail "does not define report output format"
fi

if grep -qi "SUMMARY\|summary" "$CMD"; then
  pass "includes summary section"
else
  fail "does not include summary section"
fi

if grep -qi "Verdict\|verdict" "$CMD"; then
  pass "includes verdict"
else
  fail "does not include verdict"
fi

if grep -qi "CLEAN\|HAS_WARNINGS\|HAS_CRITICAL" "$CMD"; then
  pass "defines verdict levels (CLEAN/HAS_WARNINGS/HAS_CRITICAL)"
else
  fail "does not define verdict levels"
fi

# --- Skill Reference ---
echo ""
echo "Skill References:"

if grep -qi "code-antipattern" "$CMD"; then
  pass "references code-antipatterns skill"
else
  warn "does not explicitly reference code-antipatterns skill"
fi

# --- Summary ---
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Results: $PASS passed, $FAIL failed, $WARN warnings"

if [ "$FAIL" -gt 0 ]; then
  echo "STATUS: FAILED"
  exit 1
else
  echo "STATUS: PASSED"
  exit 0
fi
