#!/usr/bin/env sh
# 校验 MR 描述是否满足约定。只做确定性检查，不猜。
#
# CI 里由 mr-contract job 调用；本地也能直接跑：
#   CI_MERGE_REQUEST_TITLE="feat(order): 对账 [PROJ-1234]" \
#   CI_MERGE_REQUEST_DESCRIPTION="$(cat /tmp/body.md)" sh mr-contract-check.sh
set -u

TITLE="${CI_MERGE_REQUEST_TITLE:-}"
BODY="${CI_MERGE_REQUEST_DESCRIPTION:-}"
fail=0
err() { printf '✗ %s\n' "$1"; fail=1; }
ok()  { printf '✓ %s\n' "$1"; }

[ -n "$BODY" ] || { echo "✗ 拿不到 MR 描述（CI_MERGE_REQUEST_DESCRIPTION 为空）"; exit 1; }

# 取某一段的正文：`## <段名>` 之后、下一个 `## ` 之前，去掉 HTML 注释、空行、纯占位符
section() {
  printf '%s\n' "$BODY" | awk -v want="## $1" '
    $0 ~ "^"want"[[:space:]]*$" { grab=1; next }
    /^## / { grab=0 }
    grab { print }
  ' | sed -e 's/<!--.*-->//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' \
    | grep -vE '^$|^<!--|-->$|^-+$'
}

# 1. 标题带工作项号
if printf '%s' "$TITLE" | grep -qE '[A-Z][A-Z0-9]+-[0-9]+'; then
  ok "标题带工作项号"
else
  err "标题里没有工作项号。例：feat(order): 对账逻辑 [PROJ-1234]"
fi

# 2. 六段齐全且非空
for sec in What Why How Scope Tests 注意点; do
  content=$(section "$sec")
  if [ -z "$content" ]; then
    err "「${sec}」段缺失或为空"
  elif [ "$sec" != "注意点" ] && printf '%s' "$content" | grep -qxE '无|TBD|待补|N/A|/'; then
    err "「${sec}」段只有占位符（${content}）"
  fi
done

# 3. 产品设计与公共产品上下文必须可追溯。这里只检查声明存在且不是占位符；
# 内容是否一致由 /pd、/s、/p、/b 和 review 分阶段判断。
product_trace=$(printf '%s\n' "$BODY" | grep -E '^产品设计门禁:[[:space:]]*' | head -n 1)
if [ -z "$product_trace" ]; then
  err "MR 没有声明产品设计门禁"
elif printf '%s' "$product_trace" | grep -qE '<[^>]+>|TBD|待补|N/A'; then
  err "产品设计门禁仍是占位符"
elif printf '%s' "$product_trace" | grep -qE '^产品设计门禁:[[:space:]]*不适用[[:space:]]*[—-][[:space:]]*.+'; then
  ok "产品设计门禁已声明不适用及原因"
else
  if printf '%s' "$product_trace" | grep -q '产品设计:' && printf '%s' "$product_trace" | grep -q '公共产品上下文:'; then
    ok "产品设计与公共产品上下文已声明"
  else
    err "适用产品设计门禁时必须同时声明产品设计和公共产品上下文"
  fi
fi

# 4. Why 段引用的出处文件必须真实存在
why=$(section Why)
if [ -n "$why" ]; then
  paths=$(printf '%s\n' "$why" | grep -oE '(docs/intent/[A-Za-z0-9._/-]+\.md|tasks/plan\.md)' | sort -u)
  if [ -z "$paths" ]; then
    err "「Why」段没有指向出处。理由必须来自 docs/intent/<主题>.md 或 tasks/plan.md —— 从 diff 反推的理由不算"
  else
    for f in $paths; do
      if [ -f "$f" ]; then ok "Why 出处存在：$f"; else err "Why 段引用了 $f，但仓库里没有这个文件"; fi
    done
  fi
fi

[ $fail -eq 0 ] && echo "MR 约定检查通过" || echo "MR 约定检查未通过 —— 见上面的 ✗"
exit $fail
