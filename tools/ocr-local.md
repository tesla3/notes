# Local OCR on macOS — Research Notes

> Researched: 2026-05-15

## TL;DR

- **For agent/CLI use**: `auge` — Swift CLI wrapping Apple Vision framework, pipe-friendly, JSON output, zero dependencies.
- **For best accuracy (local model)**: `GLM-OCR` (0.9B) — #1 on OmniDocBench v1.5 (94.6), runs via Ollama in ~2.5GB RAM.
- **Already on your Mac**: Apple Vision Framework — fast, free, surprisingly good, accessible via `auge` or `ocrmac`.

---

## 1. Apple Vision Framework (Built-in)

The macOS Vision framework (`VNRecognizeTextRequest`) is the same engine behind Live Text (copy text from images). It runs on the Neural Engine, is instant (~200ms), and rivals cloud OCR services.

Since macOS Sonoma, the **LiveText** backend is stronger than the older VisionKit OCR.

### CLI Tools (wrappers around Vision framework)

#### auge ⭐ (Best for CLI/agent use)

- **Repo**: <https://github.com/Arthur-Ficial/auge>
- **Install**: `brew tap Arthur-Ficial/tap && brew install Arthur-Ficial/tap/auge`
- **Language**: Swift 6.3, no Xcode required
- **macOS**: 10.15+ (classification needs 12+)

**Why it's optimal for agents:**

| Feature | Command |
|---------|---------|
| Basic OCR | `auge --ocr file.png` |
| JSON output | `auge --ocr file.png -o json \| jq -r .results.text` |
| Stdin pipe | `cat image.png \| auge --ocr` |
| Clipboard | `auge --ocr --clipboard` |
| PDF support | `auge --ocr scan.pdf` |
| Multi-language | `--langs en-US,zh-Hans` |
| Upscale small text | `--enhance` |
| AI post-processing | `--clean` (macOS 26+ — uses FoundationModels to fix OCR errors) |
| Multiple formats | `-o plain`, `-o json`, `-o md`, `-o ndjson` |
| Batch via stdin | `find . -name "*.png" \| auge --ocr` |

Exit code 0 even when no text found (agent-friendly). Supports PNG, JPEG, TIFF, BMP, GIF, HEIC, PDF.

Built-in demos: `demo/screenshot`, `demo/clipboard-ocr`, `demo/receipt`, `demo/monitor`.

#### ocrmac (Python)

- **Repo**: <https://github.com/straussmaximilian/ocrmac>
- **Install**: `pip install ocrmac`
- **Backends**: `vision` (default) or `livetext` (stronger, since Sonoma)
- **Speed**: ~207ms accurate, ~131ms fast, ~174ms livetext (M3 Max)

```python
from ocrmac import ocrmac
# Basic
annotations = ocrmac.OCR('test.png').recognize()
# LiveText (stronger)
annotations = ocrmac.OCR('test.png', framework="livetext").recognize()
# Returns: [(text, confidence, bounding_box), ...]
```

Requires `pyobjc-framework-Vision`. Does NOT work with `uv tool install` — use `pipx` or regular `pip`.

#### apple-vision-utils (Python CLI)

- **Repo**: <https://github.com/tddschn/apple-vision-utils>
- **Install**: `pipx install apple-vision-utils`
- **CLI**: `apple-ocr image.png -j -l eng`
- Supports PDF (`-p`), JSON output (`-j`), text clipping markers.

#### Other Swift CLIs

| Tool | Repo | Notes |
|------|------|-------|
| `ocrit` | <https://github.com/insidegui/ocrit> | Simple, stdout default, multi-language |
| `swiftocr` | <https://github.com/fny/swiftocr> | JSON w/ bounding boxes, stdin pipe support |
| `macos-vision-ocr` | <https://github.com/bytefer/macos-vision-ocr> | JSON, batch, positional info |

#### macOS Shortcuts (zero-install)

Create a shortcut with "Extract Text from Image" action, then:
```bash
shortcuts run "OCR Image Text" -i image.jpg --output-type public.utf8-plain-text -o -
```

#### Swift one-liner (zero-install, macOS 26+)

```swift
#!/usr/bin/env swift
import Foundation; import Vision
if CommandLine.arguments.count != 2 { fputs("usage: ocr <image>\n", stderr); exit(2) }
let url = URL(fileURLWithPath: CommandLine.arguments[1])
var req = RecognizeTextRequest()
req.recognitionLevel = .accurate; req.automaticallyDetectsLanguage = true
guard let obs = try? await req.perform(on: url) else { exit(1) }
for o in obs { if let c = o.topCandidates(1).first { print(c.string) } }
```

---

## 2. AI OCR Models (Local, for when Vision framework isn't enough)

For complex documents (tables, formulas, handwriting, seals, structured extraction), dedicated OCR models significantly outperform Vision framework.

### Model Comparison (fits M5 MacBook Air)

