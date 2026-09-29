#!/usr/bin/env bash
# Create packaging companion repos from adamsiwiec1 templates (or seed locally).
#
# Usage:
#   ./scripts/bootstrap-packaging.sh --owner YOUR_GITHUB_USER_OR_ORG
#   ./scripts/bootstrap-packaging.sh --owner my-org --prefix '' --dry-run
#   ./scripts/bootstrap-packaging.sh --owner my-org --from-template=false
#
# Requires: gh (authenticated), git
set -euo pipefail

OWNER=""
PREFIX=""
DRY_RUN=0
FROM_TEMPLATE=1
TEMPLATE_OWNER="${TEMPLATE_OWNER:-adamsiwiec1}"
PRIVATE=0
YES=0

REPOS=(homebrew-tap scoop-bucket packages chocolatey-packages)

usage() {
  cat <<EOF
Create packaging companion repos from GitHub templates (or seed locally).

Usage:
  ./scripts/bootstrap-packaging.sh --owner YOUR_GITHUB_USER_OR_ORG
  ./scripts/bootstrap-packaging.sh --owner my-org --dry-run
  ./scripts/bootstrap-packaging.sh --owner my-org --from-template=false

Requires: gh (authenticated), git

Options:
  --owner NAME          GitHub user or org that will own the new repos (required)
  --prefix STR          Optional name prefix (e.g. myproj- → myproj-homebrew-tap)
  --template-owner NAME Whose templates to clone from (default: adamsiwiec1)
  --from-template=false Create empty repos and push seed files instead of gh template clone
  --private             Create private repos
  --yes                 Do not prompt
  --dry-run             Print actions only
  -h, --help            Show this help

Examples:
  ./scripts/bootstrap-packaging.sh --owner adamsiwiec1
  make bootstrap-packaging OWNER=openhat-security
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --owner) OWNER="${2:?}"; shift 2 ;;
    --prefix) PREFIX="${2:-}"; shift 2 ;;
    --template-owner) TEMPLATE_OWNER="${2:?}"; shift 2 ;;
    --from-template=false|--no-from-template) FROM_TEMPLATE=0; shift ;;
    --from-template=true|--from-template) FROM_TEMPLATE=1; shift ;;
    --private) PRIVATE=1; shift ;;
    --yes|-y) YES=1; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown arg: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if [[ -z "$OWNER" ]]; then
  echo "error: --owner is required" >&2
  usage >&2
  exit 2
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "error: gh CLI required (https://cli.github.com/)" >&2
  exit 1
fi

visibility=(--public)
if [[ "$PRIVATE" -eq 1 ]]; then
  visibility=(--private)
fi

echo "Owner:           $OWNER"
echo "Template owner:  $TEMPLATE_OWNER"
echo "Prefix:          ${PREFIX:-(none)}"
echo "From template:   $FROM_TEMPLATE"
echo "Repos:"
for r in "${REPOS[@]}"; do
  echo "  - ${OWNER}/${PREFIX}${r}"
done

if [[ "$YES" -ne 1 && "$DRY_RUN" -ne 1 ]]; then
  read -r -p "Create these repos? [y/N] " ans
  case "$ans" in
    y|Y|yes|YES) ;;
    *) echo "aborted"; exit 1 ;;
  esac
fi

run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "dry-run: $*"
  else
    "$@"
  fi
}

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
WORKDIR="${TMPDIR:-/tmp}/foss-packaging-bootstrap-$$"
mkdir -p "$WORKDIR"
cleanup() { rm -rf "$WORKDIR"; }
trap cleanup EXIT

repo_exists() {
  gh repo view "$1" >/dev/null 2>&1
}

seed_from_local() {
  local name="$1" # homebrew-tap etc
  local full="$2" # owner/name
  local dest="$WORKDIR/$name"
  mkdir -p "$dest"

  case "$name" in
    homebrew-tap)
      mkdir -p "$dest/Casks"
      touch "$dest/Casks/.gitkeep"
      cat >"$dest/README.md" <<EOF
