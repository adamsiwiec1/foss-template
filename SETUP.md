# Setup after you fork or use this template

Do this once on the new repository. Do **not** rename the repo to `.github`.
That name is reserved: on a user account it becomes the profile README; on an
org it becomes the org-wide community-health default set.

## 1. Replace placeholders

Search the whole tree for these tokens and replace them:

| Token | Meaning | Example |
| --- | --- | --- |
| `INSERT_OWNER` | GitHub user or org | `openhat-security` |
| `INSERT_REPO` | Repository name | `my-project` |
| `INSERT_PROJECT` | Human title | `My Project` |
| `INSERT_DESCRIPTION` | One-line pitch | `Does one thing well.` |
| `INSERT_YEAR` | Copyright year | `2026` |
| `INSERT_CONTACT` | Maintainer handle or inbox | `@you` |

Also replace the copyright line in `LICENSE`, `package.json` `name` /
`repository` / `homepage`, `.github/CODEOWNERS`, and any
`adamsiwiec1/foss-template` URLs.

## 2. Pick a license

This starter ships [MIT](LICENSE). That is OSI-approved and easy to reuse.

If the project must stay copyleft (OnionGate's choice), replace `LICENSE` with
[GPL-3.0](https://choosealicense.com/licenses/gpl-3.0/) and change
`package.json` `"license"` plus the contributing / PR template wording.

You cannot inherit a license from a `.github` default repo — GitHub requires
`LICENSE` in each project.

## 3. Point VitePress at the new name

`docs/.vitepress/config.ts` already reads `GITHUB_REPOSITORY` in CI so Pages
gets the right `/repo/` base. Locally it falls back to `foss-template`. After
you rename the project, set the fallback `repo` / `owner` constants in that
file so `npm run docs:dev` matches production.

## 4. Turn on GitHub features

In the new repo:

1. **Settings → General → Features** — Issues on. Discussions optional.
2. **Settings → Pages** — Build and deployment source: **GitHub Actions**.
3. **Settings → Code security** — Private vulnerability reporting on.
4. **Actions** — on a fork, enable workflows (GitHub disables them by default).
5. Create labels `bug` and `enhancement` if the issue forms complain they are
   missing (GitHub often creates them on first use).

## 5. Write the project

- Put application code in `src/` (create the directory).
- Put task docs in `docs/guide/` and lasting facts in `docs/reference/`.
- Keep GitHub-conventional files at the repo root (`README`, `LICENSE`,
  `CONTRIBUTING`, `CODE_OF_CONDUCT`, `SECURITY`, `SUPPORT`, `GOVERNANCE`).
- Add every user-visible change under `## [Unreleased]` in `CHANGELOG.md`.

## 6. First push check

```bash
npm ci
npm run docs:build
```

Then open **Insights → Community standards** and tick anything still empty.
