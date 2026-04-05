$packages = @(
    "7zip.7zip",
    "astral-sh.uv",
    "CrystalDewWorld.CrystalDiskInfo",
    "DigitalScholar.Zotero",
    "Docker.DockerDesktop",
    "Fastfetch-cli.Fastfetch",
    "Git.Git",
    "GitHub.GitHubDesktop",
    "Google.Antigravity",
    "Google.Chrome",
    "Guru3D.Afterburner",
    "JesseDuffield.lazygit",
    "Klocman.BulkCrapUninstaller",
    "Logitech.OptionsPlus",
    "Microsoft.AppInstaller",
    "Microsoft.PowerToys",
    "Microsoft.VisualStudioCode",
    "Microsoft.WindowsTerminal",
    "Microsoft.WSL",
    "Neovim.Neovim",
    "NetEase.UURemote",
    "Obsidian.Obsidian",
    "REALiX.HWiNFO",
    "Syncthing.Syncthing",
    "Tailscale.Tailscale",
    "TechPowerUp.GPU-Z",
    "Valve.Steam",
    "Zen-Team.Zen-Browser",
    # "Zettlr.Zettlr",
)

Write-Host "Starting WinGet package installation..." -ForegroundColor Cyan

foreach ($package in $packages) {
    Write-Host "Installing $package..." -ForegroundColor Yellow
    winget install --id $package -e -s winget --accept-package-agreements --accept-source-agreements --silent
}

Write-Host "All winget packages processed!" -ForegroundColor Green
