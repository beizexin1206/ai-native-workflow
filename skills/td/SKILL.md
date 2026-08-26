---
name: td
description: Generates or reviews a structured technical design document from requirements, code, architecture context and API docs. Use when the user says /td, asks to write a technical design, create a design doc, or review an existing technical proposal.
---

# /td —— 技术设计方案

把需求、代码事实和架构上下文整理成一份可以由研发、测试和架构负责人共同评审的技术设计方案。

## 输入优先级

1. 项目代码：相关 Controller、Service、Model、Mapper、配置、迁移和测试
2. `SPEC.md`、Meegle 工作项、产品文档和原型
3. 项目架构、API、数据模型、系统约束与外部依赖文档
4. 已有同类技术设计和 `docs/intent/` 中的决策

代码与文档冲突时，先指出冲突；不要静默选择一边。缺失信息写「待补充」，不得编造。

## 产出

默认输出 `docs/design/technical-design.md`，结构以仓库中的
`templates/technical-design.md`（接入项目后为 `docs/templates/technical-design.md`）为准。

## 工作流

1. 读取输入并列出已确认事实、冲突和缺口。
2. 复制模板生成骨架，只保留与本次改动相关的内容；不涉及的主章节写明“无变更”，不要假装遗漏。
3. 先填方案概览、数据流和关键取舍，再填接口、数据、基础设施、前端和测试设计。
4. 把不可从代码恢复的取舍同步写入 `docs/intent/<主题>.md`。
5. 自检后交给技术负责人、测试和相关系统负责人评审；这一步不写实现代码。

## 自检

- [ ] 目标、范围内和范围外都明确
- [ ] 每个接口/事件写清输入、输出、核心逻辑和失败处理
- [ ] 数据变更包含兼容、迁移和回滚影响
- [ ] 缓存、消息、定时任务、外部依赖不涉及时明确写“无变更”
- [ ] 权限、安全、幂等、并发和异常路径已判断
- [ ] 测试分层与灰度、监控、回滚可以执行
- [ ] 所有“待补充”都有负责人或待确认项
- [ ] 没有密码、Token、Cookie、生产数据等敏感信息

## Red Flags

- 只改模板措辞，没有读代码确认现状
- 接口只有路径，没有入参、出参和错误行为
- SQL 是伪代码，或 schema 变更没有迁移与回滚说明
- “灰度方案”只有一步全量上线
- 缓存、队列、安全章节直接删除，导致评审人无法区分“不涉及”和“漏设计”
- 所有章节都写得很完整却没有任何“待补充”或待确认项
