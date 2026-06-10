#!/usr/bin/env bash
set -euo pipefail

MODEL_PATH="/mnt/waiwai/models/Qwen3.6-35B-A3B-GPTQ-Int4"
SERVED_NAME="qwen3.6-35b-gptq-int4"
VLLM_BIN="/usr/local/bin/vllm"
RUNTIME_DIR="/root/lmcache_runtime"
LOG_DIR="$RUNTIME_DIR/logs"

TP_SIZE="${TP_SIZE:-2}"
MAX_MODEL_LEN="${MAX_MODEL_LEN:-65536}"
MAX_NUM_SEQS="${MAX_NUM_SEQS:-16}"
MAX_NUM_BATCHED_TOKENS="${MAX_NUM_BATCHED_TOKENS:-4096}"
GPU_MEMORY_UTILIZATION="${GPU_MEMORY_UTILIZATION:-0.85}"

mkdir -p "$LOG_DIR"

export PYTHONHASHSEED="${PYTHONHASHSEED:-0}"
export CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES:-0,1}"
export VLLM_SERVER_DEV_MODE="${VLLM_SERVER_DEV_MODE:-1}"

"$VLLM_BIN" serve "$MODEL_PATH" \
  --host 0.0.0.0 \
  --port 8001 \
  --served-model-name "$SERVED_NAME" \
  --tensor-parallel-size "$TP_SIZE" \
  --max-model-len "$MAX_MODEL_LEN" \
  --max-num-seqs "$MAX_NUM_SEQS" \
  --max-num-batched-tokens "$MAX_NUM_BATCHED_TOKENS" \
  --gpu-memory-utilization "$GPU_MEMORY_UTILIZATION" \
  --kv-cache-dtype fp8 \
  --mamba-cache-dtype bfloat16 \
  --mamba-ssm-cache-dtype bfloat16 \
  --dtype bfloat16 \
  --reasoning-parser qwen3 \
  --trust-remote-code \
  --enable-prefix-caching \
  --no-disable-hybrid-kv-cache-manager \
  --kv-transfer-config '{"kv_connector":"LMCacheMPConnector","kv_connector_module_path":"lmcache.integration.vllm.lmcache_mp_connector","kv_role":"kv_both","kv_connector_extra_config":{"lmcache.mp.host":"tcp://127.0.0.1","lmcache.mp.port":5555}}' \
  2>&1 | tee "$LOG_DIR/vllm_qwen36_mp.log"
