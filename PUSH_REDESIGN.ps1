# PUSH_REDESIGN.ps1
# Run this from PowerShell inside the repo folder:
#   E:\EB1A_Research\Application\MySite\vijayjavvadiresearch-site
#
# Why this script exists: a previous git operation left stale lock files
# (.git\index.lock and .git\index.stash.6.lock) that the sandboxed shell
# couldn't remove. This script cleans them, recovers the index, then
# commits and pushes the redesign branch.
#
# Before running: make sure no other tool has the repo open
# (close GitHub Desktop, VS Code's source-control panel, any open git GUI).

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host "=== 1. Verifying current branch ===" -ForegroundColor Cyan
git rev-parse --abbrev-ref HEAD

Write-Host ""
Write-Host "=== 2. Removing stale lock files (if any) ===" -ForegroundColor Cyan
foreach ($lock in @(".git\index.lock", ".git\index.stash.6.lock")) {
    if (Test-Path $lock) {
        Remove-Item $lock -Force
        Write-Host "  removed $lock"
    } else {
        Write-Host "  $lock not present (good)"
    }
}

Write-Host ""
Write-Host "=== 3. Recovering the index from HEAD ===" -ForegroundColor Cyan
git read-tree --reset HEAD

Write-Host ""
Write-Host "=== 4. Showing files that changed ===" -ForegroundColor Cyan
git status --short

Write-Host ""
Write-Host "=== 5. Staging all changes ===" -ForegroundColor Cyan
git add -A
git status --short

Write-Host ""
Write-Host "=== 6. Committing ===" -ForegroundColor Cyan
git commit -m "May 2026 redesign: 6-paper consolidation, system architecture, modern CSS

- Update paper titles A-F from the May 2026 consolidation (was 8 papers)
- Refresh headline numbers from the corrected file_age_days extraction:
    284,676 -> 296,457 instances
    AUC 0.904 -> 0.8998
    top-10% coverage 43.2% -> 43.82%
    risk lift 4.3x -> 4.37x
- New architecture.html with inline SVG 5-layer system diagram
- New vision.html
- Publications: search + status filter, 6-paper accordion
- Full CSS rewrite: design tokens, dark-mode, accessibility, responsive nav
- Preserve npm packages section in projects.html (sel2pw / bdd2pw / pw-emit)
- Updated sitemap.xml with lastmod + architecture page
- robots.txt now references sitemap"

Write-Host ""
Write-Host "=== 7. Pushing branch to origin ===" -ForegroundColor Cyan
git push -u origin redesign-may-2026

Write-Host ""
Write-Host "=== DONE ===" -ForegroundColor Green
Write-Host "Branch pushed: redesign-may-2026"
Write-Host "Open the PR here:"
$remote = git config --get remote.origin.url
$remote = $remote -replace '\.git$',''
Write-Host "  $remote/pull/new/redesign-may-2026"
