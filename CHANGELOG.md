# Changelog

All notable changes to vm-tools are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

## [1.0.0] — 2026-06-11

### Added
- `install.sh`: one-shot bootstrap for Ubuntu/Debian, RHEL family, macOS
- `config.env`: user-customisable flags and version pins for all tools
- OS detection (Debian / RHEL / macOS) with appropriate package managers
- Per-tool `INSTALL_<TOOL>` flags with `--only` / `--skip` CLI overrides
- `--dry-run` mode: prints all actions without executing
- `--config <path>` to load a custom env file
- Tools: git, nvm/Node LTS, pnpm, uv, ruff, Docker Engine (Ubuntu) / Podman (RHEL/macOS), Go (SHA256-verified), opencode, starship
- `bash_prompt.sh`: minimal bash PS1 showing CWD basename + git branch in colour; installed to `~/.config/bash_prompt.sh` and sourced from shell RC; mutually exclusive with starship via `INSTALL_BASH_PROMPT` / `INSTALL_STARSHIP` flags
- Optional extras: ripgrep, fzf, direnv, jq, make, curl, wget, unzip, htop, tree
- Automatic shell RC detection and PATH patching (bash / zsh)
- `install.log` per-run append log
- Supply-chain hardening: GPG-authenticated repos, Go tarball SHA256 verification, version pinning, HTTPS-only downloads
- `README.md` with usage, customisation, and security notes
- `CHANGELOG.md`
- `.gitignore`
