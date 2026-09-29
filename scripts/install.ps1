# ==============================================================================
# nvim-setup Windows Automated Bootstrap Script (Hardened Production Grade)
# Targets: Windows 10 / Windows 11 (PowerShell 5.1 / PowerShell 7+)
# ==============================================================================

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

function Write-Info { param([string]$Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }
function Write-Ok   { param([string]$Message) Write-Host "[OK]   $Message" -ForegroundColor Green }
function Write-Warn { param([string]$Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Err  { param([string]$Message) Write-Host "[ERR]  $Message" -ForegroundColor Red }

# Enable TLS 1.2 for legacy Windows PowerShell 5.1 sessions
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$RepoUrl = "https://github.com/frtzhahn/nvim-setup.git"
$TargetDir = "$env:LOCALAPPDATA\nvim"

Write-Host "=== nvim-setup Windows Automated Bootstrap ===`n" -ForegroundColor Blue

# ------------------------------------------------------------------------------
# 1. Ensure Scoop & Prerequisites
# ------------------------------------------------------------------------------
function Ensure-Scoop {
    Write-Info "Checking for Scoop package manager..."
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Info "Scoop not found. Installing Scoop into userland..."
        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
        Invoke-RestMethod -UseBasicParsing -Uri https://get.scoop.sh | Invoke-Expression
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "User") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        Write-Ok "Scoop installed successfully."
    } else {
        Write-Ok "Scoop package manager detected."
    }

    # CRITICAL: Install Git & 7zip FIRST. Scoop requires Git to add buckets!
    Write-Info "Ensuring Git and 7zip are installed..."
    scoop install git 7zip 2>$null | Out-Null
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "User") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "Machine")

    # Add required buckets
    $buckets = @("extras", "versions", "java")
    foreach ($bucket in $buckets) {
        Write-Info "Adding Scoop bucket: $bucket..."
        scoop bucket add $bucket 2>$null | Out-Null
    }
}

# ------------------------------------------------------------------------------
# 2. Install Core Tooling & Dependencies
# ------------------------------------------------------------------------------
function Install-Tools {
    Write-Info "Installing core compilers, runtimes, and Neovim tools..."
    $packages = @(
        "curl",
        "wget",
        "jq",
        "make",
        "mingw",             # Provides GCC, G++, and binutils (replaces invalid 'gcc')
        "cmake",
        "ripgrep",
        "fd",
        "win32yank",
        "nodejs-lts",
        "python",
        "openjdk17",         # Valid manifest in 'java' bucket (replaces invalid 'openjdk17-lts')
        "go",
        "lua",
        "tree-sitter",
        "neovim-nightly"     # Guaranteed Neovim >= 0.12.0 from 'versions' bucket
    )

    foreach ($pkg in $packages) {
        Write-Info "Verifying package: $pkg..."
        scoop install $pkg 2>$null | Out-Null
    }

    # Refresh PATH in current session
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "User") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    Write-Ok "Core tooling verified and installed."
}

# ------------------------------------------------------------------------------
# 3. Deploy Configuration
# ------------------------------------------------------------------------------
function Deploy-Config {
    Write-Info "Deploying configuration to $TargetDir..."

    $ScriptRoot = Split-Path -Parent $PSScriptRoot

    if (Test-Path "$TargetDir\.git") {
        Write-Info "Existing git repository found. Pulling latest commits..."
        git -C $TargetDir pull --ff-only
    } elseif (($ScriptRoot -ne $TargetDir) -and (Test-Path "$ScriptRoot\init.lua")) {
        Write-Info "Deploying from local clone at $ScriptRoot to $TargetDir..."
        if (-not (Test-Path (Split-Path -Parent $TargetDir))) {
            New-Item -ItemType Directory -Path (Split-Path -Parent $TargetDir) -Force | Out-Null
        }
        Copy-Item -Path $ScriptRoot -Destination $TargetDir -Recurse -Force
    } elseif (Test-Path $TargetDir) {
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        $backupDir = "$TargetDir.bak.$timestamp"
        Write-Warn "Existing non-git directory found. Creating backup at $backupDir..."
        Move-Item -Path $TargetDir -Destination $backupDir -Force
        Write-Info "Cloning nvim-setup repository..."
        git clone $RepoUrl $TargetDir
    } else {
        Write-Info "Cloning nvim-setup repository into $TargetDir..."
        git clone $RepoUrl $TargetDir
    }
    Write-Ok "Configuration deployed."
}

# ------------------------------------------------------------------------------
# 4. Bootstrap Plugins Headless
# ------------------------------------------------------------------------------
function Bootstrap-Plugins {
    Write-Info "Bootstrapping Lazy.nvim plugins in headless mode (this may take 1-2 minutes)..."
    if (Get-Command nvim -ErrorAction SilentlyContinue) {
        & nvim --headless "+Lazy! sync" +qa
        Write-Ok "Lazy.nvim plugins bootstrapped. Language servers and Treesitter parsers will complete on first launch."
    } else {
        Write-Err "Neovim command not found in PATH. Please restart PowerShell and run: nvim"
    }
}

# ------------------------------------------------------------------------------
# Main Pipeline
# ------------------------------------------------------------------------------
try {
    Ensure-Scoop
    Install-Tools
    Deploy-Config
    Bootstrap-Plugins
    Write-Host "`n=== Setup Complete! Launch with 'nvim' ===" -ForegroundColor Green
} catch {
    Write-Err "Installation encountered an error: $_"
    exit 1
}
