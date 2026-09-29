#!/usr/bin/env bash
# Build apt + dnf repository trees from a directory of .deb/.rpm files.
# Usage: build-pages-repos.sh <pkg-dir> <out-dir>
# Unsigned by default. Set GPG_PRIVATE_KEY to sign apt InRelease.
set -euo pipefail

PKG_DIR="$(cd "${1:?pkg dir}" && pwd)"
OUT_RAW="${2:?out dir}"
REPO_URL="${REPO_URL:-https://INSERT_OWNER.github.io/packages}"

rm -rf "$OUT_RAW"
mkdir -p "$OUT_RAW/deb/pool/main" \
  "$OUT_RAW/deb/dists/stable/main/binary-amd64" \
  "$OUT_RAW/deb/dists/stable/main/binary-arm64" \
  "$OUT_RAW/rpm"
OUT="$(cd "$OUT_RAW" && pwd)"

shopt -s nullglob
debs=("$PKG_DIR"/*.deb)
if ((${#debs[@]})); then
  cp -a "${debs[@]}" "$OUT/deb/pool/main/"
  if command -v apt-ftparchive >/dev/null 2>&1; then
    pushd "$OUT/deb" >/dev/null
    for arch in amd64 arm64; do
      mkdir -p "dists/stable/main/binary-${arch}"
      apt-ftparchive --arch "$arch" packages pool/main > "dists/stable/main/binary-${arch}/Packages" || true
      gzip -9fk "dists/stable/main/binary-${arch}/Packages" || true
    done
    apt-ftparchive release dists/stable > dists/stable/Release
    popd >/dev/null
  else
    echo "warn: apt-ftparchive unavailable — deb pool copied without Packages index" >&2
  fi
fi

rpms=("$PKG_DIR"/*.rpm)
if ((${#rpms[@]})); then
  cp -a "${rpms[@]}" "$OUT/rpm/"
  if command -v createrepo_c >/dev/null 2>&1; then
    createrepo_c "$OUT/rpm"
  else
    echo "warn: createrepo_c unavailable — rpm tree has packages but no repodata" >&2
  fi
fi

ROOT="$(cd "$(dirname "$0")" && pwd)"
sed "s#@REPO_URL@#${REPO_URL}#g" "$ROOT/index.html.in" > "$OUT/index.html"
sed "s#@REPO_URL@#${REPO_URL}#g" "$ROOT/apt/sources.list.in" > "$OUT/INSERT_REPO.list"
sed "s#@REPO_URL@#${REPO_URL}#g" "$ROOT/rpm/INSERT_REPO.repo.in" > "$OUT/INSERT_REPO.repo"
sed "s#@REPO_URL@#${REPO_URL}#g" "$ROOT/install-apt.sh" > "$OUT/install-apt.sh"
sed "s#@REPO_URL@#${REPO_URL}#g" "$ROOT/install-dnf.sh" > "$OUT/install-dnf.sh"
chmod +x "$OUT/install-apt.sh" "$OUT/install-dnf.sh"
touch "$OUT/.nojekyll"

echo "OK pages tree → $OUT"
