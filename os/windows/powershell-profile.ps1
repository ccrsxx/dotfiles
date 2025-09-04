# Oh My Posh
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/terminal-theme.omp.json" | Invoke-Expression

# Terminal-Icons
Import-Module Terminal-Icons

# PSReadLine
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineKeyHandler -Chord 'Shift+Tab' -Function HistorySearchBackward

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# posh-git
Import-Module posh-git

# Volta completetions
(& volta completions powershell) | Out-String | Invoke-Expression

# Alias
Set-Alias dv yt-dlp
Set-Alias cf cloudflared
Set-Alias file explorer

# Utilities
function reload {
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait(". $")
    [System.Windows.Forms.SendKeys]::SendWait("PROFILE")
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
}

function glo() {
  git log --oneline
}

function glb() {
  git branch -v --sort=committerdate | tail
}

function .. {
  cd ..
}

function ll {
  # ls | Format-Wide -Column 1 | tail -n +5 | head -n -1
  # ls | Format-Wide -Column 1 | tail -n +5
  ls | Format-Wide -Column 1
}

function lw {
  # ls -Exclude .* | Format-Wide -AutoSize
  ls | Format-Wide -AutoSize
}


function ln {
  (ls).name
}

function lz([switch] $f, [switch] $t) {
  $folder = $f
  $total = if ($t) { '-c' } else { $null }

  if ($folder) {
    du -sh */ $total
  } else {
    du -sh * $total
  }
}

function mkcd ($folder) {
  if (!$folder) {
    Write-Error "No folder name specified"
    return
  }

  New-Item -Name $folder -ItemType 'directory' -ErrorAction SilentlyContinue
  Set-Location $folder -ErrorAction SilentlyContinue
}

function rmtree ($folder) {
  if (!$folder) {
    Write-Error "No folder specified"
    return
  }

  if (Test-Path $folder) {
    Remove-Item $folder -Recurse -Force -ErrorAction SilentlyContinue
  } else {
    Write-Error "Folder $folder does not exist"
  }
}

function locate([switch] $r, [switch] $o, $filename) {
  if (!$filename) {
    Write-Error "No filename spesicifed"
    return
  }

  $filename = $filename.ToString()
  $recursive = $r
  $open = $o

  if ($filename.length -eq 1) {
    $filename = "0$($filename)"
  }

  if ($recursive) {
    $filepath = (ls -s -Include "*$($filename)*" | where {$_.PSIsContainer -eq $false}).fullname
  } else {
    $filepath = ln | grep -G "$($filename)"
  }

  if (!$filepath) {
    Write-Error "$($filename) can't be found"
    return
  }

  if ($open) {
    if ($filepath -match '^[A-Z]:.+') {
      & $filepath
    } else {
      . ./$filepath
    }
  } else {
    return $filepath
  }
}

function o([switch] $r, $filename) {
  if ($r) {
    locate -r -o $filename
  } else {
    locate -o $filename
  }

}

function to($filename) {
  touch $filename && o $filename
}

function pjson {
  param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
      $json
  )
  $json | ConvertFrom-Json | ConvertTo-Json -Depth 100
}

function activate {
  if (Test-Path venv) {
    . venv/Scripts/activate.ps1
  } else {
    Write-Error "No virtualenv found"
  }
}
