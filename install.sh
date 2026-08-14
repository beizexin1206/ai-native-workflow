#!/usr/bin/env sh
# ai-native-workflow 步骤 1：把 skills 装到这台机器上（不进任何项目仓库）。
#
#   curl -fsSL https://raw.githubusercontent.com/kid7st/ai-native-workflow/main/install.sh | sh
#
# 重复执行安全：已克隆则 pull。
#
# 装完后在任意项目里跑 /init 完成步骤 2。
# 升级：cd ~/.ai-native-workflow && git pull —— 软链自动跟上。
set -eu

REPO="${AI_NATIVE_WORKFLOW_REPO:-https://github.com/kid7st/ai-native-workflow.git}"
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
echo "下一步：在项目里打开 agent，说 /init"
