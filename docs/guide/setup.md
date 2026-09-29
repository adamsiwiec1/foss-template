# Customize after a fork

The full checklist lives in the repository root:
[SETUP.md](https://github.com/adamsiwiec1/foss-template/blob/main/SETUP.md).

Short version:

1. Search the tree for `INSERT_` and replace every hit.
2. Keep or replace MIT. OnionGate uses GPL-3.0 if you need copyleft.
3. Set Pages to **GitHub Actions** and turn on private vulnerability reporting.
4. On a fork, enable Actions (GitHub leaves them off).
5. Change `docs/.vitepress/config.ts` title, description, and the
   `adamsiwiec1/foss-template` fallback if the repo name changed.
6. For CLIs, create packaging companion repos (brew tap, Scoop bucket, apt/dnf
   Pages, Chocolatey) — see [Distribution packaging](./packaging.md).

VitePress `base` is `/${repo}/` so GitHub Pages works at
`https://<owner>.github.io/<repo>/`. In CI it reads `GITHUB_REPOSITORY`.
