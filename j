# Rookery: the one line a member pastes into Windows Terminal or PowerShell.
#
#     irm https://raw.githubusercontent.com/corvus-engine/join/main/j | iex
#
# Public on purpose, and it holds nothing secret. It installs GitHub CLI if it is missing, signs you in to
# GitHub (a browser tab), then fetches the group's setup from the PRIVATE repo corvus-engine/rookery with
# your own sign-in and runs it. Without an invitation to corvus-engine it stops at the fetch.
#
# The organizer can prefill answers so the setup asks nothing; set these before the line, on the same line:
#     $env:GROUP_MEMBER='nate'; $env:GROUP_TOKEN='<bot token>';
& {
  $ErrorActionPreference = "Stop"
  try { [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 } catch { }
  function Have($c) { return [bool](Get-Command $c -ErrorAction SilentlyContinue) }
  function Refresh-Path {
    $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")
  }
  $repo = "corvus-engine/rookery"
  try {
    if (-not (Have gh)) {
      Write-Host "Installing GitHub CLI. If Windows asks to allow changes, click Yes." -ForegroundColor Cyan
      if (-not (Have winget)) { throw "winget is missing: install 'App Installer' from the Microsoft Store, then paste the line again." }
      winget install -e --id GitHub.cli --silent --accept-package-agreements --accept-source-agreements | Out-Null
      Refresh-Path
      $pf = Join-Path $env:ProgramFiles "GitHub CLI"
      if (-not (Have gh) -and (Test-Path (Join-Path $pf "gh.exe"))) { $env:Path += ";$pf" }
      if (-not (Have gh)) { throw "GitHub CLI did not install. Install it from https://cli.github.com, then paste the line again." }
    }
    cmd /c "gh auth status >nul 2>&1"
    if ($LASTEXITCODE -ne 0) {
      Write-Host "Signing in to GitHub: press Enter at each question, a browser tab opens, type the code shown here, Authorize." -ForegroundColor Cyan
      & gh auth login -h github.com -p https -w
      cmd /c "gh auth status >nul 2>&1"
      if ($LASTEXITCODE -ne 0) { throw "GitHub sign-in did not finish. Paste the line again." }
    }
    $dir = Join-Path $env:TEMP "rookery"
    New-Item -ItemType Directory -Force $dir | Out-Null
    $dst = Join-Path $dir "setup.ps1"
    $text = & gh api "repos/$repo/contents/setup.ps1" -H "Accept: application/vnd.github.raw"
    if ($LASTEXITCODE -ne 0 -or -not $text) {
      throw "Could not fetch the group's setup. Accept the corvus-engine invitation on GitHub (the email, or the bell on github.com), then paste the line again."
    }
    [IO.File]::WriteAllText($dst, (($text -join "`n") + "`n"), (New-Object Text.UTF8Encoding $false))
    $env:GROUP_SETUP_NO_PAUSE = "1"
    $extra = @()
    if ($env:GROUP_SETUP_ARGS) { $extra = $env:GROUP_SETUP_ARGS -split ' ' }
    & powershell -NoProfile -ExecutionPolicy Bypass -File $dst @extra
    if ($LASTEXITCODE -ne 0) { Write-Host "Setup did not finish. Paste the line again to retry." -ForegroundColor Red }
  } catch {
    Write-Host ""
    Write-Host $_.Exception.Message -ForegroundColor Red
  } finally {
    Remove-Item Env:GROUP_TOKEN -ErrorAction SilentlyContinue
  }
}
