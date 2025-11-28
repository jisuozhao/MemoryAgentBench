# 仓库协作指南（AGENTS）

本文件为在本仓库内工作的代理与贡献者提供统一约定；其作用域为整个仓库。若子目录存在更具体的 AGENTS.md，则以更深层目录为准。

## 项目结构与模块组织
- 核心入口：`main.py`（评测编排），配合 `agent.py`、`initialization.py`、`conversation_creator.py`。
- 配置：`configs/agent_conf/*`（模型/Agent 配置 YAML）与 `configs/data_conf/*`（数据集配置 YAML）。
- 批量运行：`bash_files/sh/*.sh`，批量列表位于 `bash_files/configs/*`。
- 方法与工具：`methods/`、`utils/`（通用工具与指标计算）。
- LLM 评测脚本：`llm_based_eval/*.py`。
- 其他集成：`assets/`、`cognee/`、`letta/`、`mem0/`。

## 构建与运行
- 环境准备
  - `conda create --name MABench python=3.10.16`
  - `pip install -r requirements.txt` 与 `pip install torch "numpy<2"`
- 运行单次评测
  - `python main.py --agent_config configs/agent_conf/Long_Context_Agents/<file>.yaml --dataset_config configs/data_conf/<file>.yaml [--chunk_size_ablation N --max_test_queries_ablation M --force]`
- 批量脚本
  - `bash bash_files/sh/run_memagent_longcontext.sh`
  - `bash bash_files/sh/run_memagent_rag_agents.sh`
  - 使用 `CUDA_VISIBLE_DEVICES=<id>` 指定 GPU。
- LLM 评测（作为 Judge）
  - `python llm_based_eval/longmem_qa_evaluate.py`
  - `python llm_based_eval/summarization_evaluate.py`

## 代码风格与命名
- Python 3.10+、四空格缩进、遵循 PEP 8；推荐类型标注与必要 docstring。
- 库代码中使用 `logging.getLogger(__name__)`（参考 `main.py`）替代 `print`。
- 文件/模块：`snake_case.py`；配置：YAML 存放于 `configs/.../*.yaml`。
- 函数职责单一，避免隐式副作用；字符串拼接优先使用 f-string。

## 测试与验证
- 暂无正式单测套件。请使用小配置通过 `main.py` 本地验证，并结合 `llm_based_eval/*` 做指标 sanity check。
- 若新增测试：请创建 `tests/` 并使用 `pytest`；命名为 `test_<module>.py`；设置随机种子以保证可复现。

## 提交与合并请求
- Commit：祈使句、标题简洁；正文可包含动机、影响范围、修改的配置与参考（例：Add TTL ablation flag in main.py）。
- PR：说明改动、附复现命令与样例配置、给出前/后结果（JSON 路径或日志片段）；关联 Issue；涉及 UI/资产改动建议附截图。
- 更改运行参数、配置结构或批量脚本行为时，请同步更新 `README.md` 与本文件。

## 安全与配置
- 切勿提交任何密钥/令牌。请在仓库根目录使用 `.env` 管理：`OPENAI_API_KEY`、`LLM_MODEL`、`LLM_API_KEY`、`Anthropic_API_KEY`、`Google_API_KEY` 等。
- 避免提交大型产物；建议在配置中引用外部路径或使用按需下载。
- 个别包（如 `hipporag`）存在版本冲突风险，必要时在独立环境中使用。

## 工作约定
- 遵循最小修改原则：仅在必要范围内变更，保持与现有风格一致。
- 涉及大规模运行或影响评测结果的改动，应先在小样本/少量查询上验证再扩展。

