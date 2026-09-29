#!/usr/bin/env bash
# Create packaging companion repos from adamsiwiec1 templates (or seed locally).
#
# Dependencies: gh (GitHub CLI, authenticated), git
#   Install gh: https://cli.github.com/
#   Then: gh auth login
#
# Usage:
#   ./scripts/bootstrap-packaging.sh --owner YOUR_GITHUB_USER_OR_ORG
#   ./scripts/bootstrap-packaging.sh --owner my-org --dry-run
#   ./scripts/bootstrap-packaging.sh --owner my-org --from-template=false
set -euo pipefail

OWNER=""
PREFIX=""
DRY_RUN=0
FROM_TEMPLATE=1
TEMPLATE_OWNER="${TEMPLATE_OWNER:-adamsiwiec1}"
PRIVATE=0
YES=0
# When --yes and a repo exists: skip | rename | archive
ON_EXISTS="${ON_EXISTS:-skip}"

REPOS=(homebrew-tap scoop-bucket packages chocolatey-packages)

usage() {
  cat <<EOF
Create packaging companion repos from GitHub templates (or seed locally).

Dependencies:
  gh    GitHub CLI (required) — https://cli.github.com/
        Must be authenticated: gh auth login
  git   Required to seed repos when --from-template=false

Usage:
  ./scripts/bootstrap-packaging.sh --owner YOUR_GITHUB_USER_OR_ORG
  ./scripts/bootstrap-packaging.sh --owner my-org --dry-run
  ./scripts/bootstrap-packaging.sh --owner my-org --from-template=false

Options:
  --owner NAME            GitHub user or org that will own the new repos (required)
  --prefix STR            Optional name prefix (e.g. myproj- → myproj-homebrew-tap)
  --template-owner NAME   Whose templates to clone from (default: adamsiwiec1)
  --from-template=false   Create empty repos and push seed files instead of gh template clone
  --private               Create private repos
  --yes                   Do not prompt for the initial create confirmation
  --on-exists MODE        When a repo already exists and --yes is set:
                            skip     leave it alone (default)
                            rename   rename to NAME-legacy-DATE, then create from template
                            archive  rename to NAME-archived-DATE, archive it, then create
  --dry-run               Print actions only
  -h, --help              Show this help

If a target repo already exists (interactive, without --yes), you will be asked:
  [s] skip     — keep the existing repo
  [r] rename   — rename it, then create from our template under the original name
  [a] archive  — rename + archive it, then create from our template

Examples:
  ./scripts/bootstrap-packaging.sh --owner adamsiwiec1
  ./scripts/bootstrap-packaging.sh --owner my-org --yes --on-exists skip
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
    --on-exists) ON_EXISTS="${2:?}"; shift 2 ;;
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

case "$ON_EXISTS" in
  skip|rename|archive) ;;
  *) echo "error: --on-exists must be skip|rename|archive (got $ON_EXISTS)" >&2; exit 2 ;;
esac

# --- dependency: GitHub CLI ---
if ! command -v gh >/dev/null 2>&1; then
  cat >&2 <<EOF
error: missing dependency: gh (GitHub CLI)

  Install:  https://cli.github.com/
  macOS:    brew install gh
  Debian:   See https://github.com/cli/cli/blob/trunk/docs/install_linux.md
  Then:     gh auth login

This script uses gh to create repos from templates, rename, and archive.
EOF
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "error: missing dependency: git" >&2
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  cat >&2 <<EOF
error: gh is installed but not authenticated.

  Run:  gh auth login
EOF
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
echo "On exists:       $ON_EXISTS (used with --yes)"
echo "Dependencies:    gh $(gh --version | head -1), git $(git --version | awk '{print $3}')"
echo "Repos:"
for r in "${REPOS[@]}"; do
  echo "  - ${OWNER}/${PREFIX}${r}"
done

if [[ "$YES" -ne 1 && "$DRY_RUN" -ne 1 ]]; then
  read -r -p "Continue? [y/N] " ans
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

print_existing() {
  local full="$1"
  local url desc vis updated
  url="$(gh repo view "$full" --json url -q .url 2>/dev/null || echo "?")"
  desc="$(gh repo view "$full" --json description -q .description 2>/dev/null || echo "")"
  vis="$(gh repo view "$full" --json visibility -q .visibility 2>/dev/null || echo "?")"
  updated="$(gh repo view "$full" --json updatedAt -q .updatedAt 2>/dev/null || echo "?")"
  echo
  echo "Already exists: $full"
  echo "  url:         $url"
  echo "  visibility:  $vis"
  echo "  updated:     $updated"
  if [[ -n "$desc" && "$desc" != "null" ]]; then
    echo "  description: $desc"
  fi
}

