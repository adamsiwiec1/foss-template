# What this is

FOSS Template is a repository you copy, not a library you install. It exists so
a new public project starts with the files GitHub, Open Source Guides, and
working projects like [OnionGate](https://github.com/openhat-security/oniongate)
already expect.

## Why not `.github`?

GitHub treats a repository named `.github` as special:

- On a **user** account, `profile/README.md` in that repo becomes the profile
  page. Forking [github/.github](https://github.com/github/.github) puts
  GitHub's own org README on your profile.
- On an **organization**, the files become org-wide defaults for repos that
  lack their own copy. That is useful, but it is not a project template.

This repo is named `foss-template` so people can fork it like any other
project. If an org later wants org-wide defaults, create a *separate* public
`.github` repo and copy only the community files — never a profile README
meant for someone else.

## What to do next

1. Fork or use this template.
2. Follow [Customize after a fork](./setup.md) and the root [SETUP.md](https://github.com/adamsiwiec1/foss-template/blob/main/SETUP.md).
3. Write your software in `src/` and your docs here under `docs/`.

```bash
npm ci
npm run docs:dev
```
