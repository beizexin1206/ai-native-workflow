---
name: init
description: Adapt repository guidance to ai-native-workflow using existing project conventions. Use for /init or requested workflow setup; preserve platform, files and CI settings.
---

# /init —— 按项目现状接入工作流

读取现有指导文件、README、知识地图、模板和工具配置，确认项目使用的需求来源、代码平台、文档位置、验证命令及发布边界。

技能在机器上，不要求每个项目初始化后才能使用。已有入口足够时报告可直接使用，不再注入重复规则。

需要补充时参考源目录的 `AGENTS.block.md`，仅补项目真实缺口；遵循用户确认的范围，已有内容不覆盖。更新既有标记块也先核对项目定制，不因块来源于 Workflow 就直接替换。

项目已有模板优先。确实需要且没有同类模板时可选用本包产品需求或审查描述模板，放在项目约定位置；没有位置约定时提出具体位置，不创建整套固定目录。

源码、测试、验证命令与上下文入口依据实际文件核实；未知信息明确报告，不制造占位、空文档或固定数量的坑。

项目级技能、跨工具软链接、CLI 安装、CI 与分支保护不是默认接入步骤。只有用户明确要求时才核对现有配置并执行，不覆盖其他来源的内容。

报告实际新增、更新、跳过的内容与原因；是否提交依用户授权，不自动修改源码或外部任务。
