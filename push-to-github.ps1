# ============================================================
#  push-to-github.ps1
#  Uploads preposition-pal to github.com/adeeba-hnm
#
#  BEFORE RUNNING:
#  1. Install Git from https://git-scm.com/download/win
#  2. Run this script once from the preposition-pal folder
# ============================================================

$GITHUB_USER = "adeeba-hnm"
$REPO_NAME   = "preposition-pal"
$REMOTE_URL  = "https://github.com/$GITHUB_USER/$REPO_NAME.git"

Write-Host ""
Write-Host "📦 Preposition Pal → GitHub Uploader" -ForegroundColor Cyan
Write-Host "   Target: $REMOTE_URL" -ForegroundColor Gray
Write-Host ""

# Check git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git is not installed." -ForegroundColor Red
    Write-Host "   Download it from: https://git-scm.com/download/win" -ForegroundColor Yellow
    Write-Host "   Then re-run this script." -ForegroundColor Yellow
    pause
    exit 1
}

# Init repo if not already
if (-not (Test-Path ".git")) {
    Write-Host "🔧 Initialising git repo..." -ForegroundColor Yellow
    git init
    git branch -M main
}

# Configure identity if not set
$name  = git config user.name  2>$null
$email = git config user.email 2>$null
if (-not $name)  { git config user.name  $GITHUB_USER }
if (-not $email) { git config user.email "$GITHUB_USER@users.noreply.github.com" }

# Stage everything
Write-Host "📁 Staging files..." -ForegroundColor Yellow
git add .

# Commit
$msg = "Initial commit: Preposition Pal chatbot (web + Telegram)"
git commit -m $msg 2>&1 | Out-Null
Write-Host "✅ Committed: $msg" -ForegroundColor Green

# Set remote (replace if exists)
$existing = git remote get-url origin 2>$null
if ($existing) {
    git remote set-url origin $REMOTE_URL
} else {
    git remote add origin $REMOTE_URL
}
Write-Host "🔗 Remote set to: $REMOTE_URL" -ForegroundColor Cyan

# Push
Write-Host ""
Write-Host "🚀 Pushing to GitHub..." -ForegroundColor Yellow
Write-Host "   (A browser window or credential prompt may appear — sign in with your GitHub account)" -ForegroundColor Gray
Write-Host ""

git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "🎉 SUCCESS! Your project is live at:" -ForegroundColor Green
    Write-Host "   https://github.com/$GITHUB_USER/$REPO_NAME" -ForegroundColor Cyan
    Start-Process "https://github.com/$GITHUB_USER/$REPO_NAME"
} else {
    Write-Host ""
    Write-Host "⚠️  Push failed. Common fixes:" -ForegroundColor Red
    Write-Host "   1. Make sure the repo exists on GitHub first:" -ForegroundColor Yellow
    Write-Host "      → https://github.com/new  (name it: $REPO_NAME)" -ForegroundColor Yellow
    Write-Host "   2. If asked for credentials, use your GitHub username + a Personal Access Token" -ForegroundColor Yellow
    Write-Host "      → https://github.com/settings/tokens/new (select 'repo' scope)" -ForegroundColor Yellow
}

Write-Host ""
pause