# homebrew-tap

Homebrew tap for \`${OWNER}\` CLIs. Seeded by [foss-template](https://github.com/${TEMPLATE_OWNER}/foss-template).

\`\`\`bash
brew install --cask ${OWNER}/tap/YOUR_CLI
\`\`\`

Put Casks in \`Casks/\`. Template: \`packaging/homebrew/\` in foss-template.
EOF
      ;;
    scoop-bucket)
      mkdir -p "$dest/bucket"
      touch "$dest/bucket/.gitkeep"
      cat >"$dest/README.md" <<EOF
# scoop-bucket

Scoop bucket for \`${OWNER}\`. Seeded by [foss-template](https://github.com/${TEMPLATE_OWNER}/foss-template).

\`\`\`bash
scoop bucket add ${OWNER} https://github.com/${OWNER}/${PREFIX}scoop-bucket
scoop install YOUR_CLI
\`\`\`
EOF
      ;;
    packages)
      touch "$dest/.nojekyll"
      cat >"$dest/index.html" <<EOF
<!DOCTYPE html><html><body>
<h1>${OWNER} packages</h1>
<p>apt + dnf Pages repo. Build with foss-template <code>packaging/repo/build-pages-repos.sh</code>.</p>
</body></html>
EOF
      cat >"$dest/README.md" <<EOF
# packages (apt + dnf)

GitHub Pages host for apt/dnf. Enable **Settings → Pages**.

Seeded by [foss-template](https://github.com/${TEMPLATE_OWNER}/foss-template).
EOF
      ;;
    chocolatey-packages)
      cat >"$dest/README.md" <<EOF
# chocolatey-packages

Chocolatey nuspec sources for \`${OWNER}\`.

Seeded by [foss-template](https://github.com/${TEMPLATE_OWNER}/foss-template).
See \`packaging/chocolatey/\` in the template.
EOF
      ;;
  esac

  (
    cd "$dest"
    git init -q
    git checkout -b main
    git add -A
    git -c user.email="bootstrap@localhost" -c user.name="foss-template bootstrap" commit -q -m "chore: seed ${name} from foss-template bootstrap"
    if [[ "$DRY_RUN" -eq 1 ]]; then
      echo "dry-run: would create $full and push"
      return 0
    fi
    if repo_exists "$full"; then
      echo "exists: $full (skip create; push seed if empty? — skipping push to avoid overwrite)"
      return 0
    fi
    gh repo create "$full" "${visibility[@]}" --description "Packaging companion (${name}) for FOSS CLIs" --source=. --remote=origin --push
  )
}

create_from_template() {
  local name="$1"
  local full="${OWNER}/${PREFIX}${name}"
  local tmpl="${TEMPLATE_OWNER}/${name}"

  if repo_exists "$full"; then
    echo "exists: $full — skip"
    return 0
  fi

  if [[ "$FROM_TEMPLATE" -eq 1 ]]; then
    if ! gh repo view "$tmpl" >/dev/null 2>&1; then
      echo "warn: template $tmpl missing — falling back to local seed" >&2
      seed_from_local "$name" "$full"
      return 0
    fi
    # gh repo create --template requires the template to have is_template=true
    run gh repo create "$full" "${visibility[@]}" \
      --template="$tmpl" \
      --description "Packaging companion (${name}) from ${tmpl}" \
      --clone=false
    echo "created from template: $full ← $tmpl"
  else
    seed_from_local "$name" "$full"
  fi
}

for r in "${REPOS[@]}"; do
  create_from_template "$r"
done

echo
echo "Done. Next:"
echo "  1. Copy Casks / Scoop JSON / deb-rpm Pages builds from your app's packaging/ into these repos via release CI."
echo "  2. On packages: Settings → Pages → Deploy from branch main (or gh-pages)."
echo "  3. Add PACKAGING_TOKEN on the app repo with contents:write on these four."
echo
echo "Docs: ${ROOT}/packaging/README.md"
