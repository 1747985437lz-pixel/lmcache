#!/usr/bin/env bash
set -euo pipefail

pkill -TERM -f 'vllm serve /mnt/waiwai/models/Qwen3.6-35B-A3B-GPTQ-Int4' 2>/dev/null || true
pkill -TERM -f 'from lmcache.cli.main import main; main.* server ' 2>/dev/null || true
sleep 8
pkill -KILL -f 'vllm serve /mnt/waiwai/models/Qwen3.6-35B-A3B-GPTQ-Int4' 2>/dev/null || true
pkill -KILL -f 'from lmcache.cli.main import main; main.* server ' 2>/dev/null || true

nvidia-smi --query-gpu=index,memory.used,utilization.gpu --format=csv,noheader || true
