#!/usr/bin/env bash
set -euo pipefail

RUNTIME_DIR="/root/lmcache_runtime"
LOG_DIR="$RUNTIME_DIR/logs"
mkdir -p "$LOG_DIR"

export PYTHONHASHSEED="${PYTHONHASHSEED:-0}"
export CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES:-0,1,2,3}"
export LMCACHE_MP_HYBRID_STATE_CACHE_MAX_ENTRIES="${LMCACHE_MP_HYBRID_STATE_CACHE_MAX_ENTRIES:-4096}"

/usr/bin/python3 -c 'from lmcache.cli.main import main; main()' server \
  --host 0.0.0.0 \
  --port 5555 \
  --http-host 0.0.0.0 \
  --http-port 8080 \
  --l1-size-gb 20 \
  --eviction-policy LRU \
  --chunk-size 2096 \
  --disable-observability \
  --disable-metrics \
  2>&1 | tee "$LOG_DIR/lmcache_qwen36_mp.log"
