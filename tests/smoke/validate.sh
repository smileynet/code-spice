#!/usr/bin/env bash
# Consolidated smoke test for Code Spice v0.3.0
# Validates plugin structure, all 13 skills, 4 commands, and 1 agent
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PASS=0
FAIL=0

pass() { echo "  [PASS] $1"; PASS=$((PASS + 1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL + 1)); }

echo "Code Spice Validation"
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

for dir in skills commands agents; do
  if [ -d "$REPO_ROOT/$dir" ]; then
    pass "$dir/ directory exists"
  else
    fail "$dir/ directory missing"
  fi
done

# --- All 13 Skills ---
echo ""
echo "Skills (13 expected):"

SKILLS=(
  "code-quality-foundations"
  "code-readability"
  "code-naming"
  "refactoring-patterns"
  "error-handling-patterns"
  "code-antipatterns"
  "code-review"
  "code-testing-quality"
  "software-tradeoffs"
  "code-plan-audit"
  "code-yagni"
  "code-scope-boundaries"
  "code-pruning"
)

SKILL_COUNT=0
for skill in "${SKILLS[@]}"; do
  SKILL_FILE="$REPO_ROOT/skills/$skill/SKILL.md"

  if [ ! -f "$SKILL_FILE" ]; then
    fail "$skill: SKILL.md missing"
    continue
  fi

  # YAML frontmatter check
  if ! head -1 "$SKILL_FILE" | grep -q "^---"; then
    fail "$skill: YAML frontmatter missing"
    continue
  fi

  # Frontmatter name matches directory
  FM_NAME=$(sed -n '/^---$/,/^---$/p' "$SKILL_FILE" | grep "^name:" | sed 's/name: *//')
  if [ "$FM_NAME" != "$skill" ]; then
    fail "$skill: frontmatter name is '$FM_NAME' (expected '$skill')"
    continue
  fi

  # Description field exists and is non-empty
  FM_DESC=$(sed -n '/^---$/,/^---$/p' "$SKILL_FILE" | grep "^description:" | head -1)
  if [ -z "$FM_DESC" ]; then
    fail "$skill: frontmatter description missing"
    continue
  fi

  # Line count check (under 500 per Anthropic BPAP)
  LINES=$(wc -l < "$SKILL_FILE")
  if [ "$LINES" -gt 500 ]; then
    fail "$skill: $LINES lines (exceeds 500 BPAP limit)"
    continue
  fi

  pass "$skill ($LINES lines)"
  SKILL_COUNT=$((SKILL_COUNT + 1))
done

if [ "$SKILL_COUNT" -eq 13 ]; then
  pass "All 13 skills present and valid"
else
  fail "Only $SKILL_COUNT/13 skills valid"
fi

# --- Commands ---
echo ""
echo "Commands (4 expected):"

COMMANDS=("tradeoff" "smell" "review-prep" "prune")

for cmd in "${COMMANDS[@]}"; do
  CMD_FILE="$REPO_ROOT/commands/$cmd.md"
  if [ -f "$CMD_FILE" ]; then
    # Check for frontmatter
    if head -1 "$CMD_FILE" | grep -q "^---"; then
      LINES=$(wc -l < "$CMD_FILE")
      pass "$cmd ($LINES lines)"
    else
      fail "$cmd: frontmatter missing"
    fi
  else
    fail "$cmd: file missing"
  fi
done

# --- Agent ---
echo ""
echo "Agents (1 expected):"

AGENT_FILE="$REPO_ROOT/agents/code-quality-critic.md"
if [ -f "$AGENT_FILE" ]; then
  if head -1 "$AGENT_FILE" | grep -q "^---"; then
    LINES=$(wc -l < "$AGENT_FILE")
    pass "code-quality-critic ($LINES lines)"
  else
    fail "code-quality-critic: frontmatter missing"
  fi
else
  fail "code-quality-critic: file missing"
fi

# --- Content Guide ---
echo ""
echo "Documentation:"

if [ -f "$REPO_ROOT/docs/skill-content-guide.md" ]; then
  pass "skill-content-guide.md exists"
else
  fail "skill-content-guide.md missing"
fi

# --- No Skill Duplicates Content in Commands ---
echo ""
echo "Duplication Check:"

# Commands should reference skills, not inline large tables from them
for cmd in "${COMMANDS[@]}"; do
  CMD_FILE="$REPO_ROOT/commands/$cmd.md"
  # Check that commands aren't too large (sign of inlined content)
  if [ -f "$CMD_FILE" ]; then
    LINES=$(wc -l < "$CMD_FILE")
    if [ "$LINES" -le 200 ]; then
      pass "$cmd: $LINES lines (under 200 — no bloat)"
    else
      fail "$cmd: $LINES lines (over 200 — may contain inlined skill content)"
    fi
  fi
done

# --- Summary ---
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
  echo "STATUS: FAILED"
  exit 1
else
  echo "STATUS: PASSED"
  exit 0
fi
