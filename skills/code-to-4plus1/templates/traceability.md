# 关联与证据记录格式

建议在生成文档目录维护 traceability.yaml；下列 YAML 是字段示例，尖括号不是事实。也可用等价表格维护，但不得丢失版本、适用条件和多对多关系。

ID 在项目内稳定且唯一，不把行号作为 ID。正文在定义位置提供同名锚点或稳定标题，引用使用页面链接及 ID。

```yaml
baseline:
  repository: "<仓库标识>"
  commit: "<SHA；无 Git 则空>"
  snapshot: "<未提交差异或无 Git 快照标识>"
  scope: ["<目录>"]
  excluded: ["<排除项及原因>"]
scenarios:
  - id: SC-001
    status: "candidate" # 或 field-confirmed，仍需具体证据范围
    page: "<场景页相对路径>"
    deployments: [DP-001]
deployments:
  - id: DP-001
    status: "declared"
    applicability: "<现场约束及适用版本>"
    instances: [RI-001]
    evidence: [E-001]
instances:
  - id: RI-001
    executable: "<程序或制品标识>"
    version: "<实际版本或未知>"
    node_role: "<节点角色或未知>"
    evidence: [E-001]
modules:
  - id: MOD-001
    architecture: [ARCH-001]
    detailed_design: [DD-001]
designs:
  - id: ARCH-001
    kind: architecture
    page: "<模块页及锚点>"
    evidence: [E-001]
  - id: DD-001
    kind: detailed-design
    page: "<模块页及锚点>"
    evidence: [E-001]
capabilities:
  - id: CAP-001
    description: "<能力>"
    modules: [MOD-001]
links:
  - scenario: SC-001
    deployment: DP-001
    step: "<步骤标识>"
    instance: RI-001
    capability: CAP-001
    module: MOD-001
    architecture: ARCH-001
    detailed_design: DD-001
    configuration:
      key: "<配置键；无则显式不适用>"
      condition: "<适用值或条件；秘密不记录>"
      read_symbol: "<读取点>"
      use_symbol: "<影响执行的分支>"
    source:
      path: "<源码相对路径>"
      symbol: "<符号>"
      lines: "<起止行>"
      baseline: "<对应 SHA 或快照>"
    evidence: [E-001]
    validation: "<未验证，或实际验证记录链接>"
evidence:
  - id: E-001
    claim: "<关键结论>"
    status: "confirmed-source"
    sources:
      - type: "source" # configuration / test / field / document
        locator: "<路径、符号、行号或资料 URL / 页码>"
        version: "<源码或资料版本>"
    field_context: null # 现场来源需环境、时间、版本、确认范围
    limitations: ["<结论不能证明什么>"]
```

允许没有配置项或验证结果，但必须明确不适用或未验证；不填造假值。示例 E-001 不得替代不同结论的独立证据。外部系统边界可以没有本地实现，必须明确边界并给契约来源。

检查：每条 link 的 ID 都有定义；SC 引用的 DP 包含所用 RI；MOD 的 ARCH 与 DD 都存在；证据定位有效且版本匹配；新增或删除对象同步更新正反向引用。字段非空仅证明结构齐备，不证明语义成立。
