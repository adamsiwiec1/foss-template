# Governance

INSERT_PROJECT is a small open-source project.

## Roles

- **Maintainers** (`INSERT_CONTACT` and anyone listed in
  [CODEOWNERS](.github/CODEOWNERS)) merge pull requests, publish releases, and
  enforce the code of conduct.
- **Contributors** open issues and pull requests. A merged PR does not by
  itself grant maintainer rights.

## Decisions

Day-to-day changes land through pull requests on `main`. Maintainers review
for correctness, license compatibility, and security impact.

Disagreements that a PR thread cannot settle are decided by the maintainers.
If maintainers disagree, the person who has been maintaining the project
longest has the last word unless they delegate.

## Releases

Maintainers cut SemVer tags from `main` after moving
`CHANGELOG.md` `## [Unreleased]` into a dated version section.

## Adding maintainers

A current maintainer invites a regular contributor by adding them to
`CODEOWNERS` and GitHub write access in the same change. Access is removed the
same way.

See [Leadership and Governance](https://opensource.guide/leadership-and-governance/)
in Open Source Guides.
