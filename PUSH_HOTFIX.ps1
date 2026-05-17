# PUSH_HOTFIX.ps1
# Hotfix push: restores truncated CSS + profile picture + cache-bust.
# Run from the repo folder:
#   cd E:\EB1A_Research\Application\MySite\vijayjavvadiresearch-site
#   .\PUSH_HOTFIX.ps1
#
# Close GitHub Desktop / VS Code source-control panel first.

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host "=== 1. Switch to main ===" -ForegroundColor Cyan
git checkout main
git pull origin main

Write-Host ""
Write-Host "=== 2. Removing stale lock files (if any) ===" -ForegroundColor Cyan
foreach ($lock in @(".git\index.lock", ".git\index.stash.6.lock")) {
    if (Test-Path $lock) {
        Remove-Item $lock -Force
        Write-Host "  removed $lock"
    }
}

Write-Host ""
Write-Host "=== 3. Showing what changed ===" -ForegroundColor Cyan
git status --short

Write-Host ""
Write-Host "=== 4. Staging ===" -ForegroundColor Cyan
git add -A
git status --short

Write-Host ""
Write-Host "=== 5. Committing ===" -ForegroundColor Cyan
git commit -m "Hotfix: restore truncated CSS + profile picture + cache-bust

- css/style.css was truncated mid-rule at line 318 in the previous push,
  so the entire footer, status pills, timeline, architecture and utilities
  blocks were missing. Full file restored (307 lines).
- Restore profile picture in index.html hero.
- Cache-bust style.css link (?v=2026-05-17b) on all 15 HTML pages so the
  GitHub Pages CDN serves the new CSS instead of the cached truncated one."

Write-Host ""
Write-Host "=== 6. Pushing to main ===" -ForegroundColor Cyan
git push origin main

Write-Host ""
Write-Host "=== DONE ===" -ForegroundColor Green
Write-Host "Live site will rebuild within 1-2 minutes."
Write-Host "After it deploys, hard-refresh (Ctrl+Shift+R) to see:"
Write-Host "  - Profile picture back in the homepage hero"
Write-Host "  - Footer stacked correctly on dark navy background"
Write-Host "  - Status pills, timeline, architecture diagram styled"
