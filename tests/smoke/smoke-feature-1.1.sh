#!/usr/bin/env bash
# Smoke test for Feature 1.1: Installable plugin with first knowledge skill
# Validates plugin structure, SKILL.md content, and language backfill tracking
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PASS=0
FAIL=0
WARN=0

pass() { echo "  [PASS] $1"; PASS=$((PASS + 1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL + 1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN + 1)); }

echo "Feature 1.1 Smoke Test"
echo "━━━━━━━━━━━━━━━━━━━━━━"

# --- Plugin Structure ---
echo ""
echo "Plugin Structure:"

if [ -f "$REPO_ROOT/.claude-plugin/plugin.json" ]; then
  pass "plugin.json exists"
else
  fail "plugin.json missing"
fi

if python3 -c "import json; json.load(open('$REPO_ROOT/.claude-plugin/plugin.json'))" 2>/dev/null; then
  pass "plugin.json is valid JSON"
else
  fail "plugin.json is not valid JSON"
fi

NAME=$(python3 -c "import json; print(json.load(open('$REPO_ROOT/.claude-plugin/plugin.json'))['name'])" 2>/dev/null || echo "")
if [ "$NAME" = "code" ]; then
  pass "name field is 'code'"
else
  fail "name field is '$NAME' (expected 'code')"
fi

VERSION=$(python3 -c "import json; print(json.load(open('$REPO_ROOT/.claude-plugin/plugin.json'))['version'])" 2>/dev/null || echo "")
if [ "$VERSION" = "0.1.0" ]; then
  pass "version field is '0.1.0'"
else
  fail "version field is '$VERSION' (expected '0.1.0')"
fi

KEYWORDS=$(python3 -c "import json; kw = json.load(open('$REPO_ROOT/.claude-plugin/plugin.json')).get('keywords',[]); print(' '.join(kw))" 2>/dev/null || echo "")
for kw in "code-quality" "spice" "line-cook"; do
  if echo "$KEYWORDS" | grep -q "$kw"; then
    pass "keyword '$kw' present"
  else
    fail "keyword '$kw' missing"
  fi
done

for dir in skills commands agents; do
  if [ -d "$REPO_ROOT/$dir" ]; then
    pass "$dir/ directory exists"
  else
    fail "$dir/ directory missing"
  fi
done

# --- SKILL.md Content ---
echo ""
echo "SKILL.md Content:"

SKILL="$REPO_ROOT/skills/code-quality-foundations/SKILL.md"

if [ -f "$SKILL" ]; then
  pass "SKILL.md exists"
else
  fail "SKILL.md missing"
fi

# YAML frontmatter
if head -1 "$SKILL" | grep -q "^---"; then
  pass "YAML frontmatter present"
else
  fail "YAML frontmatter missing"
fi

FM_NAME=$(sed -n '/^---$/,/^---$/p' "$SKILL" | grep "^name:" | sed 's/name: *//')
if [ "$FM_NAME" = "code-quality-foundations" ]; then
  pass "frontmatter name matches directory"
else
  fail "frontmatter name is '$FM_NAME' (expected 'code-quality-foundations')"
fi

FM_DESC=$(sed -n '/^---$/,/^---$/p' "$SKILL" | grep "^description:" | head -1)
for kw in "quality" "abstraction" "pillars"; do
  if echo "$FM_DESC" | grep -qi "$kw"; then
    pass "frontmatter description contains '$kw'"
  else
    fail "frontmatter description missing '$kw'"
  fi
done

# Required sections
for section in "Quick Reference" "Layers of Abstraction" "Decision Tables" "Tradeoff Thinking"; do
  if grep -q "## $section" "$SKILL"; then
    pass "section '$section' present"
  else
    fail "section '$section' missing"
  fi
done

# Quality pillars
for pillar in "Readable" "No surprises" "Hard to misuse" "Modular" "Reusable" "Testable"; do
  if grep -q "$pillar" "$SKILL"; then
    pass "pillar '$pillar' covered"
  else
    fail "pillar '$pillar' missing"
  fi
done

# Progressive disclosure
if grep -q "<details>" "$SKILL"; then
  pass "progressive disclosure (<details> tags) used"
else
  fail "progressive disclosure (<details> tags) missing"
fi

# Cross-references
if grep -q "(see code-" "$SKILL"; then
  pass "cross-references to other skills present"
else
  fail "cross-references missing"
fi

# Line count
LINES=$(wc -l < "$SKILL")
if [ "$LINES" -ge 200 ] && [ "$LINES" -le 400 ]; then
  pass "line count $LINES within target range (200-400)"
else
  fail "line count $LINES outside target range (200-400)"
fi

# --- Language Backfill ---
echo ""
echo "Language Backfill:"

BACKFILL="$REPO_ROOT/docs/language-backfill.md"

if [ -f "$BACKFILL" ]; then
  pass "language-backfill.md exists"
else
  fail "language-backfill.md missing"
fi

for lang in "Python" "Rust" "Go" "C++"; do
  if grep -q "$lang" "$BACKFILL"; then
    pass "backfill target '$lang' listed"
  else
    fail "backfill target '$lang' missing"
  fi
done

for book in "Good Code" "Five Lines" "Software Mistakes" "Looks Good"; do
  if grep -q "$book" "$BACKFILL"; then
    pass "source book '$book' listed"
  else
    fail "source book '$book' missing"
  fi
done

if grep -q "Skill Coverage Matrix\|skill.*coverage\|Skill.*Coverage" "$BACKFILL"; then
  pass "skill coverage matrix present"
else
  fail "skill coverage matrix missing"
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
