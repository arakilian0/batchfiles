# windk - Windows Development Kit

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows%2010%2B-0078D6.svg)
![Release](https://img.shields.io/github/v/release/arakilian0/windk?label=version)

A collection of modular Windows CLI tools designed for simple, fast, and efficient terminal workflows. The toolkit requires no external dependencies beyond a standard Windows 10+ installation and is built entirely on native Windows functionality. Select tools can optionally integrate with third-party software already installed on your system.

## Install 

Copy/type in each command line by line.

```shell
mkdir windk && cd windk
curl -sSL "https://github.com/arakilian0/windk/archive/refs/heads/main.zip" -o repo.zip
tar -xf repo.zip --strip-components=1 && del repo.zip
setx PATH "%PATH%;%CD%\exe"
```

## Usage
```shell
windk create test
```

## TODO
- [x] windk create
- [x] windk delete
- [x] windk archive
- [x] windk unarchive
- [ ] windk install
- [ ] winkd uninstall
- [ ] windk update

