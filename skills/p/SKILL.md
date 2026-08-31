---
name: p
description: Breaks a SPEC into small verifiable tasks and records the rationale for every design choice at the moment it is made. Use when a spec exists and work needs slicing, when the user says /p, or when asked to plan, break down or sequence a change.
---

# /p —— SPEC → 计划 + 任务 + 选型理由

## 输入

`SPEC.md`（没有就先跑 `/s`，不要替用户臆造需求）+ 相关代码 + `docs/intent/`。

**先进只读模式**：读代码、理清组件依赖，再动笔。

## 产出

三样东西，缺一不可：

### 1. `tasks/plan.md` —— 怎么做

按阶段组织，每阶段写清改哪些模块、验收标准、验证方式。

### 2. `tasks/todo.md` —— 做什么

checklist，**纵向切分**：一个任务 = 一条完整路径（能独立验证、能独立提交），
不是「先写完所有 model 再写所有 controller」。

每个任务小到能在一次专注会话里完成实现 + 测试 + 验证。

```markdown
- [ ] Task 1: <一句话> — 验收：<怎么算完成>
```

### 3. `docs/intent/<主题>.md` —— 为什么这么选 ★

**只要某一步存在两个以上可行方案，就当场记下来：**

```markdown
## <决策点>
- 候选：A / B / C
- 选择：B
- 理由：<为什么>
- 否决 A 的原因：<为什么不>
- 否决 C 的原因：<为什么不>
```

**必须在决策当时写。** 只存在于本次会话里的理由，会话一结束就没了；
事后从代码里读不回来，从 diff 里更推不出来。这是后面 MR 的 Why 段唯一的原料来源。

## 项目评审视图（存在才做）

`tasks/plan.md`、`tasks/todo.md` 和 `docs/intent/` 形成后，如果 `docs/templates/` 下的项目自带子目录
包含技术设计模板，自动从 SPEC、代码现状和本轮三个核心产物生成或更新技术设计。只写实际涉及的内容，
不从 diff 编造理由，不复制维护第二套决策。没有项目模板子目录时跳过；本规则不改变 `/p` 的三个核心产物和批准门。

## 规则

1. **规划期间不写代码。**
2. 阶段之间插检查点：跑到这里应该能验证什么。
3. 一个任务 = 一个人 = 一个 commit。多人并行时在 todo 里标认领人。
4. 计划要给人确认后再进 `/b`。**生成计划的人不批准计划。**

## 何时进下一步

`tasks/todo.md` 每条都可独立验证，`docs/intent/` 里记下了这一轮所有的多选一。
然后跑 `/b`。

## Red Flags

- `docs/intent/` 是空的，但你在计划里做了 3 个技术选型
- 任务是横向分层（「实现所有 API」），验证不了单条
- 任务大到一次会话做不完
- 计划里出现 SPEC 没要求的功能
