# 场景驱动的 4+1 文档 Skill

入口：[SKILL.md](SKILL.md)。本目录是可复用 Skill 文件包，不包含某个真实项目生成的架构文档，也不表示已在 Harness profile 注册或在知识库发布。

## 使用

在支持本地 Skill 的客户端中，将本目录作为一个完整 Skill 包加载。若当前客户端尚未发现该 Skill，可在会话中明确让助手先读取主入口，并依其相对链接按需加载资源；不能仅凭目录存在认定运行时会自动发现。全局安装或配置变更遵循客户端的真实加载机制另行办理。

示例请求：

> 按 skills/code-to-4plus1/SKILL.md，为指定源码目录编写中文知识库文档。先分析代码、生成候选场景，现场资料暂缺。开发视图必须具备架构说明与详细设计。

> 补充场景 SC-001 的现场部署资料。请核对程序版本和配置，再更新该场景到源码的关联及受影响设计。缺少依据的部分保留待确认。

> 根据新旧源码基线增量更新知识库，检查架构与详细设计、场景与部署路径的关联，并列出需要重新进行现场验证的项目。

首次使用需要提供真实源码位置；不要将文档模板当成目标系统源码。

## 安装与分发

Claude Code：在仓库根目录执行：

```bash
mkdir -p ~/.claude/skills
cp -r skills/code-to-4plus1 ~/.claude/skills/
```

claude.ai：将 SKILL.md 及本目录的按需资源一并加入项目知识；也可在会话中粘贴主入口，并按需提供资源。只粘贴主入口无法替代其引用的完整文件包。

分发包位于 skills/code-to-4plus1.zip，内含 code-to-4plus1/ 顶层目录。为保留已确认的按需加载与独立分发结构，本 Skill 的专用指南保留在包内 references/；不依赖仓库根目录的共享文件。

## 组织

- [证据规则](references/evidence-policy.md)：结论状态、版本定位、冲突和敏感信息边界。
- [源码发现](references/discovery.md)：范围、入口、能力和配置扫描。
- [场景与物理](references/scenario-physical.md)：现场部署、配置分支和代码的一体关联。
- [逻辑与进程](references/logical-process.md)：职责、运行机制及场景差异。
- [开发视图](references/development.md)：架构说明和详细设计的双层要求。
- [增量维护](references/incremental-update.md)：源码和现场变化的影响分析。
- [质量门槛](references/quality-gates.md)：内容、关联、证据及交付检查。
- [页面模板](templates/pages.md)：总览、场景、视图、模块、待确认与变更模板。
- [关联格式](templates/traceability.md)：场景、部署、实例、能力、模块、设计和证据索引。

质量检查以清单审阅为主；[校验脚本](scripts/validate-package.sh) 仅检查 Skill 文件包结构和本地链接，需 Bash 和 Python 3.9+。真实项目的源码生成、图形渲染与知识库发布须分别验证，不能从文件包静态校验推定通过。
