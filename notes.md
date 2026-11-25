# Development notes

## Week 1, day 1: local model feasibility (2026-11-25)

Hardware: RTX 4070 Laptop (8 GB VRAM), 16 GB RAM, Windows. Runtime: Ollama 0.40.18.

### Findings

- **Thinking mode must be disabled.** `qwen3.5:4b` generated ~4000 tokens (72 s) for a two-sentence answer with thinking on. With `think: false` the same request takes ~0.8 s (~65 tokens/s).
- **Structured output works.** With a JSON schema (`reply` + `action`), all four tested models returned 10/10 valid JSON. Validity is therefore not the differentiator; reply quality is.
- **Model comparison** (10 runs each, temperature 0.9, one scenario):

| Model | Avg time | Tokens/s | Main issue |
|---|---|---|---|
| qwen3.5:4b | 0.8 s | 57 | a few odd sentences |
| qwen3:4b | 1.3 s | 63 | reasoning leaks into the reply |
| gemma3:4b | 0.8 s | 66 | truncated replies, formal "vous" |
| llama3.2:3b | 0.6 s | 86 | weak French |

- **Temperature:** 0.9 produces nonsense and long replies; 0.5 repeats itself; **0.7 is the best trade-off**.
- **Prompt rules vs personality:** a strict prompt with action rules made the model follow the rules better but flattened the character (almost every reply started with "Bienvenue, mon ami"). A small model cannot hold a rich persona and fine-grained action rules at once.
- **Action choice is unreliable when left to the model:** it ignored game context (number of previous talks, gold, time of day).

### Decisions

- Model: `qwen3.5:4b`, temperature 0.7, thinking disabled.
- Prompt: personality only, no action rules.
- **The game code decides the action** (from game state and rarity probabilities); the model only writes the line matching that action.
- Keep the LLM behind a backend interface (`IPNJBackend`) so the model or runtime can change.
- Include a non-AI fallback if the model fails or is too slow.

### Open questions

- VRAM available for the game: `qwen3.5:4b` takes ~3.1 GB; ~1.9 GB were already used by the system before loading it, leaving ~3 GB for Unreal. To measure with the editor open (week 2).
- Ollama unloads the model after ~5 minutes of inactivity; set `keep_alive` in the real integration.
- Embedded plugin (llama.cpp) vs local Ollama server for the final build.
- Only one scenario was tested; contextual coherence needs several game situations.

### Raw results

- `bench-results.md`: model comparison
- `bench-tuned-results.md`: prompt and temperature comparison
- `tools/bench.ps1`, `tools/bench-tuned.ps1`: scripts used

## Next (day 2)

HTTP call from UE5 (C++, asynchronous) to the local Ollama server; display the reply on screen without freezing the game.
