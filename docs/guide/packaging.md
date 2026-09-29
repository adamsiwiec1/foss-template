# Distribution packaging

GitHub Releases are enough to *host* binaries. Package managers need **catalog
entries** in places they already trust. That is why FOSS Template ships a
[`packaging/`](https://github.com/adamsiwiec1/foss-template/tree/main/packaging)
tree **and** points you at small companion repositories.

## Why companion repos exist

| Repo | Role |
| --- | --- |
| [`homebrew-tap`](https://github.com/adamsiwiec1/homebrew-tap) | Homebrew only loads formulas/casks from a tap (`brew tap OWNER/tap`). Your app repo cannot be the tap. |
| [`scoop-bucket`](https://github.com/adamsiwiec1/scoop-bucket) | Scoop installs from a *bucket* of JSON manifests. |
| [`packages`](https://github.com/adamsiwiec1/packages) | apt and dnf need a browsable HTTP repo (deb pool + rpm repodata). GitHub Pages on a dedicated repo is the usual free host. |
| [`chocolatey-packages`](https://github.com/adamsiwiec1/chocolatey-packages) | Place to keep nuspecs you `choco pack` / push (community review still happens on chocolatey.org). |

Production-scale mirrors of the same idea:
[openhat-security/homebrew-tap](https://github.com/openhat-security/homebrew-tap),
[scoop-bucket](https://github.com/openhat-security/scoop-bucket),
[packages](https://github.com/openhat-security/packages).

**AUR** and **winget** do not use your GitHub org as the catalog — AUR is its
own Git host; winget is PRs into `microsoft/winget-pkgs`. Templates still live
under `packaging/aur` and `packaging/winget`.

## What to do

1. Read [`packaging/README.md`](https://github.com/adamsiwiec1/foss-template/blob/main/packaging/README.md).
2. Create the four companion repos once — they are GitHub **templates**:

```bash
./scripts/bootstrap-packaging.sh --owner YOUR_USER_OR_ORG --yes
```

   Or use **Use this template** on each example repo linked below.
3. Wire release CI to push Cask / Scoop / Pages updates with a
   `PACKAGING_TOKEN`.
4. Replace every `INSERT_*` placeholder before the first real release.

```bash
# Users (after you publish):
brew install --cask INSERT_OWNER/tap/INSERT_REPO
scoop bucket add INSERT_OWNER https://github.com/INSERT_OWNER/scoop-bucket
scoop install INSERT_REPO
curl -fsSL https://INSERT_OWNER.github.io/packages/install-apt.sh | sudo bash
```
