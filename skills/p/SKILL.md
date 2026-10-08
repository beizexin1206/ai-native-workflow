---
name: p
description: Plan an approved requirement as verifiable implementation tasks and record actual design tradeoffs. Use for /p or technical planning; follow project artifacts and approval rules.
---

# /p —— 需求 → 计划、任务与选型理由

## 输入

已明确的需求或规格、相关代码、项目规则与既有设计理由。先读代码和依赖，不凭空规划；不要求特定规格文件名。

## 产出

复用项目已有方案或计划载体，说明：

1. **怎么做**：修改哪些模块、为什么、相关接口和数据边界，以及验收方法。
2. **做什么**：按完整可验证路径拆任务，不按「全部 model / 全部 controller」横向分层堆待办；必要的顺序依赖和检查点写清。
3. **为什么这么选**：真实存在多个可行方案时，在决策时记录选择、理由与取舍，不事后从代码编造，也不虚构候选。

三类信息可以在同一载体中表达，不强制分成多个文件或放入固定目录。任务、负责人、提交及审查请求的对应关系按项目约定安排。

## 规则

规划期间不实现代码。范围不超出批准需求，任务必须能验证。审批按项目与用户约定；生成方案不等于批准方案，已有明确批准不重复索取。

需求与方案具备可执行条件且获所需授权后进入 `/b`。
