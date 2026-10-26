#!/bin/zsh
# Publish a new build of the mockup to GitHub Pages: copy the page, commit, push. Pages redeploys on each push to main.
set -euo pipefail
src="${1:-$HOME/Desktop/business-projects-mockup.html}"
cd "$(dirname "$0")"
log() { print -r -- "[publish $(date +%H:%M:%S)] $*"; }
[[ -f "$src" ]] || { log "ERROR: no page at $src"; exit 1; }
grep -q '<meta name="robots" content="noindex, nofollow">' "$src" || { log "ERROR: $src has no noindex meta; build it with splice.py"; exit 1; }
log "source $src ($(wc -c < "$src" | tr -d ' ') bytes)"
cp "$src" index.html
if git diff --quiet -- index.html; then log "no change to index.html; nothing to publish"; exit 0; fi
git add index.html
git commit -q -m "Publish a new build of the mockup" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
log "committed $(git rev-parse --short HEAD)"
t0=$SECONDS; git push -q origin main; log "pushed to origin/main in $((SECONDS - t0)) s"
log "live in about a minute: https://digitalwillads.github.io/dwa-agents-mockup/"
