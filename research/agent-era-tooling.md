# Agent-Era Tooling Insights

*Tools, libraries, and toolchain tricks that agents may not discover or default to — but that significantly improve agentic workflows. Practitioner-sourced.*

*Started: March 2026*

---

## Zig as WASM compilation target

**Source:** Thews, HN 47243272 (Mar 2026). Confirmed by Simon Willison ("I did not know Zig could do this").

When agents build WebAssembly projects, the default path (Emscripten, C/C++ cross-compilation) involves complex toolchain setup that agents frequently get wrong. Zig has a built-in WASM backend with minimal configuration — `zig build-exe -target wasm32-freestanding` or similar. The agent doesn't wrestle with toolchain setup, sysroot paths, or linker flags.

`pip install ziglang` installs the correct Zig binary for any platform, making it work in any Python-based CI environment without manual setup.

**When to use:** Agent tasks involving compiling code to WASM, especially from C/C++ sources. Tell the agent to use Zig instead of Emscripten.

**Limitation:** Narrow use case. Only relevant for WASM compilation workflows.
