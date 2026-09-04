> ⚠️ **Development Status: Rapidly Evolving (v0.1.0)**  
> `windk` is under active development. Syntax, directory structures, and core utility behavior are undergoing rapid iteration and may change between commits. Comprehensive documentation is currently **not a primary priority** while core features, internal dispatching, and framework utilities are actively being built and refined.

# windk — Windows Development Kit

**windk** is a lightweight, modular CLI framework written entirely in native Windows Command Scripting (`.bat`). It brings modern command-line architecture—such as isolated executable proxies, externalized INI configurations, subcommand routing, explicit alias redirects (`@:` syntax), path normalization, and VT100 ANSI terminal formatting—to Windows without requiring external runtimes like Node.js, Python, or PowerShell execution policy overrides.

---

## What `windk` Is (And What It Isn't)

**`windk` is built for everyday Windows users, scripters, and power users** who want to quickly build custom, modular command-line tools on the fly. 

If you know your way around `cmd.exe` and want to organize your custom automation scripts into a clean, single-command CLI tool without installing Python or fighting PowerShell's execution policies, `windk` is for you.

* **Target Audience:** Technical hobbyists, local automation scripters, and power users who want a simple, portable CLI kit that "just works."
* **Not Designed for Enterprise:** `windk` is **not** an enterprise application framework, nor is it intended for heavy corporate production infrastructure. It intentionally favors simplicity, transparency, and rapid script assembly over rigid corporate abstractions or heavy enterprise tooling.

---

## Why Native Batch?

Writing custom command-line utilities in native `cmd.exe` usually turns into a mess of monolithic, hard-to-read batch files with variable collisions and fragile string parsing. `windk` fixes this while preserving the single biggest advantage of Batch: **zero external dependencies**.

* **Zero Setup**: Runs natively on any stock Windows machine straight out of the box.
* **Instant Cold-Start**: No runtime boot times (unlike Node.js, Python, or heavy PowerShell startup times).
* **Clean Terminal Scope**: Uses `setlocal`/`endlocal` memory guards in the entry wrapper so custom script variables never pollute your open terminal window.
* **Native Path Normalization**: Automatically converts relative paths (`..\lib\...`) into clean, absolute Windows file paths.

---

## 1. High-Level Execution Flow

1. **Invocation & Entry Proxy**:
   * User invokes `windk` from the command line, resolving through the Windows `PATH` environment variable to `bin/windk.bat`.
   * **`bin/windk.bat`** establishes a `setlocal` boundary, captures raw CLI arguments via `%*`, and delegates execution down to the core engine dispatcher inside `tool/main.bat`.
2. **Environment & Subsystem Initialization**:
   * **`tool/main.bat`** receives the proxied call and initializes core framework utilities:
   * **`path_resolver.bat`** (Path Normalization Engine):
     * Converts relative paths into absolute Win32 target paths.
     * Normalizes trailing backslashes and resolves parent directory traversals (`..\`).
   * **`config_manager.bat`** (INI Parser & State Registry):
     * Iterates dynamically over `windk.cfg` section headers to register configuration keys into the framework's execution scope.
     * Evaluates `@:` alias pointers (e.g., `h=@:help`), resolving shortcut keys directly to their primary script target without duplicating target strings.
     * Uses the path resolver to expand relative script locations into fully qualified paths.
   * **`colors.bat`** (VT100 Terminal Styling Subsystem):
     * Generates fast VT100 ANSI escape sequences via internal `cmd.exe` prompt expansion.
     * Queries Windows version information (`ver` build numbers) to verify native virtual terminal processing support (Windows 10 Build 10586+).
     * Honors the industry-standard `NO_COLOR` environment variable, safely degrading to plain text when requested or unsupported.
3. **Argument Parsing & Routing**:
   * **Flag Intercept**: If a standalone flag (e.g., `-h`, `--help`) is detected before a positional argument, its mapped script (or resolved `@:` alias) executes immediately and terminates the pipeline.
   * **Subcommand Routing**: If a positional command (e.g., `windk create myapp`) is provided, `main.bat` locates the corresponding script handler, resolves any alias redirects, and forwards remaining flags and arguments down to the target executable batch script.
4. **Environment Block Cleanup**:
   * Upon completion, control returns to `bin/windk.bat`, which fires its `endlocal` boundary. This immediately purges all temporary runtime variables and aliases from memory, returning a clean shell state to the caller with the appropriate exit code (`ERRORLEVEL`).

## 2. Configuration Example (`windk.cfg`)

```ini
[general]
name=windk
version=0.1.0

[flag]
help=..\lib\__help\windk-help.bat
h=@:help

version=..\lib\__version\windk-version.bat
v=@:version

[command]
create=..\lib\commands\create.bat
c=@:create

delete=..\lib\commands\delete.bat
d=@:delete
```
