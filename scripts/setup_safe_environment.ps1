#!/usr/bin/env pwsh
# Safe Setup Script for RRule Refactoring
# This creates a tag and feature branch for safe development

Write-Host "🔒 Creating Safe Development Environment for RRule Refactoring" -ForegroundColor Cyan
Write-Host ""

# Step 1: Create a tag for the current stable version
Write-Host "📌 Step 1: Creating tag for current stable version..." -ForegroundColor Yellow
git tag -a v1.0-pre-rrule -m "Stable version before RRule refactoring - $(Get-Date -Format 'yyyy-MM-dd')"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Tag 'v1.0-pre-rrule' created successfully" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to create tag" -ForegroundColor Red
    exit 1
}

# Step 2: Push the tag to GitHub
Write-Host ""
Write-Host "☁️  Step 2: Pushing tag to GitHub..." -ForegroundColor Yellow
git push origin v1.0-pre-rrule

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Tag pushed to GitHub successfully" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to push tag to GitHub" -ForegroundColor Red
    Write-Host "⚠️  Continuing anyway..." -ForegroundColor Yellow
}

# Step 3: Create feature branch
Write-Host ""
Write-Host "🌿 Step 3: Creating feature branch 'feature/rrule-refactoring'..." -ForegroundColor Yellow
git checkout -b feature/rrule-refactoring

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Feature branch created and checked out" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to create feature branch" -ForegroundColor Red
    exit 1
}

# Step 4: Push feature branch to GitHub
Write-Host ""
Write-Host "☁️  Step 4: Pushing feature branch to GitHub..." -ForegroundColor Yellow
git push -u origin feature/rrule-refactoring

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Feature branch pushed to GitHub successfully" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to push feature branch" -ForegroundColor Red
    Write-Host "⚠️  You can push later with: git push -u origin feature/rrule-refactoring" -ForegroundColor Yellow
}

# Step 5: Verify setup
Write-Host ""
Write-Host "🔍 Step 5: Verifying setup..." -ForegroundColor Yellow
Write-Host ""

$currentBranch = git branch --show-current
Write-Host "Current branch: $currentBranch" -ForegroundColor Cyan

$tags = git tag -l "v1.0-pre-rrule"
Write-Host "Tag created: $tags" -ForegroundColor Cyan

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "✅ SETUP COMPLETE!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "🎯 You are now on branch: feature/rrule-refactoring" -ForegroundColor Green
Write-Host "📌 Stable version tagged as: v1.0-pre-rrule" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 You can now safely start the RRule refactoring!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Quick Commands:" -ForegroundColor Cyan
Write-Host "  View all branches:     git branch -a" -ForegroundColor White
Write-Host "  Go back to master:     git checkout master" -ForegroundColor White
Write-Host "  Go back to stable:     git checkout v1.0-pre-rrule" -ForegroundColor White
Write-Host "  Return to feature:     git checkout feature/rrule-refactoring" -ForegroundColor White
Write-Host ""
Write-Host "📚 See GIT_BRANCHING_STRATEGY.md for more details" -ForegroundColor Cyan
Write-Host ""
