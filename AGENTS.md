# Repository Guidelines

## Project Structure & Module Organization
- Core entrypoint: `main.py` (evaluation orchestration) with `agent.py`, `initialization.py`, `conversation_creator.py`.
- Configs: `configs/agent_conf/*` (agent/model YAML) and `configs/data_conf/*` (dataset YAML).
- Batch runners: `bash_files/sh/*.sh` using config lists in `bash_files/configs/*`.
- Methods and utilities: `methods/`, `utils/` (helpers, metrics).
- LLM-based metrics: `llm_based_eval/*.py`.
- Assets and integrations: `assets/`, `cognee/`, `letta/`, `mem0/`.

## Build, Test, and Development Commands
- Environment setup
  - `conda create --name MABench python=3.10.16`
  - `pip install -r requirements.txt` and `pip install torch "numpy<2"`.
- Run single evaluation
  - `python main.py --agent_config configs/agent_conf/Long_Context_Agents/<file>.yaml --dataset_config configs/data_conf/<file>.yaml [--chunk_size_ablation N --max_test_queries_ablation M --force]`
- Batch runners
  - `bash bash_files/sh/run_memagent_longcontext.sh`
  - `bash bash_files/sh/run_memagent_rag_agents.sh`
  - Use `CUDA_VISIBLE_DEVICES=<id>` to select GPU.
- LLM-based metric evaluation
  - `python llm_based_eval/longmem_qa_evaluate.py`
  - `python llm_based_eval/summarization_evaluate.py`

## Coding Style & Naming Conventions
- Python 3.10+, 4-space indentation, PEP 8; prefer type hints and docstrings.
- Use `logging.getLogger(__name__)` (see `main.py`) rather than `print` in library code.
- Files/modules: `snake_case.py`. Configs: YAML under `configs/.../*.yaml`.
- Keep functions focused; avoid hidden side effects; use f-strings.

## Testing Guidelines
- No formal unit test suite present. Validate locally via `main.py` with small configs and `llm_based_eval/*` for metrics sanity.
- If adding tests, create `tests/` and use `pytest`. Name tests `test_<module>.py`; set deterministic seeds where applicable.

## Commit & Pull Request Guidelines
- Commits: imperative, concise subject; optional body with rationale, affected configs, and references (e.g., "Add TTL ablation flag in main.py").
- PRs: include description, reproduction commands, sample configs, and before/after results (JSON path or log snippets). Link issues; screenshots for UI/asset changes.
- Update README/AGENTS.md when changing flags, config schemas, or runner behavior.

## Security & Configuration Tips
- Do not commit secrets. Use `.env` at repo root: `OPENAI_API_KEY`, `LLM_MODEL`, `LLM_API_KEY`, `Anthropic_API_KEY`, `Google_API_KEY`.
- Avoid committing large artifacts; store external paths in configs.
- Some packages (e.g., `hipporag`) may conflict; isolate in separate environments if needed.
