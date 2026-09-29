# Changelog

All notable user-facing changes to FOSS Template are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `scripts/bootstrap-packaging.sh` (+ `make bootstrap-packaging OWNER=…`) to
  create Homebrew/Scoop/apt/Chocolatey companion repos from GitHub templates
  in one command; example packaging repos marked as templates.
- `packaging/` templates for Homebrew, Scoop, apt/dnf Pages, AUR, winget,
  Chocolatey, and optional npm — plus docs linking example companion repos
  (`homebrew-tap`, `scoop-bucket`, `packages`, `chocolatey-packages`).
- Community health files, VitePress docs, and GitHub Actions for a new FOSS
  repository.
