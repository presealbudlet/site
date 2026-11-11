#!/usr/bin/env bash
# Publish the current `redesign` branch to the unlisted preview at
# https://www.gdmunion.co.uk/a2b96c2733/
#
# What it does:
#   1. Builds the site with the preview path as its base URL.
#   2. Copies the build into static/a2b96c2733/ on `main`, using a temporary
#      worktree so your own checkout stays where it is.
#   3. Commits and pushes `main`, which triggers the GitHub Pages deploy.
#
# Commit (and push) your edits to `redesign` first: the script refuses to run
# with uncommitted changes, so the preview always matches a commit.
#
# Usage: scripts/publish-preview.sh

set -euo pipefail

PREVIEW=a2b96c2733
BASE_URL="https://www.gdmunion.co.uk/$PREVIEW"

cd "$(git rev-parse --show-toplevel)"

branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$branch" != "redesign" ]]; then
  echo "You're on '$branch'. Switch to 'redesign' first." >&2
  exit 1
fi
if [[ -n "$(git status --porcelain -- content data templates static config.toml)" ]]; then
  echo "You have uncommitted changes. Commit them to 'redesign' first." >&2
  exit 1
fi

rev=$(git rev-parse --short HEAD)
work=$(mktemp -d)
trap 'git worktree remove --force "$work/main" 2>/dev/null || true; rm -rf "$work"' EXIT

echo "Building preview..."
zola build -o "$work/out" --force -u "$BASE_URL" >/dev/null

echo "Updating main..."
git fetch -q origin main
git worktree add -q "$work/main" origin/main --detach
dest="$work/main/static/$PREVIEW"
mkdir -p "$dest"

# Copy everything except site-wide files that only belong at the real root
# (domain, crawler rules, 404 page, other hidden pages).
rsync -a --delete --checksum \
  --exclude '/CNAME' --exclude '/robots.txt' --exclude '/ai.txt' \
  --exclude '/.well-known/' --exclude '/404.html' --exclude '/4efff1c7fd/' \
  "$work/out/" "$dest/"

cd "$work/main"
if [[ -z "$(git status --porcelain)" ]]; then
  echo "Preview is already up to date. Nothing to publish."
  exit 0
fi
git status --short
git add "static/$PREVIEW"
git commit -q -m "Update redesign preview (redesign@$rev)"
git push -q origin HEAD:main
echo "Pushed. Deploying..."

# Wait for the GitHub Pages deploy, if the gh CLI is available.
if command -v gh >/dev/null; then
  sha=$(git rev-parse HEAD)
  for _ in $(seq 1 30); do
    status=$(gh run list --branch main --limit 5 --json headSha,status,conclusion \
      -q ".[] | select(.headSha==\"$sha\") | \"\(.status) \(.conclusion)\"" | head -1)
    [[ "$status" == completed* ]] && break
    sleep 10
  done
  echo "Deploy: ${status:-not found}"
fi
echo "Preview: $BASE_URL/"
