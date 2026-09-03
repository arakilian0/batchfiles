# Windk

Windk is a Windows Development kit. A lightweight, memory-efficient, and modular CLI runner architecture built for Windows Batch (cmd.exe).

## Overview

Traditional Batch-based orchestration tools typically pre-parse or bulk-load configuration files (`.cfg`/`.ini`) into environment memory upon startup. In complex enterprise CLI environments, this quickly exceeds the native **32 KB Command Shell Environment Block limit**, causing buffer overflows, environment pollution, and unstable parameter evaluation.

Windk resolves these platform constraints by strictly decoupling execution orchestration into a composable set of modular components, resolving configuration values on demand rather than loading them all into memory up front.

## Architecture

### 1. Entry Proxy Layer (`bin/`)
Thin, stateless invocation shims exposed on PATH. Each script performs a single unconditional forward of the full argument vector to the router — it sets no variables, performs no branching, and invokes no process other than the router itself.
```bat
@echo off
call "%~dp0..\tools\windk\cli.bat" %*
```

### 2. Stateless Router (`tools/windk/cli.bat`)
A lightweight parameter categorization and dispatch gateway. It maintains zero internal state tables and forwards parameter scope directly to target subcommands.

### 3. Atomic Utility Engine (`core/config_manager.bat`)
Encapsulates configuration I/O into isolated, stateless execution contexts. It performs:
- Line-buffered JIT key resolution (`GET`)
- Non-destructive atomic mutations (`SET`)

### 4. Autonomous Subcommands
Independent executables hosted under `tools/toolname` that own their respective domain business logic and local argument parsing.

## Request Lifecycle

```text
[ CLI Execution Context: windk <flags|command> [args...] ]
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│ STEP 1: Main Script Boundary Initialization            │
│ - Validate config_manager.bat & windk.cfg paths        │
│ - Initialize target dispatch tracking variables        │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│ STEP 2: Argument Tokenization & Categorization Loop    │
│ - Tokenize input stream via SHIFT loop                 │
│ - Parse token prefixes (-, /, or positional literal)   │
└─────────────┬────────────────────────────┬─────────────┘
              │                            │
      (Flag Token)                (Positional Command)
              │                            │
              ▼                            ▼
┌────────────────────────────┐ ┌────────────────────────────┐
│ STEP 2A: Flag Dispatch     │ │ STEP 2B: Subcommand Lookup │
│ - Strip prefix delimiters  │ │ - Issue JIT GET to         │
│ - Issue JIT GET to         │ │   config_manager.bat       │
│   config_manager.bat       │ │ - Section: [command]       │
│ - Section: [flag]          │ │ - Return target path or    │
│ - Execute flag target or   │ │   append to argument       │
│   collect passthrough flag │ │   forwarding array         │
└─────────────┬──────────────┘ └───────────┬────────────────┘
              │                            │
              └─────────────┬──────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│ STEP 3: Config Manager JIT Processing                  │
│ - Line-by-line stream processing via FOR /F            │
│ - Recursive @: alias pointer resolution (Max depth: 3) │
│ - Relative-to-absolute path expansion (.\ or ..\)      │
│ - Isolated cross-scope handshake via SETVAR            │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│ STEP 4: Target Verification & Subcommand Execution     │
│ - Assert TARGET_CMD presence on disk                   │
│ - Pass-through STATELESS_FLAGS and CMD_ARGS            │
│ - Delegate execution via CALL and pass child exit code │
└────────────────────────────────────────────────────────┘
```

## Design Philosophy

- **No bulk config loading** — configuration values are resolved just-in-time, per key, rather than loaded wholesale into the environment block.
- **Statelessness by default** — the router and config engine hold no persistent internal state, minimizing environment pollution and making behavior predictable across invocations.
- **Separation of concerns** — routing, configuration I/O, and business logic are owned by distinct components, each independently testable and replaceable.
- **Isolation of mutation** — configuration writes (`SET`) are atomic and non-destructive, reducing the risk of partial or corrupted config state.

## Project Structure

```text
exe/
├── windk.bat                 # Stateless router / dispatch gateway
├── config/
│   └── windk.cfg              # Configuration file (sections per flag/command)
├── help/
│   └── windk-help.bat          # Main runner help script
├── util/
│   └── config_manager.bat      # Atomic JIT config I/O engine (GET / SET)
└── lib/
    └── ...                      # Autonomous subcommand executables
```

## How It Works

1. `windk.bat` tokenizes the incoming CLI arguments and categorizes each token as either a **flag** (`-`/`/` prefixed) or a **positional command**.
2. For flags, the router issues a JIT `GET` against `config_manager.bat` under the `[flag]` section to resolve the flag's target or behavior.
3. For positional commands, the router issues a JIT `GET` under the `[command]` section to resolve the subcommand's target path, or appends the token to the argument-forwarding array.
4. `config_manager.bat` resolves the requested key via line-by-line stream processing, recursively resolving `@:` alias pointers (up to a depth of 3) and expanding relative paths (`.\` or `..\`) to absolute paths.
5. Once resolved, `windk.bat` verifies the target subcommand exists on disk, then delegates execution via `CALL`, forwarding any stateless flags and command arguments, and propagates the child process's exit code back to the caller.

## Requirements

- Windows Command Shell (`cmd.exe`)

## Usage

```cmd
windk <flags|command> [args...]
```

## License

MIT License

Copyright (c) Michael Arakilian and affiliates.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

