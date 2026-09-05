# Windk Security Policy

## Supported Versions

Windk is currently under active development and has not yet reached its first official release. Security fixes are not supported for any pre-release code — support begins with the first official release.

| Version              | Supported |
| -------------------- | --------- |
| `main` (unreleased)  | ❌        |
| Pre-release builds   | ❌        |

This table will be updated once official versioned releases begin.

## Reporting a Vulnerability

If you discover a security vulnerability in Windk, please open an issue in this repository.

Please include:
- A description of the vulnerability and its potential impact
- Steps to reproduce, including any relevant `.cfg` contents (redacted of anything sensitive) or command invocations
- The environment it was found in (Windows version, `cmd.exe` version)
- Any suggested remediation, if known

## Response Process

- We aim to acknowledge new reports within a few business days.
- We'll work with you to understand and validate the issue.
- A fix will be prioritized based on severity, and credit will be given to the reporter (unless anonymity is requested) once a fix is released.

## Scope & Known Considerations

Windk executes as `cmd.exe` batch scripts and resolves configuration and subcommand targets dynamically at runtime. Areas of particular security interest include:

- **Config injection** — malformed or malicious entries in `.cfg/.ini` (e.g. crafted `@:` alias pointers or path values) that could cause unintended path resolution or command execution.
- **Path traversal** — relative path expansion (`.\`, `..\`) resolving outside intended directories.
- **Subcommand trust** — `lib/` executables are invoked via `CALL` with forwarded arguments; care should be taken that argument forwarding doesn't allow unintended flag/argument injection into subcommands.
- **Environment variable pollution** — cross-scope handshakes (`SETVAR`) between the router and config engine should not leak or overwrite unrelated environment state.

If your report touches on any of the above, please flag it explicitly — it helps us triage faster.

Thank you for helping keep Windk and its users secure.