# Free the canonical name by renaming (and optionally archiving) the existing repo.
displace_existing() {
  local full="$1"   # owner/name
  local mode="$2"   # rename | archive
  local owner name stamp new_name
  owner="${full%%/*}"
  name="${full#*/}"
  stamp="$(date -u +%Y%m%d)"
  if [[ "$mode" == "archive" ]]; then
    new_name="${name}-archived-${stamp}"
  else
    new_name="${name}-legacy-${stamp}"
  fi

  # Interactive override for the new name
  if [[ "$YES" -ne 1 && "$DRY_RUN" -ne 1 ]]; then
    read -r -p "  Rename existing repo to '${owner}/${new_name}'? Enter for yes, or type a different name: " custom
    if [[ -n "${custom// /}" ]]; then
      new_name="$custom"
      new_name="${new_name##*/}" # strip owner if pasted
    fi
  fi

  local dest="${owner}/${new_name}"
  if repo_exists "$dest"; then
    echo "error: destination $dest already exists — choose another name" >&2
    return 1
  fi

  echo "  → renaming $full → $dest (via gh)"
  # gh repo rename only takes the new name when run inside a clone; use API for owner/repo.
  run gh api -X PATCH "repos/${full}" -f name="$new_name" >/dev/null
  # After rename, full path is dest
  if [[ "$mode" == "archive" ]]; then
    echo "  → archiving $dest (via gh)"
    run gh repo archive "$dest" --yes
  fi
  echo "  ✓ old repo is now $dest"
}

choose_exists_action() {
  local full="$1"
  if [[ "$YES" -eq 1 ]]; then
    echo "$ON_EXISTS"
    return
  fi
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "skip"
    return
  fi
  echo
  echo "What should we do with $full?"
  echo "  [s] skip     — keep it, do not create from template"
  echo "  [r] rename   — rename it (frees the name), then create from our template"
  echo "  [a] archive  — rename + archive it, then create from our template"
  echo "  (Archiving alone does not free the name on GitHub — we rename first.)"
  local choice
  while true; do
    read -r -p "Choice [s/r/a]: " choice
    case "$choice" in
      s|S|skip) echo "skip"; return ;;
      r|R|rename) echo "rename"; return ;;
      a|A|archive) echo "archive"; return ;;
      *) echo "  enter s, r, or a" ;;
    esac
  done
}

create_fresh() {
  local name="$1"
  local full="$2"
  local tmpl="${TEMPLATE_OWNER}/${name}"

  if [[ "$FROM_TEMPLATE" -eq 1 ]]; then
    if ! gh repo view "$tmpl" >/dev/null 2>&1; then
      echo "warn: template $tmpl missing — falling back to local seed" >&2
      seed_from_local "$name" "$full"
      return 0
    fi
    run gh repo create "$full" "${visibility[@]}" \
      --template="$tmpl" \
      --description "Packaging companion (${name}) from ${tmpl}" \
      --clone=false
    echo "created from template: $full ← $tmpl"
  else
    seed_from_local "$name" "$full"
  fi
}

seed_from_local() {
  local name="$1"
  local full="$2"
  local dest="$WORKDIR/$name"
  rm -rf "$dest"
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
    git -c user.email="bootstrap@localhost" -c user.name="foss-template bootstrap" \
      commit -q -m "chore: seed ${name} from foss-template bootstrap"
    if [[ "$DRY_RUN" -eq 1 ]]; then
      echo "dry-run: would create $full and push seed"
      return 0
    fi
    if repo_exists "$full"; then
      echo "error: $full still exists — displace it first" >&2
      return 1
    fi
    gh repo create "$full" "${visibility[@]}" \
      --description "Packaging companion (${name}) for FOSS CLIs" \
      --source=. --remote=origin --push
  )
}

handle_repo() {
  local name="$1"
  local full="${OWNER}/${PREFIX}${name}"

  if ! repo_exists "$full"; then
    create_fresh "$name" "$full"
    return 0
  fi

  print_existing "$full"
  local action
  action="$(choose_exists_action "$full")"

  case "$action" in
    skip)
      echo "  → skipping $full (left unchanged)"
      ;;
    rename)
      displace_existing "$full" rename
      create_fresh "$name" "$full"
      ;;
    archive)
      displace_existing "$full" archive
      create_fresh "$name" "$full"
      ;;
    *)
      echo "error: unknown action $action" >&2
      return 1
      ;;
  esac
}

for r in "${REPOS[@]}"; do
  handle_repo "$r"
done

echo
echo "Done. Next:"
echo "  1. Copy Casks / Scoop JSON / deb-rpm Pages builds from your app's packaging/ into these repos via release CI."
echo "  2. On packages: Settings → Pages → Deploy from branch main (or gh-pages)."
echo "  3. Add PACKAGING_TOKEN on the app repo with contents:write on these four."
echo
echo "Docs: ${ROOT}/packaging/README.md"
echo "Dependency: gh — $(command -v gh) ($(gh --version | head -1))"