| Model | Params | RAM | OmniDocBench | MLX? | Ollama? | Best For |
|-------|--------|-----|-------------|------|---------|----------|
| **GLM-OCR** ⭐ | 0.9B | ~2.5GB | **94.6** (#1) | — | ✅ `glm-ocr` | Best overall, EN+CN |
| Granite-Docling-258M | 258M | <1GB | N/A | ✅ native | — | Ultra-light, math/code/tables |
| MinerU 2.5 | 1.2B | ~3GB | SOTA | ✅ | — | Complex layouts, selection marks |
| dots.ocr | 1.7B | ~4GB | 88.4 | Partial | — | High throughput (VLLM) |
| GOT-OCR2.0 | 700M | ~2GB | N/A | ❌ | — | General OCR |
| Qwen3-VL-4B | 4B | ~5GB (4-bit) | SOTA class | ✅ | ✅ | Multilingual, flexible prompting |
| olmOCR-2-7B | 7B | ~5-8GB (quantized) | 82.4 | ✅ (6/8-bit) | — | English digitized print docs |
| DeepSeek-OCR | 3B | ~4GB | 75.4 | ✅ | — | Flaky per community reports |
| Nanonets-OCR2-3B | 3B | ~4GB | — | ✅ | — | General |

### GLM-OCR Details

- **Paper**: <https://arxiv.org/html/2603.10910>
- **Ollama**: `ollama pull glm-ocr` (~2.2GB download)
- **IMPORTANT**: Set `num_ctx: 16384` or it crashes on images
- Beats all open models on: document parsing, text recognition, formula recognition, table parsing, key info extraction, seal recognition, handwriting
- Competitive with Gemini-3-Pro and GPT-5.2

```bash
# Quick start
brew install ollama && brew services start ollama
ollama pull glm-ocr

# API usage (set num_ctx!)
curl http://localhost:11434/api/generate \
  -d '{"model":"glm-ocr","prompt":"OCR this image","images":["<base64>"],"options":{"num_ctx":16384}}'
```

### OmniDocBench v1.5 Benchmark (March 2025)

| Model | Score | Notes |
|-------|-------|-------|
| GLM-OCR | **94.6** | #1, 0.9B params |
| PaddleOCR-VL-1.5 | 94.5 | 0.9B, 109 languages |
| Deepseek-OCR2 | 91.1 | 3B |
| MinerU 2.5 | 90.7 | 1.2B |
| Gemini-3-Pro | 90.3 | Cloud, reference |
| dots.ocr | 88.4 | 1.7B |
| GPT-5.2 | 85.4 | Cloud, reference |

### Real-world Custom Benchmarks (GLM-OCR paper)

| Task | GLM-OCR | Next Best Open | Gemini-3-Pro |
|------|---------|----------------|--------------|
| Code Document | 84.7 | 82.9 (MinerU) | 86.9 |
| Real-world Table | 91.5 | 86.1 (Paddle) | 90.6 |
| Handwritten Text | 87.0 | 87.4 (Paddle) | 90.0 |
| Multilingual Text | 69.3 | 65.1 (dots) | 86.2 |
| Seal Recognition | **90.5** | 63.0 (dots) | 91.3 |
| Receipt KIE | 94.5 | — | 97.3 |

---

## 3. Decision Guide

```
Need OCR?
├─ Clean printed text, screenshots, quick extraction?
│  └─ Use Apple Vision via `auge` — instant, free, good enough
├─ Complex documents (tables, formulas, handwriting)?
│  └─ GLM-OCR via Ollama — #1 accuracy, tiny model
├─ Multilingual (beyond EN+CN)?
│  ├─ Few languages: Qwen3-VL-4B (MLX)
│  └─ Many languages: PaddleOCR-VL (109 languages)
├─ Bulk PDF processing?
│  └─ olmOCR-2-7B (MLX quantized) — designed for digitized print
└─ Ultra-lightweight / edge?
   └─ Granite-Docling-258M (MLX native, <1GB)
```

---

## 4. MCP / Agent Integration Options

| Tool | Protocol | Notes |
|------|----------|-------|
| `auge` | CLI (stdin/stdout) | Best for shell-based agents |
| `ocrtool-mcp` | MCP (JSON-RPC over stdin) | <https://github.com/ihugang/ocrtool-mcp> |
| `darwinkit` | JSON-RPC over stdio | Vision + NLP, <https://github.com/0xMassi/darwinkit> |

---

## 5. Inference Servers for Apple Silicon

If running AI OCR models locally:

| Server | Notes |
|--------|-------|
| **oMLX** | Best for Apple Silicon — SSD KV cache, MLX native, 85% faster than Ollama |
| Ollama (w/ MLX) | Convenient but ~30% slower than llama.cpp |
| LM Studio | GUI, easy model download |
| mlx-vlm | Python, direct MLX for vision models |

---

## Sources

- GLM-OCR paper: <https://arxiv.org/html/2603.10910>
- OmniDocs roadmap: <https://adithya-s-k.github.io/Omnidocs/ROADMAP/>
- E-ARMOR benchmark: <https://arxiv.org/html/2509.03615v1>
- r/LocalLLaMA OCR discussions (2024-2026)
- HN: "How to do OCR on a Mac using CLI or Python" (2024)
