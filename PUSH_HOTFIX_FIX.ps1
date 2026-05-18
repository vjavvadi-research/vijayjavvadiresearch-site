# PUSH_HOTFIX_FIX.ps1
# The previous run committed the hotfix to the wrong branch (redesign-may-2026)
# and tried to push a stale local main. This script catches main up to remote,
# cherry-picks the hotfix commit, and pushes main.
#
# Run from the repo folder:
#   cd E:\EB1A_Research\Application\MySite\vijayjavvadiresearch-site
#   .\PUSH_HOTFIX_FIX.ps1

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host "=== 1. Fetch latest from origin ===" -ForegroundColor Cyan
git fetch origin

Write-Host ""
Write-Host "=== 2. Find the hotfix commit on redesign-may-2026 ===" -ForegroundColor Cyan
$hotfixSha = (git rev-parse redesign-may-2026).Trim()
Write-Host "  hotfix commit: $hotfixSha"

Write-Host ""
Write-Host "=== 3. Switch to main and sync with remote ===" -ForegroundColor Cyan
git checkout main
git reset --hard origin/main

Write-Host ""
Write-Host "=== 4. Cherry-pick the hotfix onto main ===" -ForegroundColor Cyan
git cherry-pick $hotfixSha

Write-Host ""
Write-Host "=== 5. Push main ===" -ForegroundColor Cyan
git push origin main

Write-Host ""
Write-Host "=== 6. Tidy up the obsolete branch ===" -ForegroundColor Cyan
git branch -D redesign-may-2026
# Try to delete the remote branch too (it may already be auto-deleted after the first PR merge)
git push origin --delete redesign-may-2026 2>$null

Write-Host ""
Write-Host "=== DONE ===" -ForegroundColor Green
Write-Host "Hotfix landed on main. GitHub Pages will rebuild within 1-2 minutes."
Write-Host "Hard-refresh (Ctrl+Shift+R) to see:"
Write-Host "  - Profile picture back in the homepage hero"
Write-Host "  - Footer stacked correctly on dark navy"
Write-Host "  - Status pills, timeline, architecture diagram all styled"
