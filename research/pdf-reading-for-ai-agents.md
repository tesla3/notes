# PDF Reading for AI Agents: Approach Analysis

Source: Multi-source research synthesis — March 2026

---

## The Problem

An AI agent running in a terminal (no GUI, no browser) needs to read PDF files and extract their content as text/markdown for reasoning. The agent has access to `bash`, `uvx`/`pip`, and can invoke CLI tools or write short Python scripts. What's the best approach?

## The Three Strategies

There are fundamentally three approaches, each with distinct tradeoffs:

### Strategy 1: Rule-Based Text Extraction (PDF → Markdown)

Extract embedded text directly from the PDF's internal structure using libraries that parse the PDF format.

**Top tools (ranked by quality/usability for agents):**

| Tool | CLI? | Install | Strengths | Weaknesses |
|------|------|---------|-----------|------------|
| **markitdown** | ✅ `uvx markitdown file.pdf` | Zero-config | Multi-format (PDF, DOCX, PPTX, HTML, images), Microsoft-backed (82k+ ⭐), uses pdfminer.six internally | Mediocre on complex layouts, no OCR, table extraction is basic |
| **pymupdf4llm** | ❌ (library only) | `uvx --from pymupdf4llm python -c "..."` | Fast (C-backed MuPDF), good multi-column support, page-level chunking, image extraction | Requires Python one-liner or script, struggles with mathematical formulas |
| **pdfplumber** | ❌ (library) | pip | Best table extraction among rule-based tools, visual debugging | Slow, no OCR, destroys reading order on some layouts |
| **Docling** (IBM) | ✅ | pip/uvx | Most accurate open-source parser, deep-learning layout analysis, handles complex docs | Slowest of all — heavy model downloads, GPU helps |
| **Marker** | ✅ | pip | Good accuracy, image description via Gemini, academic docs | Slow, requires model downloads |

**Verdict:** For a CLI agent, **markitdown is the pragmatic default** — zero friction, good-enough for 80% of PDFs. pymupdf4llm is the upgrade path when you need better quality (especially multi-column, tables).

### Strategy 2: Vision/Multimodal LLM (PDF → Images → LLM)

Convert each PDF page to an image, send to a vision-capable LLM (GPT-4.1, Gemini, Claude), ask it to extract text/describe content.

**How it works:**
1. `pdf2image` or `mutool draw` renders pages to PNG
2. Base64-encode each page image
3. Send to multimodal LLM with extraction prompt

**Evidence from benchmarks:**
- **Berghaus et al. (2025)**: "Native image processing generally outperforms structured conversion approaches" for invoice processing across GPT-5, Gemini 2.5, and Gemma 3 families.
- **Gemini** is consistently cited as best-in-class for PDF vision parsing (especially multilingual, complex layouts).
- Mathematical formula benchmark (Dec 2025): Qwen3-VL (9.76), Gemini 3 Pro (9.75) vs. PyPDF (7.69), PyMuPDF4LLM (6.67) — massive gap on specialized content.

**Pros:** Handles scanned docs, images, charts, handwriting, complex layouts, formulas. No parser selection headache — one approach works for everything.

**Cons:** Expensive (tokens per page image are high), slow (API latency × pages), requires API access, can hallucinate characters (especially IBAN-like alphanumeric strings). Overkill for born-digital text PDFs.

### Strategy 3: Specialized OCR Models (Hybrid)

Purpose-built vision models that output structured text/markdown from document images.

| Tool | Score (formula bench) | Params | Runs on |
|------|----------------------|--------|---------|
| PaddleOCR-VL | 9.65 | 0.9B | CPU/GPU |
| PP-StructureV3 | 9.34 | <0.3B | CPU/GPU |
| MinerU 2.5 | 9.17 | 1.2B | CPU/GPU/API |
| olmOCR | 8.94 | 7B | GPU |
| Mistral OCR | 8.66 | API ($0.001/page) | API |

**Verdict:** Overkill for an agent's casual PDF reading. These shine in production document pipelines, not ad-hoc file inspection.

---

## Decision Framework for an AI Agent

```
Is the PDF scanned / image-based / has charts or formulas?
├── YES → Strategy 2: Render to images, send to vision LLM
│         (or Mistral OCR at $0.001/page if volume matters)
└── NO (born-digital, mostly text) →
    Is the PDF simple (text, basic formatting)?
    ├── YES → markitdown (zero-config CLI)
    └── NO (tables, multi-column, complex layout) →
        pymupdf4llm (better structure preservation)
```

## The Recommended Implementation for Pi Agent

### Tier 1: Default (covers 80%+ of cases)

```bash
uvx markitdown document.pdf
```

- Zero install, zero config
- Outputs clean markdown to stdout
- Handles PDF, DOCX, PPTX, HTML, images — one tool for everything
- Uses pdfminer.six under the hood for PDF text extraction

### Tier 2: Better quality for complex PDFs

```bash
uvx --from pymupdf4llm --with pymupdf python -c "
import pymupdf4llm
md = pymupdf4llm.to_markdown('document.pdf')
print(md)
"
```

- Better multi-column handling
- Better table detection
- Page-level chunking available (`page_chunks=True`)
- Can extract images (`write_images=True`)

### Tier 3: Scanned/image PDFs or visual content

Render pages to images and use the agent's own multimodal capabilities (if available), or describe via API.

This requires `poppler` (`brew install poppler` for `pdftotext`/`pdftoppm`) or `pymupdf` for rendering, then sending images to a vision model.

---

## Key Insights from the Research

1. **There is no "best" parser.** The Applied AI benchmark (800+ docs, 17 parsers) found a 55-point accuracy gap between easy domains (legal: 95%) and hard domains (academic: 40%). Domain matters more than tool choice.

2. **Don't trust single metrics.** Open-source parsers score 90+ on ChrF++ (character overlap) but only 70s on edit similarity (structural accuracy). A parser can extract the right characters while destroying reading order.

3. **Rule-based beats vision for born-digital PDFs.** PyMuPDF extracts actual text strings with formatting properties — no OCR uncertainty. 1.8M parameters on CPU vs. billions of parameters on GPU. Sub-second vs. seconds per page.

4. **Vision beats rule-based for everything else.** Scanned docs, handwritten notes, charts, formulas, complex mixed-media layouts — vision models have no close competitor among rule-based tools.

5. **The practical answer for an agent is a tiered approach.** Start with the fastest/cheapest tool. Escalate only when it fails. markitdown → pymupdf4llm → vision LLM. This mirrors how a human would approach it: try `cat` first, then open in a reader.

6. **markitdown is the Swiss Army knife.** Microsoft's 82k+ star tool handles 29+ file formats. For an agent that encounters diverse file types (not just PDF), having one tool that handles PDF, DOCX, PPTX, HTML, CSV, images, and audio is more valuable than a PDF-specific tool that's 10% more accurate.

7. **Docling is the accuracy champion but impractical for ad-hoc agent use.** Heavy model downloads, slow inference, GPU-preferring. Great for pipelines, wrong for "quick, read this PDF."

---

## Bottom Line

**For this pi agent: `uvx markitdown <file>` as the default tool, escalating to pymupdf4llm for complex layouts, and vision-model page rendering for scanned/visual PDFs.**

The install cost is zero (uvx handles it), the latency is sub-second for text PDFs, and markitdown's multi-format support means it works on far more than just PDFs. That's the right tradeoff for an interactive agent.
