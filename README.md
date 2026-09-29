# FOSS Template

A starter for a **free and open source** project. Fork it or use it as a GitHub
template, then replace the placeholders and write your software.

It is the shared baseline for [OpenHat Security](https://github.com/openhat-security)
and [The FreeTech Company](https://github.com/the-freetech-company). A real
project that follows this shape is
[OnionGate](https://github.com/openhat-security/oniongate).

**This is not a `.github` profile repository.** A repo named `.github` on a
user account becomes the profile README. This repo is named `foss-template` on
purpose so you can fork it without hijacking anyone's profile.

## What you get

GitHub's [community profile](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/about-community-profiles-for-public-repositories)
checklist, plus the files GitHub applies as
[defaults](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file)
and a [VitePress](https://vitepress.dev/) docs site (same stack as OnionGate):

| File | Why |
| --- | --- |
| [LICENSE](LICENSE) | OSI-approved MIT. Swap for [GPL-3.0](https://choosealicense.com/licenses/gpl-3.0/) if you want copyleft (OnionGate does). |
| [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) | Contributor Covenant 2.1 |
| [CONTRIBUTING.md](CONTRIBUTING.md) | How to send a change |
| [SECURITY.md](SECURITY.md) | Private vulnerability reporting |
| [SUPPORT.md](SUPPORT.md) | Where to ask for help |
| [GOVERNANCE.md](GOVERNANCE.md) | Who decides |
| [CHANGELOG.md](CHANGELOG.md) | [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) + [SemVer](https://semver.org/) |
| [CITATION.cff](CITATION.cff) | How to cite the project |
| [`.github/`](.github/) | Issue / PR templates, Dependabot, CI, Pages deploy |
| [`docs/`](docs/) | VitePress site → GitHub Pages |
| [`packaging/`](packaging/) | Homebrew, Scoop, apt/dnf, AUR, winget, Chocolatey, npm templates |

After you customize, check **Insights → Community standards** on the new repo.

## Use it

1. Click **Use this template** (or fork — OpenHat Security and The FreeTech
   Company keep forks of this repo).
2. Follow [SETUP.md](SETUP.md). Search the tree for `INSERT_` and replace every
   hit.
3. Enable **Settings → Pages → Source: GitHub Actions**.
4. Enable **Settings → Code security → Private vulnerability reporting**.
5. Put your code in `src/` (create it) and keep docs in `docs/`.

```bash
npm ci
npm run docs:dev      # http://localhost:5173/foss-template/
npm run docs:build    # what CI and Pages build
```

Node version is in [`.nvmrc`](.nvmrc) (22+, same floor as current VitePress).

## Documentation

The site builds from `docs/` and deploys on every push to `main`.

- [Getting started](docs/guide/index.md)
- [Customize after a fork](docs/guide/setup.md)
- [Write docs](docs/guide/docs.md)
- [Distribution packaging](docs/guide/packaging.md) — brew, apt, AUR, dnf, Scoop, Chocolatey, winget
- [Community health files](docs/reference/community-health.md)
- [Changelog](CHANGELOG.md)

### Example packaging repos

These empty(ish) catalogs exist so a new project can copy the layout instead of
guessing Homebrew/Scoop/Pages conventions:

| Repo | Why it must be separate |
| --- | --- |
| [adamsiwiec1/homebrew-tap](https://github.com/adamsiwiec1/homebrew-tap) | Homebrew tap (`brew tap …`) |
| [adamsiwiec1/scoop-bucket](https://github.com/adamsiwiec1/scoop-bucket) | Scoop bucket |
| [adamsiwiec1/packages](https://github.com/adamsiwiec1/packages) | apt + dnf on GitHub Pages |
| [adamsiwiec1/chocolatey-packages](https://github.com/adamsiwiec1/chocolatey-packages) | Chocolatey nuspec sources |

Full channel matrix: [packaging/README.md](packaging/README.md).

## Contributing

Contributions are welcome under MIT. Read [CONTRIBUTING.md](CONTRIBUTING.md)
and the [Code of Conduct](CODE_OF_CONDUCT.md). Report security issues privately
per [SECURITY.md](SECURITY.md) — never in a public issue.

## License

[MIT](LICENSE). The Code of Conduct text is
[Contributor Covenant 2.1](https://www.contributor-covenant.org/version/2/1/code_of_conduct.html)
(CC-BY-4.0).

## Inspiration

- [github/.github](https://github.com/github/.github) — community health files
- [GitHub community health docs](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file)
- [Open Source Guides](https://opensource.guide/)
- [diggsweden/open-source-project-template](https://github.com/diggsweden/open-source-project-template)
- [VitePress getting started](https://vitepress.dev/guide/getting-started) and [Pages deploy](https://vitepress.dev/guide/deploy#github-pages)
- [openhat-security/oniongate](https://github.com/openhat-security/oniongate) — live project with this layout
