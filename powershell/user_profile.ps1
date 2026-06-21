# set PowerShell to UTF-8
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

$omp_config = Join-Path $PSScriptRoot ".\noorkhafidzin.omp.json"
oh-my-posh init pwsh --config $omp_config | Invoke-Expression


# Load posh-git after 2 seconds
$timer1 = New-Object System.Timers.Timer(2000)
$timer1.AutoReset = $false
Register-ObjectEvent -InputObject $timer1 -EventName Elapsed -Action {
    Import-Module posh-git -ErrorAction SilentlyContinue
    $timer1.Dispose()
} | Out-Null
$timer1.Start()

# Load Terminal-Icons after 3 seconds
$timer2 = New-Object System.Timers.Timer(3000)
$timer2.AutoReset = $false
Register-ObjectEvent -InputObject $timer2 -EventName Elapsed -Action {
    Import-Module Terminal-Icons -ErrorAction SilentlyContinue
    $timer2.Dispose()
} | Out-Null
$timer2.Start()

# Load PSFzf after 4 seconds
$timer3 = New-Object System.Timers.Timer(4000)
$timer3.AutoReset = $false
Register-ObjectEvent -InputObject $timer3 -EventName Elapsed -Action {
    Import-Module PSFzf -ErrorAction SilentlyContinue
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r' -ErrorAction SilentlyContinue
    $timer3.Dispose()
} | Out-Null
$timer3.Start()

# === PSReadLine (needed immediately for typing, ~200ms is acceptable) ===
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History

# === Env ===
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

# === Alias ===
Set-Alias -Name vim -Value nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias gg 'C:\Users\el\goto-v1.4.1\gg-win.exe'
function .. { Set-Location .. }
function ..2 { Set-Location ..\.. }
function ..3 { Set-Location ..\..\.. }
Set-Alias c clear

# === Utilities ===
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# === zoxide (37ms - load immediately) ===
Invoke-Expression (& { (zoxide init powershell | Out-String) })
