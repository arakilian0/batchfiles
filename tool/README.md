# Windk Tools Directory (`/tools`)

This directory contains the isolated implementations for all standalone tools, utilities, and CLI entry points in the suite.

---

## Micro-Package Architecture Rules

Because the utilities housed here are independent, **strict isolation must be maintained**:

1. **Self-Contained Isolation**
   * Every tool gets its own subfolder (e.g., `tools/c_nav/`, `tools/sysinfo/`).
   * A tool must **never** directly depend on or call scripts inside another tool's directory (e.g., `c_nav` must never call scripts in `sysinfo`).

2. **Launcher Proxy Pattern**
   * Code in `tools/<tool_name>/` should not be executed directly by end-users.
   * Every executable tool must expose a lightweight proxy runner inside the root `bin/` directory (e.g., `bin/c.bat`), which delegates execution to `tools/<tool_name>/main.bat %*`.

3. **Core Dependencies (`/core`)**
   * If your tool requires shared infrastructure—such as the JIT Configuration Engine (`config_manager.bat`) or ANSI color utilities—reference them relative to the top-level `/core` directory (`..\..\core\`).
   * Do not duplicate shared framework utilities inside individual tool folders.

---

## Creating a New Tool

To add a new utility to the suite:

1. Create a dedicated folder: `tools/<new_tool_name>/`
2. Define the main entry script: `tools/<new_tool_name>/main.bat`
3. Add any private helpers or local configuration files inside `tools/<new_tool_name>/`
4. Add a proxy launcher script to `bin/<new_tool_name>.bat`:
   ```cmd
   @echo off
   call "%~dp0..\tools\<new_tool_name>\main.bat" %*
