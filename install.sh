#!/usr/bin/env sh
# ai-native-workflow 步骤 1：把 skills 装到这台机器上（不进任何项目仓库）。
#
#   curl -fsSL https://raw.githubusercontent.com/beizexin1206/ai-native-workflow/main/install.sh | sh
#
# 重复执行安全：已克隆则 pull。
#
# 装完后直接使用；需要接入项目约定时按需跑 /init。
# 升级：cd ~/.ai-native-workflow && git pull —— 软链自动跟上。
set -eu

REPO="${AI_NATIVE_WORKFLOW_REPO:-https://github.com/beizexin1206/ai-native-workflow.git}"
HOME_DIR="${AI_NATIVE_WORKFLOW_HOME:-$HOME/.ai-native-workflow}"

if [ -d "$HOME_DIR/.git" ]; then
  echo "更新 $HOME_DIR"
  git -C "$HOME_DIR" pull --ff-only --quiet
else
  echo "克隆到 $HOME_DIR"
  git clone --quiet "$REPO" "$HOME_DIR"
fi

# 四个 harness 的用户级 skill 目录。Codex 与 pi 共用 ~/.agents/skills。
if [ ! -d "$HOME_DIR/skills" ]; then
  echo "错误：$HOME_DIR/skills 不存在，仓库内容不完整" >&2
  exit 1
fi

for dir in "$HOME/.agents/skills" "$HOME/.claude/skills" "$HOME/.qoder/skills"; do
  mkdir -p "$dir"
  # /mr renamed to /pr: remove only this installation's obsolete link.
  if [ -L "$dir/mr" ] && [ ! -f "$HOME_DIR/skills/mr/SKILL.md" ]; then
    old_skill_source=$(readlink "$dir/mr")
    if [ "$old_skill_source" = "$HOME_DIR/skills/mr" ] || [ "$old_skill_source" = "$HOME_DIR/skills/mr/" ]; then
      rm "$dir/mr"
    fi
  fi
  for skill in "$HOME_DIR"/skills/*/; do
    [ -f "$skill/SKILL.md" ] || continue
    name=$(basename "$skill")
    target="$dir/$name"
    # 已存在且不是我们建的软链 → 跳过，不覆盖别人的同名 skill
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "  跳过 $target（已存在同名目录）"
      continue
    fi
    ln -sfn "$skill" "$target"
  done
done

echo "已装 $(ls -1 "$HOME_DIR"/skills | wc -l | tr -d ' ') 个 skill → ~/.agents/skills, ~/.claude/skills, ~/.qoder/skills"
echo
echo "技能已可使用；需要接入项目约定时说 /init"
