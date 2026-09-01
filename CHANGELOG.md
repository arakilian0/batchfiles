> **Note:** This project is currently under active development and has not yet reached its first official release.

# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- `windk.bat` stateless router for parameter categorization and subcommand dispatch
- `config_manager.bat` atomic JIT configuration engine with `GET` (line-buffered key resolution) and `SET` (non-destructive mutation) operations
- `@:` alias pointer resolution in configuration lookups (max recursion depth: 3)
- Relative-to-absolute path expansion (`.\` and `..\`) in config resolution
- `windk.cfg` configuration file with per-flag and per-command sections
- `windk-help.bat` runner help script
- Support for autonomous subcommands under `lib/`
- Project documentation (README, architecture overview)

### Changed
- Ongoing development and refinement of the JIT config resolution flow

### Fixed
- Development-stage bugs and edge cases
