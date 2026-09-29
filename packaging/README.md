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

All four example companions are **GitHub template repositories** under
[`adamsiwiec1`](https://github.com/adamsiwiec1?tab=repositories&q=template):
`homebrew-tap`, `scoop-bucket`, `packages`, `chocolatey-packages`.

**One command** (from a clone of foss-template):

```bash
./scripts/bootstrap-packaging.sh --owner YOUR_GITHUB_USER_OR_ORG --yes
# dry-run first:
./scripts/bootstrap-packaging.sh --owner YOUR_ORG --dry-run
```

That runs `gh repo create … --template adamsiwiec1/<name>` for each companion
(or seeds files locally if you pass `--from-template=false`).

Manual equivalent:

```bash
OWNER=INSERT_OWNER   # e.g. adamsiwiec1 or your-org

gh repo create "$OWNER/homebrew-tap" --public --template adamsiwiec1/homebrew-tap
gh repo create "$OWNER/scoop-bucket" --public --template adamsiwiec1/scoop-bucket
gh repo create "$OWNER/packages" --public --template adamsiwiec1/packages
gh repo create "$OWNER/chocolatey-packages" --public --template adamsiwiec1/chocolatey-packages
```

Should the companions be templates? **Yes** — same reason `foss-template` is:
one-click “Use this template” *or* scripted `gh repo create --template`. The
app repo stays the place you write code; the four catalogs stay thin and reusable.
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
