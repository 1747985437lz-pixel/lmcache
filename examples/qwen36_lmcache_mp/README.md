# Qwen3.6 LMCache MP vLLM runtime

This branch records the vLLM side used with the Qwen3.6 LMCache MP runtime.

Validated runtime version:

```text
vLLM 0.21.1rc1.dev111+ga78b842d0
base commit a78b842d0e85d287176031334f4721cd96b6e47d
```

The Qwen3.6/LMCache external-hit changes relative to the base commit are in:

```text
vllm/v1/core/sched/scheduler.py
vllm/distributed/kv_transfer/kv_connector/v1/lmcache_connector.py
vllm/distributed/kv_transfer/kv_connector/v1/lmcache_mp_connector.py
```

The matching LMCache source is kept in the `main` branch of
`1747985437lz-pixel/lmcache`.
