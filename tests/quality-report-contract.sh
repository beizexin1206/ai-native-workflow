#!/usr/bin/env sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
REPORT="$ROOT/templates/quality-report.html"
SKILL="$ROOT/skills/t/SKILL.md"

require_text() {
  file=$1
  expected=$2
  if ! grep -Fq "$expected" "$file"; then
    printf '缺少契约字段：%s（%s）\n' "$expected" "$file" >&2
    exit 1
  fi
}

for text in \
  "登记缺陷" \
  "优先级执行分布" \
  "P0" \
  "P1" \
  "P2" \
  "证据例外与验证降级" \
  "人工裁决/依据" \
  "证据强度" \
  "复杂项目可选：联合发布评估"
do
  require_text "$REPORT" "$text"
done

require_text "$SKILL" "不得复制完整缺陷档案"
require_text "$SKILL" "P0/P1/P2"
require_text "$SKILL" "验证方式降级"
require_text "$SKILL" "联合发布评估"

printf '质量报告人工 Review 契约检查通过\n'
