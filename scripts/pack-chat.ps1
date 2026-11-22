<#
.SYNOPSIS
  Builds the Claude chat (claude.ai) edition of the skill as a zip you upload under
  Settings > Capabilities > Skills. The plugin copy for Claude Code is untouched.
.DESCRIPTION
  skills/cold-start-brief stays the single source. This script copies it, drops the two
  Claude Code only bits (the argument-hint field and the $ARGUMENTS line), adds a short
  chat note, and zips the folder with SKILL.md one level down, as claude.ai expects.
#>
param([string]$OutDir = (Join-Path (Split-Path $PSScriptRoot -Parent) 'dist'))
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
$repo = Split-Path $PSScriptRoot -Parent
$src = Join-Path $repo 'skills\cold-start-brief'
$version = (Get-Content (Join-Path $repo '.claude-plugin\plugin.json') -Raw | ConvertFrom-Json).version
$zip = Join-Path $OutDir "cold-start-brief-chat-v$version.zip"
$null = New-Item -ItemType Directory -Force $OutDir
if (Test-Path $zip) { Remove-Item $zip }

$note = @'

> **Chat edition.** This copy runs in Claude chat, which cannot read your files. Where the steps below say to scout the project, ask the user to paste the relevant parts (instruction files, README, status notes, the task), and write the handoff from what they paste. Fetch the target model's current prompting guide only if you have web access; otherwise ask the user to paste it. A profile is used only if the user pastes one.
'@

$z = [System.IO.Compression.ZipFile]::Open($zip, 'Create')
try {
  foreach ($f in Get-ChildItem $src -Recurse -File) {
    $rel = $f.FullName.Substring($src.Length + 1).Replace('\', '/')
    if ($rel -eq 'SKILL.md') {
      $text = [IO.File]::ReadAllText($f.FullName) -replace "\r\n", "`n"
      $text = $text -replace '(?m)^argument-hint:.*\n', ''
      $text = $text -replace '(?m)^Request: \$ARGUMENTS$', "Request: the user's message in this chat."
      $text = $text -replace '(?m)^(# Cold Start Brief)\n', ("`$1`n" + $note.Replace("`r`n", "`n") + "`n")
      if ($text -match 'ARGUMENTS|argument-hint' -or $text -notmatch 'Chat edition') { throw 'chat transform failed' }
      $bytes = (New-Object Text.UTF8Encoding($false)).GetBytes($text)
    } else { $bytes = [IO.File]::ReadAllBytes($f.FullName) }
    $e = $z.CreateEntry("cold-start-brief/$rel", [IO.Compression.CompressionLevel]::Optimal)
    $s = $e.Open(); $s.Write($bytes, 0, $bytes.Length); $s.Dispose()
  }
} finally { $z.Dispose() }
Write-Output $zip
