<!-- ai-native-workflow:start -->
## 研发协作约定

需求在 **Meegle**（飞书项目），代码在 **GitLab**，讨论在飞书。三者的分工：
Meegle 管「为什么做」，仓库管「做什么、怎么做」，飞书文档给人看、**agent 读不到**。

### 本项目的事实来源

按优先级排，**冲突时以序号小的为准**。`/init` 之后由项目自己补第 5 条起：

1. `AGENTS.md`（本文件）—— 协作约定与项目事实
2. Meegle 工作项 + `SPEC.md` —— 现在在做什么
3. `docs/intent/` —— 为什么这么选、否决了什么
4. `README.md` —— 怎么跑起来
5. <项目自己的：架构文档 / 设计系统 / ADR 目录…>

### 主线

```
Meegle 工作项 → /s → /p → /b → /t → /rv → MR → /fb → 合入 → 回写工作项状态
                SPEC   plan   代码   测试   自审        处理 comment
```

一个工作项 = 一个分支 = 一个 MR = 一个人。分支名与 MR 标题都带工作项号：
`feat/PROJ-1234-order-state` / `feat(order): 对账逻辑 [PROJ-1234]`。
分支前缀：`feat/` `fix/` `refactor/` `docs/` `chore/` `ci/`。

**开工前先同步**：`git fetch origin && git pull --rebase origin main`。

**本地优先。** 能在本地验证的**必须**在本地验证完再开 MR。本地一轮 1 秒，
推上去等 CI + 部署一轮 10 分钟 —— 用流水线当迭代循环，是把决策节奏拖慢 100 倍。
**同一个分支第三次 push「看看线上行不行」时，停下来改在本地复现。**
只有本地真的验不了的才推上去：CI 环境特有的、需要真实基础设施的、要给人点的。

**同一个症状修第二次 —— 停。** 别找第三个补丁，跑 `/ct` 从第一性原理重新框定问题。

### 上下文一致性契约

**改代码就同步改它的伴随物。** 代码、测试、文档、`AGENTS.md` 是一个整体，
任何一处与其他三处矛盾，就是 bug —— 而且是最贵的那种，因为下一个人（和下一次的 AI）
会拿它当真。

| 你改了 | 必须同步检查 |
|---|---|
| 行为 / 接口 | 测试、`README`、`AGENTS.md` 里描述该行为的段落 |
| 目录结构 / 命令 | `AGENTS.md` 的项目结构与命令段 |
| 协作流程 | 本段落自身 |
| 任何取舍 | `docs/intent/<主题>.md`（为什么这么选、否决了什么） |

检查点只有一个：**开 MR 时**。MR 的 Scope 段必须回答「本次是否改变了 AGENTS.md 描述的行为」。
写不出来就是没想清楚，不是格式问题。

**过程文档是脚手架，不是交付物。** 不要生成 `SESSION_*.md`、`HANDOFF.md`、`*_PLAN.md`、
`*_PROGRESS.md` 这类一次性笔记。真正有价值的沉淀进 `docs/intent/` 或 `AGENTS.md`，其余删掉。

**已知的坑**记在 `docs/intent/GOTCHAS.md`：踩了会疼、但从代码里看不出来的地方
（并发时序、部署顺序、某个字段不能直接改）。它和 `docs/intent/<主题>.md` 的分工：
主题文件记「为什么这么选」，GOTCHAS 记「碰了会出事」。

### 谁负责哪一段

| 角色 | 对什么负责 | 主要动作 | 交出什么 |
|---|---|---|---|
| 产品 | 需求可执行、验收标准可测 | 写 Meegle 工作项 → `/s` | 工作项 + `SPEC.md`（带单号） |
| 研发 | 实现与上下文沉淀 | `/p` → `/b` → `/t` → `/rv` → MR → `/fb` | plan/todo、代码+测试、六段 MR |
| 测试 | 验收与回归口径 | 按工作项验收标准逐条验 | 验收结论、复现测试、回归结果 |
| 任何人 | review | `/rv <MR>` | MR 上逐条 resolve 的 discussion |

这是**责任边界，不是权限边界**。产品和测试同样可以跑 `/b` 改代码、开 MR。

### Meegle 约定

- **需求的唯一来源是工作项**，不是聊天记录、不是会议纪要。
- 装了飞书项目 CLI 时 agent 自己读工作项；没装就把内容贴给它 —— **不许猜**。
- 工作项写法见 `docs/templates/meegle-work-item.md`。**验收标准必须可测**，
  写不出可测的验收标准 = 需求没想清楚，不进开发。
