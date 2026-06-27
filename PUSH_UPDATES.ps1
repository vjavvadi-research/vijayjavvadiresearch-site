# PUSH_UPDATES.ps1
# Commits and pushes the June 2026 content update to main (GitHub Pages).
#
# Run from PowerShell inside the repo folder:
#   cd E:\EB1A_Research\Application\MySite\vijayjavvadiresearch-site
#   .\PUSH_UPDATES.ps1

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host "=== 1. Current branch ===" -ForegroundColor Cyan
git rev-parse --abbrev-ref HEAD

Write-Host ""
Write-Host "=== 2. Sanity checks on working files ===" -ForegroundColor Cyan
$papers   = (Select-String -Path "publications.html" -Pattern '<article class="paper"' -AllMatches).Matches.Count
$linkedin = (Select-String -Path "index.html" -Pattern "linkedin.com/in/vijay-p-j" -AllMatches).Matches.Count
$oldEmail = (Select-String -Path *.html -Pattern "research@vijayjavvadiresearch" -AllMatches).Matches.Count
$paperqc  = Test-Path "paperqc.html"
Write-Host "  publications.html article count : $papers (expect 9)"
Write-Host "  index.html LinkedIn link        : $linkedin (expect 1)"
Write-Host "  leftover research@ references    : $oldEmail (expect 0)"
Write-Host "  paperqc.html present            : $paperqc (expect True)"

Write-Host ""
Write-Host "=== 3. Files changed ===" -ForegroundColor Cyan
git status --short

Write-Host ""
Write-Host "=== 4. Staging all changes ===" -ForegroundColor Cyan
git add -A

Write-Host ""
Write-Host "=== 5. Committing ===" -ForegroundColor Cyan
git commit -m "Site update (June 2026): 9-manuscript pipeline, PaperQC, profiles, contact email

- Publications: expand from 6 to 9 manuscripts (A-F + bdd2pw, sel2pw, Paper G1)
  with correct venues, manuscript IDs, status (Under Review), and DOIs
- Honesty pass: remove 'Vision'/'published' wording; preprints marked not peer-reviewed
- Home/Research/Program/Product/Impact/Timeline/Recognition: reconcile counts to nine
- Research page: add Test-Automation Tooling and Software Fraud Detection areas (8 areas)
- New TestForge PaperQC product page (paperqc.html) + homepage banner + cross-links
- Add Google Scholar (afSI26UAAAAJ) and LinkedIn links
- Change contact email research@ -> vijay@vijayjavvadiresearch.ai site-wide
- Update sitemap.xml with paperqc.html"

Write-Host ""
Write-Host "=== 6. Pushing to origin/main ===" -ForegroundColor Cyan
git push origin main

Write-Host ""
Write-Host "=== DONE ===" -ForegroundColor Green
Write-Host "Watch the build: https://github.com/vjavvadi-research/vijayjavvadiresearch-site/actions"
Write-Host "Then check (incognito): https://vijayjavvadiresearch.ai/publications.html  (expect 9 entries)"
