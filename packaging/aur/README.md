# AUR (`INSERT_REPO-bin`)

Arch does not pull PKGBUILDs from your GitHub app repo. You publish to the
[AUR](https://aur.archlinux.org/) once (SSH key on an AUR account), then bump
`pkgver` / checksums on each release.

Keep a copy of the PKGBUILD in this tree so CI or humans can sync it.

```bash
# First publish
git clone ssh://aur@aur.archlinux.org/INSERT_REPO-bin.git
cp packaging/aur/PKGBUILD.example INSERT_REPO-bin/PKGBUILD
# edit names, fill sha256sums
cd INSERT_REPO-bin
makepkg --printsrcinfo > .SRCINFO
git add PKGBUILD .SRCINFO
git commit -m "INSERT_REPO-bin 0.1.0"
git push
```

Users:

```bash
yay -S INSERT_REPO-bin
# or: paru -S INSERT_REPO-bin
```