- 变更走 Meegle → SPEC.md 单向流动。反过来只改 SPEC.md 不回写，两边立刻漂移。
- MR 合入后回写工作项状态。

```bash
npm i -g @lark-project/meegle && meegle auth login   # 未装时
```

### GitLab 约定

- 评审叫 **MR**，用 `glab`。MR 描述按 `docs/templates/merge-request.md` 六段写：
  What / Why / How / Scope / Tests / 注意点。
- **四段以上的内容由 agent 从仓库产物汇总**（SPEC、plan、commits、测试结果）。
  唯独 **Why** 无法事后重建 —— 它必须在 `/p` `/b` 阶段当场写进 `docs/intent/`。
  找不到出处时**报缺口，不要从 diff 反推**：编出来的理由看起来像结论，实际没有任何决策发生过。
- review findings 落成 **MR 上独立的 discussion**（一条一个，才能逐条 resolve），
  不落在聊天窗口。
- **未 resolve 的 discussion 不得合入。** 每条只有两种结局：修掉，或带理由不修，两种都要回复。
- **agent 永不合并 MR。** CI 绿了就报告「ready to merge」并停下 —— 合并是人的显式决定，
  本会话代开的 MR 也一样。review / 评论 / 处理 comment 都可以做。
- 合并方式 squash，一个 MR 一个 commit。MR 标题和描述会成为 commit message，值得花时间写。
- MR 存活 ≤ 3 天；更久就 rebase 到最新主干，并在描述里说明「是否与进行中的 MR 冲突」。
- 合并后清理，别让本地攒一堆死分支：

  ```bash
  git checkout main && git pull --ff-only && git branch -d <分支> && git fetch --prune origin
  ```

**哪些必须人审、哪些可以快过：**

| 类别 | 要求 |
|---|---|
| schema 迁移、认证/权限、公开接口、删代码、不可逆操作 | **必须人审**，不接受「CI 绿就行」 |
| 文档、语义等价的重构、补测试、typo | CI 绿 + 你明确点头即可 |

- **迁移只能向前。** 代码可以 revert，schema 不能。破坏性变更拆成多个 MR：
  加新的 → 双写 → 删旧的。

**合并前本地验证**（`/init` 后由项目填成真实命令）：

| 检查 | 命令 | 门槛 |
|---|---|---|
| lint | `<项目填>` | 0 error |
| 类型 | `<项目填>` | 0 error |
| 测试 | `<项目填>` | 0 failing |

### 沟通

读者是对这个项目有完整上下文的工程师，不需要背景铺垫、鼓励性措辞、或对刚说过的话的复述。

- **结论前置。** 先给决策/结论/行动项，再给依据。
- **结构化对比用表格**，不用散文堆砌。
- **跳过显而易见的推理。** 证据能直推结论就直接给。
- **不要元叙述。** 不说「如果你同意我就开始」、不预告自己接下来要做什么 —— 直接做，或直接给方案。
- **不要装饰性排版。** 不要分隔线、box 字符、每段都加标题。
- **密度自检：砍掉一半后信息量是否不变？** 是就砍。对 review 的回复不应超过 review 本身的三成。

（写代码、注释、文档、commit、MR 一律中文 —— 这是团队环境，不做中英分离。）

### 命令

| 命令 | 干什么 |
|---|---|
| `/s` | 工作项 → `SPEC.md` |
| `/p` | SPEC → `tasks/plan.md` + `tasks/todo.md`，选型理由进 `docs/intent/` |
| `/b` | 实现下一个任务：测试先行、逐任务提交、坑与债进 `docs/intent/` |
| `/t` | 用例化 + 全量回归；修 bug 先写复现测试 |
| `/rv` | 五轴 review。开 MR 前自审，或 `/rv <MR号>` 审别人的 |
| `/fb` | 拉 MR 的 comment（含行内），逐条处理并 resolve |
| `/sw` | 项目全景：目标、位置、进度、下一步、风险 |
| `/rf` | 重构扫描：先结构后局部，只提案 |
| `/ct` | 跳出补丁循环，从第一性原理重新框定问题 |

没有这些命令？跑一次：
```bash
git clone https://github.com/kid7st/ai-native-workflow.git ~/.ai-native-workflow && sh ~/.ai-native-workflow/install.sh
```
<!-- ai-native-workflow:end -->
