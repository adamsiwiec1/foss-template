# Contributing

INSERT_PROJECT is released under the [MIT license](LICENSE). By contributing
you agree that your contribution is distributed under that license.
Participation is governed by the [Code of Conduct](CODE_OF_CONDUCT.md).

## Development

Requires Node.js as pinned in [`.nvmrc`](.nvmrc).

```bash
npm ci
npm run docs:dev
npm run docs:build
```

Add application checks (test, lint, typecheck) to `package.json` and to
[`.github/workflows/ci.yml`](.github/workflows/ci.yml) when you add `src/`.

Do not commit secrets, credentials, `.env` files, or personal data.

## Documentation

The site in `docs/` is VitePress and publishes to GitHub Pages from `main`.

`docs/guide/` is task-oriented. `docs/reference/` is lasting fact.
GitHub-conventional files stay at the repository root. Update the docs in the
same pull request as the behavior they describe.

## Changelog

Every user-visible change needs a [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
bullet under `## [Unreleased]` in [CHANGELOG.md](CHANGELOG.md) in the same PR.
Before a release, move Unreleased into a dated `## [x.y.z] - YYYY-MM-DD`
section. Use [Semantic Versioning](https://semver.org/).

## Pull requests

- One concern per PR when you can.
- Describe the change and any security or privacy impact.
- Update docs and the changelog when behavior changes.
- Preserve attribution and verify license compatibility for reused code.

Security vulnerabilities must follow [SECURITY.md](SECURITY.md), not public
issues.

See [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/)
and [Using pull requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests).
