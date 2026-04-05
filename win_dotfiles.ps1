$ErrorActionPreference = "Stop"

$DotfilesDir = "$HOME\.dotfiles"
$BackupDir = "$HOME\.dotfiles-backup\$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$LocalAppData = [System.Environment]::GetFolderPath('LocalApplicationData')

# Array of Hashtables for our links
$FilesToSymlink = @(
    @{ Src = ".gitconfig"; Dst = "$HOME\.gitconfig" },
    @{ Src = "nvim"; Dst = "$LocalAppData\nvim" },
    @{ Src = "okularpartrc"; Dst = "$LocalAppData\okular\okularpartrc" }
)

Write-Host "`nInstalling dotfiles for Windows..." -ForegroundColor Cyan

foreach ($item in $FilesToSymlink) {
    $srcRelative = $item.Src
    $dst = $item.Dst
    $src = Join-Path $DotfilesDir $srcRelative

    Write-Host "`n$src"

    if (Test-Path -Path $dst -ErrorAction SilentlyContinue) {
        $linkTarget = (Get-Item $dst).Target
        if ($linkTarget -eq $src) {
            Write-Host "Skipped: $dst already correctly linked" -ForegroundColor Blue
            continue
        } else {
            $backup = Join-Path $BackupDir $srcRelative
            $null = New-Item -ItemType Directory -Path (Split-Path $backup) -Force
            Move-Item -Path $dst -Destination $backup -Force
            Write-Host "Warning: Existing file backed up to $backup" -ForegroundColor Yellow
        }
    }

    # Ensure parent directory of symlink exists
    $null = New-Item -ItemType Directory -Path (Split-Path $dst) -Force

    # Create Native Windows Symbolic Link
    $null = New-Item -ItemType SymbolicLink -Path $dst -Target $src -Force
    Write-Host "Linked $src ? $dst" -ForegroundColor Green
}

Write-Host "`nAll Windows dotfiles installed!" -ForegroundColor Green