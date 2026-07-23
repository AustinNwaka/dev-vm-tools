# Dev vm-tools

One-shot development VM bootstrap for **Ubuntu/Debian**, **RHEL family** (Fedora, CentOS Stream, Rocky, AlmaLinux), and **macOS**.

## Installed toolchain

| Category             | Tool                                                 | Purpose                                   | Install method                                |
| -------------------- | ---------------------------------------------------- | ----------------------------------------- | --------------------------------------------- |
| Core                 | **Git** (latest)                                     | Source control                            | apt-core PPA / dnf / brew                     |
| Core                 | **nvm** + **Node.js LTS**                            | JavaScript runtime + npm                  | nvm official script                           |
| Core                 | **pnpm**                                             | Fast Node package manager                 | get.pnpm.io                                   |
| Core                 | **uv**                                               | Python package & project manager          | astral.sh                                     |
| Core                 | **Go**                                               | Systems / cloud-native language           | go.dev (SHA256-verified)                      |
| Core                 | **jq**, **make**, **curl**, **wget**, **unzip**      | Standard dev utilities                    | system package manager                        |
| IaC / DevOps         | **Ansible**                                          | Infrastructure automation                 | `uv tool install ansible-core --with ansible` |
| IaC / DevOps         | **Terraform**                                        | Infrastructure provisioning               | HashiCorp official repo / Homebrew tap        |
| IaC / DevOps         | **Docker Engine** _(Ubuntu/Debian)_                  | Container runtime                         | Docker's official APT repo                    |
| IaC / DevOps         | **Podman** _(RHEL / macOS)_                          | Rootless container runtime                | dnf / brew                                    |
| Developer Experience | **ruff**                                             | Python linter + formatter                 | uv tool / astral.sh                           |
| Developer Experience | **opencode**                                         | AI coding assistant CLI                   | npm / pnpm global                             |
| Developer Experience | **Bash git prompt**                                  | CWD basename + git branch in PS1          | `bash_prompt.sh` (sourced into `~/.bashrc`)   |
| Developer Experience | **Starship**                                         | Cross-shell prompt (alternative to above) | starship.rs                                   |
| Developer Experience | **ripgrep**, **fzf**, **direnv**, **htop**, **tree** | CLI workflow tools                        | system package manager                        |

## Quick start

```bash
git clone https://github.com/AustinNwaka/dev-vm-tools.git
cd vm-tools
chmod +x install.sh

# Review/edit tool flags and versions first
cp config.env my.env      # optional: keep a custom copy outside git
vim config.env

./install.sh
```

After the script finishes, restart your shell (or `source ~/.bashrc`) to pick up all `$PATH` changes.

## Usage

```
./install.sh [OPTIONS]

OPTIONS
  --dry-run               Print what would run; make no changes
  --config <path>         Use a custom config file (default: ./config.env)
  --only <tool> [tool…]   Install only the listed tools
  --skip <tool> [tool…]   Skip the listed tools
  --no-docker             Shorthand for --skip docker
  --no-golang             Shorthand for --skip golang
  --no-node               Shorthand for --skip node
  --no-opencode           Shorthand for --skip opencode
  -h, --help              Show usage
```

### Examples

```bash
# Dry-run first — see what will happen
./install.sh --dry-run

# Install everything except Docker and opencode
./install.sh --skip docker opencode

# Install only uv and ruff on a CI worker
./install.sh --only uv ruff

# Install IaC / DevOps tools only
./install.sh --only ansible terraform

# Use a team-shared config
./install.sh --config /etc/vm-tools/team.env
```

## Customisation (`config.env`)

Edit `config.env` before running. Every tool has a `INSTALL_<TOOL>=true/false` flag.

```bash
# Disable tools you don't need
INSTALL_HTOP=false
INSTALL_STARSHIP=false   # set true to use starship instead of bash_prompt
INSTALL_BASH_PROMPT=false  # set false if using starship

# Pin specific versions
NODE_VERSION="lts/iron"   # or "22", "20", etc.
GO_VERSION="go1.23.4"     # full tag, e.g. go1.23.4
PNPM_VERSION="9.15.0"     # leave empty for latest
ANSIBLE_VERSION="2.18.3"  # leave empty for latest ansible-core
```

All flags and their defaults are documented in [`config.env`](config.env).

## Idempotency

Every installer function checks whether the tool is already present before installing. Re-running `install.sh` on an already-provisioned machine is safe and fast.

## Supply-chain hardening

| Concern                         | Mitigation                                                                                                                                                                             |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Tampered packages**           | All APT/dnf repos are authenticated with vendor GPG keys added before use                                                                                                              |
| **Malicious installer scripts** | All installer scripts are fetched over HTTPS from canonical vendor domains; Go tarball SHA256 is fetched separately and verified before extraction                                     |
| **Version pinning**             | `nvm` version is pinned in the script; Node/Go/pnpm can be pinned in `config.env`                                                                                                      |
| **Privilege escalation**        | `sudo` is only used where required (system-level installs); user-level tools (uv, pnpm, nvm) install into `$HOME`                                                                      |
| **No ambient authority**        | The script does not source arbitrary remote code without version pinning; the only exception is uv/ruff/starship whose install scripts are fetched from their respective owned domains |

## Log file

Every run appends to `install.log` (in the same directory). Check it for verbose output and errors:

```bash
tail -f install.log
```

## Container runtime notes

- **Ubuntu/Debian**: Docker Engine (not Docker Desktop) is installed from Docker's official APT repository. Your user is added to the `docker` group — log out and back in before running `docker` without `sudo`.
- **RHEL family**: Podman is used (native in dnf, rootless by default, daemonless). `podman-compose` is also installed.
- **macOS**: Podman via Homebrew. A Podman machine (VM) is initialised automatically. Run `podman machine start` before using containers.

## Adding new tools

1. Add an `INSTALL_<TOOL>` flag in `config.env`.
2. Write an `install_<tool>()` function in `install.sh` following the existing pattern.
3. Call the function in `main()`.

## Version

See [CHANGELOG.md](CHANGELOG.md) for release history.
