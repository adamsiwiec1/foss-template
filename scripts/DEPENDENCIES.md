# Script dependencies

Tools required to run helper scripts in this repository.

| Tool | Used by | Install |
| --- | --- | --- |
| **[gh](https://cli.github.com/)** (GitHub CLI) | [`scripts/bootstrap-packaging.sh`](bootstrap-packaging.sh) — create / rename / archive repos from templates | `brew install gh` then `gh auth login` |
| **git** | Same script when seeding without `--template` | System package / Xcode CLT / Git for Windows |
| **Node ≥ 22** | VitePress docs (`npm run docs:*`) | See [`.nvmrc`](../.nvmrc) |

`gh` is **required** for packaging bootstrap. The script exits with install
hints if `gh` is missing or not authenticated (`gh auth status`).
