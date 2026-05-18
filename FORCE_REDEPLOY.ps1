# FORCE_REDEPLOY.ps1
# Pushes an empty commit to main to force GitHub Pages to rebuild,
# in case the previous build was missed or the CDN is serving stale content.
#
# Run from the repo folder:
#   cd E:\EB1A_Research\Application\MySite\vijayjavvadiresearch-site
#   .\FORCE_REDEPLOY.ps1

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host "=== 1. Sync with remote main ===" -ForegroundColor Cyan
git fetch origin
git checkout main
git reset --hard origin/main

Write-Host ""
Write-Host "=== 2. Confirm publications.html on local main has 6 papers ===" -ForegroundColor Cyan
$count = (Select-String -Path "publications.html" -Pattern "PAPER [A-F]</span>" -AllMatches).Matches.Count
Write-Host "  PAPER A..F markers found: $count (expect 6)"

Write-Host ""
Write-Host "=== 3. Empty commit to trigger GitHub Pages rebuild ===" -ForegroundColor Cyan
git commit --allow-empty -m "chore: trigger GitHub Pages rebuild"

Write-Host ""
Write-Host "=== 4. Push ===" -ForegroundColor Cyan
git push origin main

Write-Host ""
Write-Host "=== DONE ===" -ForegroundColor Green
Write-Host "Now do these two things:"
Write-Host ""
Write-Host "  1. Open https://github.com/vjavvadi-research/vijayjavvadiresearch-site/actions"
Write-Host "     Watch the 'pages build and deployment' workflow finish (~30-60s)."
Write-Host ""
Write-Host "  2. Once it shows green, open https://vijayjavvadiresearch.ai/publications.html"
Write-Host "     in an INCOGNITO / PRIVATE WINDOW (Ctrl+Shift+N in Chrome)."
Write-Host "     This guarantees no browser cache."
Write-Host ""
Write-Host "  You should see 6 papers (A-F), 296,457 instances, AUC 0.8998."
