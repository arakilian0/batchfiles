# WinDK — Windows Development Kit

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows%2010%2B-0078D6.svg)
![Release](https://img.shields.io/github/v/release/arakilian0/windk?label=version)

A collection of modular Windows CLI tools designed for simple, fast, and efficient terminal workflows. The toolkit requires no external dependencies beyond a standard Windows 10+ installation and is built entirely on native Windows functionality. Select tools can optionally integrate with third-party software already installed on your system.

## 📑 Table of Contents

* [📋 System Requirements](#-system-requirements)
* [💻 Installation & Setup](#-installation--setup)
* [🚀 Quick Start](#-quick-start)
* [🗂️ Project Structure](#️-project-structure)
* [🛠️ Included Utilities](#️-included-utilities)
* [❓ Troubleshooting / FAQ](#-troubleshooting--faq)
* [🗑️ Uninstalling](#️-uninstalling)
* [🧭 Roadmap](#-roadmap)
* [🤝 Contributing](#-contributing)
* [📝 Changelog](#-changelog)
* [📄 License](#-license)

## 📋 System Requirements

* **Operating System:** Windows 10 or higher (Windows 10, Windows 11, Windows Server 2019+)
* **Shell Environment:** Command Prompt (`cmd.exe`) or Windows Terminal
* **Built-in Dependencies:** 
  * Native ANSI Escape Sequence support (enabled by default in Windows 10 build 1511+)
  * Built-in `curl` utility (available natively in Windows 10 build 17063+ for file downloads)
  * Built-in `tar` utility (available natively in Windows 10 build 17063+ for archive extraction)

## 💻 Installation & Setup

Choose one of the installation methods below to set up the development kit in your current working directory.

<details>
<summary><strong>Method 1: Git Clone (Recommended)</strong></summary>

Using Git is the recommended approach as it allows you to easily update all scripts and helper tools to the latest version with a single `git pull`.

1. **Clone the Repository into Current Directory.**
   ```cmd
   git clone https://github.com/arakilian0/windk.git windk
   ```

2. **Add the src/ Folder to Windows User `PATH`.**
   ```cmd
   setx PATH "%PATH%;%CD%\windk\src"
   ```

   > **Note:** Open a **new** Command Prompt window after modifying your `PATH` variable for changes to take effect. Verify the installation by running `where c` and `c -h`.

3. **Updating in the Future.**
   ```cmd
   cd windk && git pull
   ```

</details>

<details>
<summary><strong>Method 2: Download via <code>curl</code></strong></summary>

If you do not use Git, you can download and extract the entire repository zip directly into your current directory.

1. **Create Target Directory & Download Repository Zip.**
   ```cmd
   mkdir windk && cd windk
   curl -sSL "https://github.com/arakilian0/windk/archive/refs/heads/main.zip" -o repo.zip
   ```

2. **Extract Contents.**
   ```cmd
   tar -xf repo.zip --strip-components=1 && del repo.zip
   ```

3. **Add the src/ Folder to Windows User PATH.**
   ```cmd
   setx PATH "%PATH%;%CD%\bin"
   ```

   > **Note:** Open a **new** Command Prompt window after modifying your `PATH` variable for changes to take effect. Verify the installation by running `where c` and `c -h`.
   
4. **Updating in the Future.**
   ```cmd
   cd windk
   curl -sSL "https://github.com/arakilian0/windk/archive/refs/heads/main.zip" -o repo.zip
   tar -xf repo.zip --strip-components=1 && del repo.zip
   ```
   This overwrites existing files with the latest versions. Any custom changes you've made to the scripts will be overwritten — back them up first if needed.

</details>

## 🚀 Quick Start

Once installed and available on your `PATH`, `c` — in action from a fresh Command Prompt window. For a complete list of available scripts, see [🛠️ Included Utilities](#️-included-utilities) below.

```text
C:\Users\you> c 2
C:\> c Projects/windk/src
C:\Projects\windk\src> c ..
C:\Projects\windk> c -t
```

Running `c` with no arguments simply clears your screen, so it doubles as a faster `cls`.

## 🗂️ Project Structure

```text
windk/
├── src/
│   └── c.bat            # Navigation & terminal management
└── lib/
    ├── colors.bat        # ANSI color palette
    ├── editor.bat        # Detects VS Code / falls back to Notepad
    └── help/
        └── c.bat         # Help screen invoked by src/c.bat -h
```

Future utilities follow the same `src/<tool>.bat` + `lib/help/<tool>.bat` pattern.

## 🛠️ Included Utilities

<!-- Parent Dropdown - lib -->
<details>
<summary><strong>📁 <code>lib/</code> — Core Modules</strong></summary>

  ### colors — ANSI Color Palette Library

  - **Native ANSI Escape Extraction:** Generates standard ANSI escape code characters (`ESC`) dynamically using a native Command Prompt fallback loop without requiring external binaries.
  - **Standard Color Definitions:** Pre-defines standard text foreground variables (`%RED%`, `%GREEN%`, `%YELLOW%`, `%BLUE%`, `%MAGENTA%`, `%CYAN%`, `%WHITE%`, `%GRAY%`).
  - **Text Formatting Styles:** Includes text decoration modifiers (`%BOLD%`, `%DIM%`, `%REGULAR%`, `%RESET%`).
  - **Zero-Dependency Support:** Easily imported into any suite module using `CALL "%~dp0colors.bat"` to maintain consistent output branding.

  ### editor — Dynamic Text Editor Launcher

  - **VS Code Detection:** Checks system `%PATH%` using `WHERE code` to detect if Visual Studio Code is installed.
  - **Automatic Fallback:** Gracefully falls back to opening the target file in native Windows Notepad (`notepad.exe`) if VS Code is not detected.
  - **Modular Invocation:** Receives the target script path directly from parent executables via `%SCRIPT_PATH%`.

  ### help/* — Standalone Help Modules

  - **Isolated Documentation Logic:** Houses menu formatting and CLI user guides separate from main executable workflows, keeping entry scripts light and performant.
  - **ANSI Color Integration:** Imports `lib/colors.bat` to deliver styled, scannable command-line interfaces.
  - **Dynamic Module Mapping:** Main scripts invoke matching help screens via `%SCRIPT_FILE%` (e.g., `root/src/c.bat` calls `root/lib/help/c.bat`).

</details>

<!-- Parent Dropdown - c -->
<details>
<summary><strong>📁 <code>c</code> — Navigation & Terminal Management</strong></summary>

### Usage: c <target | option>

| Flag / Parameter | Action | Example |
| :--- | :--- | :--- |
| *(no args)* | Clears the terminal screen (`cls`). | `c` |
| `<directory>` | Navigates into the specified target folder. | `c src` or `c C:\Projects` |
| `<number>` | Navigates up N parent directory levels. | `c 2` |
| `-e`, `--edit` | Opens the main script inside your default editor. | `c -e` |
| `-t`, `--tab` | Closes the active terminal tab/window. | `c -t` |
| `-a`, `--all` | Forces termination of all running `cmd.exe` sessions. | `c -a` |
| `-h`, `--help` | Displays the formatted color help menu. | `c -h` |

</details>

## ❓ Troubleshooting / FAQ

<details>
<summary><strong><code>c</code> isn't recognized as a command after installing.</strong></summary>
Your <code>PATH</code> changes only apply to <i>new</i> terminal sessions. Close and reopen Command Prompt or Windows Terminal, then confirm with <code>where c</code>.
</details>

<details>
<summary><strong><code>setx</code> succeeded but the tool still isn't found.</strong></summary>
<code>setx</code> has a 1024-character limit on the <code>PATH</code> value. If your existing <code>PATH</code> is already long, the appended entry may get silently truncated — edit your environment variables via <i>System Properties → Environment Variables</i> instead.
</details>

<details>
<summary><strong>Colors aren't rendering — I just see raw escape codes like <code>[31m</code>.</strong></summary>
Your terminal needs ANSI support enabled. This is on by default in Windows 10 build 1511+, but older <code>cmd.exe</code> sessions or some legacy terminal emulators may need it enabled manually via the registry (<code>VirtualTerminalLevel</code>) or by switching to Windows Terminal.
</details>

<details>
<summary><strong><code>c -e</code> opens Notepad instead of VS Code.</strong></summary>
<code>lib/editor.bat</code> detects VS Code with <code>WHERE code</code>, which relies on the <code>code</code> command being on your <code>PATH</code>. Open VS Code, run <b>Shell Command: Install <code>code</code> command in PATH</b> from the Command Palette, then restart your terminal.
</details>

<details>
<summary><strong><code>git pull</code> fails with local changes.</strong></summary>
If you've modified any scripts directly, <code>git pull</code> may refuse to overwrite them. Stash or discard local changes first: <code>git stash</code> or <code>git checkout .</code>
</details>

## 🗑️ Uninstalling

1. **Remove the `src` folder from your Windows User PATH:**
   - Open *System Properties → Environment Variables*, select your user `PATH` variable, and delete the entry pointing to `...\windk\src`.

2. **Delete the repository folder:**
   ```cmd
   rmdir /s /q windk
   ```

3. **Open a new terminal window** to confirm `c` is no longer recognized.

## 🧭 Roadmap

Planned additions to the toolkit — contributions and suggestions welcome:

- [ ] Additional `src/` utilities
   - Git manager
   - Core utils (cp, mk, etc)
   - Other app managers
- [ ] Self update flag (`c --update | windk --update`)
- [ ] Config file support for user-defined aliases and shortcuts

## 🤝 Contributing

Contributions are welcome! To propose a change:

1. Open an issue describing the bug or feature before submitting a large PR.
2. Fork the repo and create a feature branch.
3. Follow the existing pattern for new utilities: a `src/<tool>.bat` entry point paired with a `lib/help/<tool>.bat` help screen, using `lib/colors.bat` for styled output.
4. Submit a pull request with a clear description of the change.

## 📝 Changelog

See the [GitHub Releases page](https://github.com/arakilian0/windk/releases) for version history and release notes.

## 📄 License

This project is licensed under the [MIT License](LICENSE) — see below for details:

```text
MIT License

Copyright (c) 2019-2026 Michael Arakilian.

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
```