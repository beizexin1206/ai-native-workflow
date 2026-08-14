# ai-native-workflow

Meegle（飞书项目）+ GitLab 的研发协作流程，打包成 skills、AGENTS.md 约定和两套模板。
支持 Claude Code、Codex、Qoder、pi —— 同一份 `SKILL.md`，不维护多份副本。

## 两步安装

**步骤 1 · 每台机器一次** —— 装能力（skills 不进任何项目仓库）：

```bash
curl -fsSL https://raw.githubusercontent.com/kid7st/ai-native-workflow/main/install.sh | sh
```

克隆到 `~/.ai-native-workflow`，重复执行安全：已克隆则 `pull`。

克隆到 `~/.ai-native-workflow`，软链到 `~/.agents/skills`（Codex + pi）、`~/.claude/skills`、`~/.qoder/skills`。
升级：`cd ~/.ai-native-workflow && git pull`，软链自动跟上。

**步骤 2 · 每个仓库一次** —— 装约定（这些要 commit）：

```
在项目里打开任意 agent，说 /init
```

注入 `AGENTS.md` 块、MR 模板、工作项模板、`docs/intent/`、项目级 skill 目录与软链。

## 命令

| 命令 | 干什么 |
|---|---|
| `/s` | Meegle 工作项 → `SPEC.md`（可测验收 + 边界 + 影响面） |
| `/p` | SPEC → `tasks/plan.md` + `tasks/todo.md`，**选型理由当场进 `docs/intent/`** |
| `/b` | 实现下一个任务：测试先行、逐任务提交、坑与债进 `docs/intent/` |
| `/t` | 验收标准用例化、全量回归、Prove-It 修 bug |
| `/rv` | 语义 review。开 MR 前自审，或 `/rv <MR>` 审别人的（findings 落成可 resolve 的 discussion） |
| `/fb` | 拉全 MR 反馈（含行内），逐条判断、修或驳、回复后 resolve |
| `/sw` | 项目全景：目标、位置、进度、下一步、风险（读仓库 + GitLab + Meegle） |
| `/rf` | 重构扫描：先结构后局部，只提案 |
| `/ct` | 跳出补丁循环，从第一性原理重新框定问题 |
| `/init` | 把当前仓库接入这套流程 |

## 设计取舍

- **能力在机器上，约定在仓库里。** skill 跟项目无关，升级一次全项目生效；
  `AGENTS.md` 和模板必须随仓库走、被 review、被版本固定。
- **一份 `SKILL.md` 服务四个工具。** Claude Code 的 commands 已并入 skills，
  Codex 与 pi 共读 `.agents/skills`，Qoder 读 `.qoder/skills` —— 用软链，不复制。
- **Why 必须当场记。** What/How/Scope/Tests 都能从仓库产物汇总，
  只有「为什么选这个方案」事后无法重建 —— 所以它在 `/p` `/b` 阶段就落进 `docs/intent/`，
  `/rv` 和 MR 模板只做汇总与校验。

## 结构

```
ai-native-workflow/
├── install.sh              # 步骤 1
├── AGENTS.block.md         # 注入项目 AGENTS.md 的内容
├── skills/                 # 10 个 skill，四个工具通用
├── templates/
│   ├── meegle-work-item.md # 需求模板：一份讲清需求，指导产品/研发/测试
│   └── merge-request.md    # MR 模板：What/Why/How/Scope/Tests/注意点
└── package.json            # pi package manifest（可选：pi install git:...）
```
