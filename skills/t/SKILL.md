---
name: t
description: Turns acceptance criteria into executable tests, runs the full regression suite, and fixes bugs with a reproducing test first. Use when verifying a change against the spec, when a bug is reported, when the user says /t, or when asked to test, verify or reproduce.
---

# /t —— 用例化、回归、修 bug

## 三种场景

### 1. 新功能：验收标准 → 可执行用例

`SPEC.md` 的「可验证行为」逐条变成测试。一条行为对不上任何测试 = 没验收。

覆盖不只是正常路径：**边界、错误路径、并发/重入**（如果适用）。
只有 happy path 的测试套件给的是虚假的安全感。

### 2. 修 bug：Prove-It 模式

1. **先写一个能复现 bug 的测试**，确认它 FAIL
2. 再修
3. 用同一个测试证明修好了
4. 跑全量回归

**没有复现测试的修复不算修复。** 它会以另一种形式回来。

发现缺陷时交给开发的是**一个失败的测试**，不是一句「这里有问题」。

### 3. 回归：全量跑，给结论

新需求不只跑新用例。旧用例全量跑一遍，产出**回归结论**：

```
跑了 N 条，挂 M 条：
- <用例>：<为什么挂> → <修 / 是预期变更，已更新用例 / 已知问题，工作项 PROJ-xxxx>
```

这份结论是 MR 「Tests」段的原料。**「测试通过」四个字不是结论**，
没说清跑了什么、挂了什么、为什么可以放，等于没验。

## 定位问题时

先保留证据（日志、失败输出、复现步骤），再动手。
按 复现 → 定位 → 简化 → 修复 → 防护 走，**找根因不打补丁**：
grep 一遍同一个函数的所有调用方，只修 ticket 说的那条路径，兄弟调用方还是坏的。

同一个症状修第二次 → 停下来跑 `/ct`。

## Red Flags

- 测试是照着实现写的（实现改了测试就挂，但行为没变）
- 为了让测试变绿而改测试
- 回归「跑过了」但说不出跑了多少条
- 缺陷报告里没有可复现的最小步骤
