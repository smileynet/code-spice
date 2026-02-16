#!/usr/bin/env bash
# Smoke test for cs-hdb.1.1: Create /code:tradeoff command
# Validates command structure, frontmatter, process steps, and output format
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PASS=0
FAIL=0
WARN=0

pass() { echo "  [PASS] $1"; PASS=$((PASS + 1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL + 1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN + 1)); }

echo "Tradeoff Command Smoke Test"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"

CMD="$REPO_ROOT/commands/tradeoff.md"

# --- File Exists ---
echo ""
echo "File Structure:"

if [ -f "$CMD" ]; then
  pass "commands/tradeoff.md exists"
else
  fail "commands/tradeoff.md missing"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
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

if echo "$FM_TOOLS" | grep -q "AskUserQuestion"; then
  pass "allowed-tools includes AskUserQuestion"
else
  fail "allowed-tools missing AskUserQuestion (needed for interactive questions)"
fi

# --- Skill References ---
echo ""
echo "Skill References:"

if grep -q "software-tradeoffs" "$CMD"; then
  pass "references software-tradeoffs skill"
else
  fail "does not reference software-tradeoffs skill"
fi

if grep -q "code-quality-foundations" "$CMD"; then
  pass "references code-quality-foundations skill"
else
  warn "does not reference code-quality-foundations skill (optional)"
fi

# --- Tradeoff Dimensions ---
echo ""
echo "Tradeoff Dimensions:"

DIMENSION_COUNT=0
for dim in "Duplication.*DRY\|DRY.*Duplication" "Flexibility.*complexity\|complexity.*Flexibility" "Simplicity.*extensibility\|extensibility.*Simplicity" "Performance.*readability\|readability.*Performance" "Build.*buy\|buy.*Build" "Consistency.*availability\|availability.*Consistency"; do
  if grep -qi "$dim" "$CMD"; then
    pass "tradeoff dimension present: $(echo "$dim" | sed 's/\\|.*//;s/\\.\\*/ vs /')"
    DIMENSION_COUNT=$((DIMENSION_COUNT + 1))
  else
    fail "tradeoff dimension missing: $(echo "$dim" | sed 's/\\|.*//;s/\\.\\*/ vs /')"
  fi
done

if [ "$DIMENSION_COUNT" -ge 6 ]; then
  pass "6+ tradeoff dimensions cataloged ($DIMENSION_COUNT found)"
else
  fail "fewer than 6 tradeoff dimensions ($DIMENSION_COUNT found)"
fi

# --- Process Steps ---
echo ""
echo "Process Steps:"

if grep -qi "describe.*decision\|design decision\|decision.*context" "$CMD"; then
  pass "asks user to describe design decision"
else
  fail "does not ask user to describe design decision"
fi

if grep -qi "walk.*through\|each dimension\|relevant.*dimension" "$CMD"; then
  pass "walks through dimensions with questions"
else
  fail "does not walk through dimensions with questions"
fi

if grep -qi "structured.*analysis\|analysis.*format\|output.*format" "$CMD"; then
  pass "produces structured analysis"
else
  fail "does not define structured analysis output"
fi

if grep -qi "pros.*cons\|advantages.*disadvantages\|tradeoff.*table\|comparison" "$CMD"; then
  pass "includes pros/cons analysis"
else
  fail "does not include pros/cons analysis"
fi

if grep -qi "recommendation\|recommend" "$CMD"; then
  pass "includes recommendation"
else
  fail "does not include recommendation"
fi

# --- /line:decision Integration ---
echo ""
echo "Decision Integration:"

if grep -qi "line:decision\|/line:decision" "$CMD"; then
  pass "optionally integrates with /line:decision"
else
  fail "does not integrate with /line:decision"
fi

# --- Summary ---
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Results: $PASS passed, $FAIL failed, $WARN warnings"

if [ "$FAIL" -gt 0 ]; then
  echo "STATUS: FAILED"
  exit 1
else
  echo "STATUS: PASSED"
  exit 0
fi
