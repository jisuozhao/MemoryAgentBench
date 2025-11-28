#!/bin/sh
set -eu

# Run only the mem0 ∞‑Bench (InfBench Summarization) evaluation.
#
# Usage examples:
#   bash scripts/run_mem0_infbench.sh
#   bash scripts/run_mem0_infbench.sh --gpu 0 --max 50
#   bash scripts/run_mem0_infbench.sh --chunk 2048 --force
#   bash scripts/run_mem0_infbench.sh -- --max_test_queries_ablation 20  # pass-through flags after --
#
# Requirements:
# - Ensure your environment is activated and dependencies installed.
# - Set OPENAI_API_KEY (and optionally Azure OpenAI envs) in .env or shell.

SCRIPT_DIR="$(dirname "$0")"
if [ "$SCRIPT_DIR" = "." ]; then
  ROOT_DIR="$(cd .. && pwd)"
else
  ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

AGENT_CFG="configs/agent_conf/RAG_Agents/gpt-4o-mini/Structure_rag_gpt-4o-mini-mem0.yaml"
DATA_CFG="configs/data_conf/Long_Range_Understanding/InfBench_sum.yaml"

EXTRA_ARGS=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --gpu)
      shift
      CUDA_VISIBLE_DEVICES="${1:-0}"
      export CUDA_VISIBLE_DEVICES
      ;;
    --max)
      shift
      EXTRA_ARGS="$EXTRA_ARGS --max_test_queries_ablation ${1:-20}"
      ;;
    --chunk)
      shift
      EXTRA_ARGS="$EXTRA_ARGS --chunk_size_ablation ${1:-2048}"
      ;;
    --force)
      EXTRA_ARGS="$EXTRA_ARGS --force"
      ;;
    --)
      shift
      # Pass-through any remaining args verbatim
      while [ "$#" -gt 0 ]; do
        EXTRA_ARGS="$EXTRA_ARGS $1"
        shift
      done
      break
      ;;
    *)
      # Unrecognized options are passed through as-is
      EXTRA_ARGS="$EXTRA_ARGS $1"
      ;;
  esac
  shift || true
done

python "${ROOT_DIR}/main.py" \
  --agent_config      "${ROOT_DIR}/${AGENT_CFG}" \
  --dataset_config    "${ROOT_DIR}/${DATA_CFG}" \
  $EXTRA_ARGS
