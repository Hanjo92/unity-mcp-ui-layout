#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

skill_frontmatter="$(sed -n '1,4p' "$ROOT_DIR/unity-mcp-ui-layout/SKILL.md")"
agent_metadata="$(cat "$ROOT_DIR/unity-mcp-ui-layout/agents/openai.yaml")"

docs="$(
  cat "$ROOT_DIR/Platform/Codex/README.md"
  printf '\n'
  cat "$ROOT_DIR/examples/README.md"
)"

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local scope="$3"

  if ! grep -Fqi "$needle" <<<"$haystack"; then
    printf 'Missing trigger phrase in %s: %s\n' "$scope" "$needle" >&2
    return 1
  fi
}

assert_contains "$skill_frontmatter" "attached UI mockup" "skill frontmatter"
assert_contains "$skill_frontmatter" "mockup screenshot" "skill frontmatter"
assert_contains "$skill_frontmatter" "dropped design image" "skill frontmatter"
assert_contains "$skill_frontmatter" "reference image" "skill frontmatter"
assert_contains "$skill_frontmatter" "turn or convert" "skill frontmatter"
assert_contains "$skill_frontmatter" "create Unity UI prefabs" "skill frontmatter"
assert_contains "$skill_frontmatter" "UI 시안" "skill frontmatter"
assert_contains "$skill_frontmatter" "프리팹 생성" "skill frontmatter"

assert_contains "$agent_metadata" "mockup screenshots" "agent metadata"
assert_contains "$agent_metadata" "dropped design images" "agent metadata"
assert_contains "$agent_metadata" "reference images" "agent metadata"
assert_contains "$agent_metadata" "turn, convert, make, generate" "agent metadata"
assert_contains "$agent_metadata" "create Unity UI prefabs" "agent metadata"
assert_contains "$agent_metadata" "UI 시안" "agent metadata"
assert_contains "$agent_metadata" "프리팹" "agent metadata"
assert_contains "$agent_metadata" "시안 던져" "agent metadata"

assert_contains "$docs" "prefab-from-mockup-example.md" "Codex/examples docs"
assert_contains "$docs" "without naming the skill explicitly" "Codex/examples docs"
assert_contains "$docs" "UI 시안" "Codex/examples docs"
assert_contains "$docs" "프리팹 생성" "Codex/examples docs"
assert_contains "$docs" "Unity UI 프리팹 만들어줘" "Codex/examples docs"
assert_contains "$docs" "reference image" "Codex/examples docs"
assert_contains "$docs" "시안 던져줄게" "Codex/examples docs"
