# Windk Core Engine (`/core`)

This directory contains shared, low-level framework engines and foundation utilities used across the suite.

---

## Core Architecture Principles

Files in this directory represent the foundation of the suite. Unlike domain tools in `/tools`, scripts in `/core` must adhere to strict stability and portability standards:

1. **Strict Statelessness & Encapsulation**
   * Core utilities must operate on parameters passed directly via arguments or explicit environment contexts.
   * Never store persistent state or declare un-scoped global environment variables that outlive execution (`setlocal` / `endlocal` boundaries must be strictly maintained).

2. **Zero Tool Dependencies**
   * Infrastructure in `/core` must remain **completely agnostic** of individual tools.
   * A core script must **never** call, import, or reference code inside `/tools` or `/bin`.

3. **High Reliability & Safeguards**
   * All core scripts must implement protective handling for Windows Batch edge cases (e.g., poison character escaping `!^&<>`, delayed expansion safety, and space-padded paths).
   * File I/O operations must be non-destructive (e.g., atomic operations via temporary swap files).

---

## Core Component Standards

When adding or modifying a core utility:

* **Naming Convention:** Use clear, descriptive names indicating utility purpose (e.g., `config_manager.bat`, `ansi_writer.bat`, `path_resolver.bat`).
* **Input Validation:** Validate all incoming `%1`, `%2` parameters immediately at script entry.
* **Exit Code Integrity:** Return standard `%ERRORLEVEL%` values (`0` for success, non-zero for specific failure conditions) to allow upstream launchers to respond cleanly.
