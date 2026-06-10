#!/usr/bin/env bash
set -euo pipefail

RUNTIME_DIR="/root/lmcache_runtime"
SCRIPT_DIR="$RUNTIME_DIR/scripts"
LOG_DIR="$RUNTIME_DIR/logs"
mkdir -p "$LOG_DIR"

if ! curl -fsS http://127.0.0.1:8080/healthcheck >/dev/null 2>&1; then
  nohup bash "$SCRIPT_DIR/start_lmcache_qwen36_mp.sh" \
    > "$LOG_DIR/lmcache_qwen36_mp.launcher.log" 2>&1 &

  for _ in $(seq 1 90); do
    if curl -fsS http://127.0.0.1:8080/healthcheck >/dev/null 2>&1; then
      break
    fi
    sleep 1
  done
fi

curl -fsS http://127.0.0.1:8080/healthcheck >/dev/null
echo "LMCache ready on 5555/8080"

if ! curl -fsS http://127.0.0.1:8001/v1/models >/dev/null 2>&1; then
  nohup bash "$SCRIPT_DIR/start_vllm_qwen36_mp.sh" \
    > "$LOG_DIR/vllm_qwen36_mp.launcher.log" 2>&1 &

  for _ in $(seq 1 900); do
    if curl -fsS http://127.0.0.1:8001/v1/models >/dev/null 2>&1; then
      break
    fi
    if ! pgrep -af 'vllm serve /mnt/waiwai/models/Qwen3.6-35B-A3B-GPTQ-Int4' >/dev/null 2>&1; then
      echo "vLLM exited before ready" >&2
      tail -n 120 "$LOG_DIR/vllm_qwen36_mp.log" >&2 || true
      exit 1
    fi
    sleep 2
  done
fi

curl -fsS http://127.0.0.1:8001/v1/models
echo
echo "vLLM ready on 8001"
