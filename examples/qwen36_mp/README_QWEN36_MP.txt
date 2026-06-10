Qwen3.6-35B-A3B-GPTQ-Int4 LMCache MP runtime

Reference host: validated on the Qwen3.6 LMCache MP runtime host
Model path: /mnt/waiwai/models/Qwen3.6-35B-A3B-GPTQ-Int4
Served model name: qwen3.6-35b-gptq-int4
vLLM port: 8001
LMCache ZMQ port: 5555
LMCache HTTP port: 8080

Start all:
  bash /root/lmcache_runtime/scripts/launch_qwen36_mp_all.sh

Stop all:
  bash /root/lmcache_runtime/scripts/stop_qwen36_mp.sh

LMCache only:
  bash /root/lmcache_runtime/scripts/start_lmcache_qwen36_mp.sh

vLLM only:
  bash /root/lmcache_runtime/scripts/start_vllm_qwen36_mp.sh

Important:
  - LMCacheMPConnector must run on the same host as vLLM.
  - Do not use nvfp4 KV cache on RTX 5090/SM120 with the current FlashInfer build.
  - This runtime uses fp8 KV cache and bfloat16 Mamba state.
  - The Qwen3.6 hybrid-state LMCache patch is in:
    lmcache/integration/vllm/lmcache_mp_connector.py
    lmcache/integration/vllm/vllm_multi_process_adapter.py
