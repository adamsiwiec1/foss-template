# Packaging (install channels)

Ship your CLI/app through the package managers people already use. This folder
is **in-repo templates**; most channels also need a **separate org/user repo**
because Homebrew, Scoop, apt, and dnf do not install formulas from your app
repo directly.

Live OpenHat examples (production):
[homebrew-tap](https://github.com/openhat-security/homebrew-tap) ·
[scoop-bucket](https://github.com/openhat-security/scoop-bucket) ·
[packages](https://github.com/openhat-security/packages) (apt/dnf Pages)

Minimal **template examples** under this author (copy these when you start):
[adamsiwiec1/homebrew-tap](https://github.com/adamsiwiec1/homebrew-tap) ·
[adamsiwiec1/scoop-bucket](https://github.com/adamsiwiec1/scoop-bucket) ·
[adamsiwiec1/packages](https://github.com/adamsiwiec1/packages) ·
[adamsiwiec1/chocolatey-packages](https://github.com/adamsiwiec1/chocolatey-packages)

| Channel | User installs with | Lives in | Why a separate repo? |
| --- | --- | --- | --- |
| **GitHub Release** | `curl` install script / direct download | This project | Source of truth for binaries |
| **Homebrew** | `brew install --cask OWNER/tap/NAME` | `OWNER/homebrew-tap` | Homebrew only searches *taps* named `homebrew-tap` (or `homebrew-*`) |
| **Scoop** | `scoop bucket add …` then `scoop install` | `OWNER/scoop-bucket` | Scoop installs from *buckets*, not random app repos |
| **apt** | `apt install` after adding a source | `OWNER/packages` (GitHub Pages) | Needs a deb pool + `Packages` index on HTTP |
| **dnf** | `dnf install` after adding a `.repo` | same `OWNER/packages` | Needs RPM + `repodata` on HTTP |
| **AUR** | `yay -S name-bin` | AUR (`aur.archlinux.org`) | Arch community DB; keep a `PKGBUILD` copy here |
| **winget** | `winget install Publisher.Name` | PR to `microsoft/winget-pkgs` | Microsoft hosts the catalog |
| **Chocolatey** | `choco install name` | Community repo or your push feed | Nuspec + scripts; often a `chocolatey-packages` mirror |
| **npm** (optional) | `npm i -g name` | npmjs.org | Wrapper that downloads the Release binary |

## Layout in this template

```
packaging/
  README.md                 ← you are here
  homebrew/Casks/           ← Cask template → push to homebrew-tap
  scoop/bucket/             ← Scoop manifest → push to scoop-bucket
  repo/                     ← apt/dnf Pages builder + install scripts
  aur/                      ← PKGBUILD for AUR
  winget/                   ← notes + generator stub for winget-pkgs PRs
  chocolatey/               ← nuspec + install script templates
  npm/                      ← optional global wrapper notes
```

Replace every `INSERT_*` token (see root [SETUP.md](../SETUP.md)).

## Create the companion repos once

```bash
OWNER=INSERT_OWNER   # e.g. adamsiwiec1 or your-org

gh repo create "$OWNER/homebrew-tap" --public \
  --description "Homebrew tap for $OWNER CLIs" --add-readme
gh repo create "$OWNER/scoop-bucket" --public \
  --description "Scoop bucket for $OWNER CLIs" --add-readme
gh repo create "$OWNER/packages" --public \
  --description "apt + dnf repos ($OWNER) via GitHub Pages" --add-readme
gh repo create "$OWNER/chocolatey-packages" --public \
  --description "Chocolatey package sources for $OWNER" --add-readme

# packages: Settings → Pages → Deploy from branch gh-pages (or main) / root
```

Seed them from the examples:

```bash
# After creating empty repos, copy READMEs / .gitkeep layout from:
#   https://github.com/adamsiwiec1/homebrew-tap
#   https://github.com/adamsiwiec1/scoop-bucket
#   https://github.com/adamsiwiec1/packages
#   https://github.com/adamsiwiec1/chocolatey-packages
```

## Release wiring (secrets on the *app* repo)

| Secret | Used for |
| --- | --- |
| `PACKAGING_TOKEN` | PAT with **contents:write** on tap, scoop-bucket, and packages |
| `HOMEBREW_TAP_TOKEN` / `SCOOP_TOKEN` | Optional overrides |
| `WINGET_PAT` | Open PRs to `microsoft/winget-pkgs` |
| `CHOCO_API_KEY` | `choco push` to chocolatey.org (if you publish) |
| `NPM_TOKEN` | Optional npm wrapper publish |
| `GPG_PRIVATE_KEY` | Optional apt `InRelease` signing |

Without `PACKAGING_TOKEN`, you can still attach binaries to GitHub Releases; brew/scoop/apt updates just will not auto-push.

## Recommended flow

1. Cut a tagged GitHub Release with platform binaries (GoReleaser, cargo-dist, softprops/action-gh-release, …).
2. CI copies/updates:
   - Cask → `homebrew-tap`
   - Scoop JSON → `scoop-bucket`
   - `.deb`/`.rpm` → rebuild Pages tree in `packages`
3. Manually or via bot: bump AUR `PKGBUILD`, open winget PR, `choco push`.

See [docs/guide/packaging.md](../docs/guide/packaging.md) for the narrative version.
