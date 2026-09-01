# Contributing to Windk

Thanks for your interest in contributing to Windk! This project is under active development and has not yet reached its first official release, so expect things to move quickly and change often.

## Before You Start

Windk is a Windows Command Shell (`cmd.exe`) CLI built around a few core principles — please read the [README](./README.md) architecture overview before contributing so your changes fit the existing design:

- **Statelessness** — `windk.bat` and `config_manager.bat` hold no persistent internal state. Avoid introducing global mutable state where a JIT lookup would do.
- **Just-in-time config resolution** — configuration values are resolved on demand via `GET`, not bulk-loaded into the environment block. Keep the 32 KB Command Shell Environment Block limit in mind.
- **Separation of concerns** — routing (`windk.bat`), config I/O (`config_manager.bat`), and business logic (subcommands under `lib/`) are owned by distinct components. Keep new logic in the layer it belongs to.
- **Non-destructive mutation** — config writes (`SET`) must remain atomic and non-destructive.

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

## How to Contribute

1. **Fork the repository** and create a new branch for your change.
2. **Keep changes scoped** — one fix or feature per pull request makes review easier.
3. **Follow existing conventions** in the batch scripts (naming, section headers in `windk.cfg`, comment style).
4. **Test on `cmd.exe`** — changes should be verified in an actual Windows Command Shell environment, not just PowerShell or WSL, since behavior can differ.
5. **Update documentation** — if your change affects the CLI's behavior, config format, or architecture, update the README and add an entry to `CHANGELOG.md` under `[Unreleased]`.

## Adding a Subcommand

New subcommands should:
- Live under `lib/` as an independent, autonomous executable.
- Own their own local argument parsing and business logic.
- Not rely on shared mutable state from the router.
- Register any required flag/command sections in `windk.cfg`.

## Reporting Issues

When filing an issue, please include:
- The command or flag you ran
- Expected vs. actual behavior
- Your Windows/`cmd.exe` version, if relevant
- Any relevant contents of `windk.cfg` (redact anything sensitive)

## Pull Request Checklist

- [ ] Change is scoped and follows the stateless/JIT design philosophy
- [ ] Tested in `cmd.exe`
- [ ] README updated if architecture or usage changed
- [ ] `CHANGELOG.md` updated under `[Unreleased]`

## Code of Conduct

Be respectful and constructive. This is an early-stage project — questions, small fixes, and design feedback are all welcome. See [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md) for the full guidelines.
