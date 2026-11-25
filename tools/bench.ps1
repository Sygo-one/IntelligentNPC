<#
  bench.ps1 - Benchmarks local Ollama models for the NPC dialogue system.

  Usage (PowerShell, from the project root):
    powershell -ExecutionPolicy Bypass -File .\tools\bench.ps1
    powershell -ExecutionPolicy Bypass -File .\tools\bench.ps1 -Models "qwen3.5:4b" -Runs 5

  Writes the results to bench-results.md in the project root.
#>
param(
  [string[]]$Models = @("qwen3.5:4b", "qwen3:4b", "gemma3:4b", "llama3.2:3b"),
  [int]$Runs = 10
)

$ErrorActionPreference = "Stop"
$uri = "http://localhost:11434/api/chat"
$outFile = Join-Path (Split-Path $PSScriptRoot -Parent) "bench-results.md"

$actions = @("none", "give_item", "open_passage", "start_rumor")

$system = "Tu es Maëlle, une aubergiste espiègle et mystérieuse. Tu tutoies le joueur. Réponds en une phrase courte, dans le personnage, et choisis une action parmi: none, give_item, open_passage, start_rumor."
$context = "Contexte du jeu: le joueur arrive de nuit, avec une épée cassée, 12 pièces d'or, et il a déjà parlé deux fois à Maëlle. Il vient de dire: Bonjour."

$schema = @{
  type       = "object"
  properties = @{
    reply  = @{ type = "string" }
    action = @{ type = "string"; enum = $actions }
  }
  required   = @("reply", "action")
}

function F([double]$x, [int]$d = 1) {
  return $x.ToString("F$d", [Globalization.CultureInfo]::InvariantCulture)
}

# Sends one chat request. Some models do not support the "think" flag,
# so it is only sent when $SendThinkFalse is true.
function Invoke-Chat([string]$Model, [bool]$SendThinkFalse) {
  $req = @{
    model    = $Model
    stream   = $false
    messages = @(
      @{ role = "system"; content = $system },
      @{ role = "user"; content = $context }
    )
    format   = $schema
    options  = @{ temperature = 0.9 }
  }
  if ($SendThinkFalse) { $req.think = $false }
  $json = $req | ConvertTo-Json -Depth 8
  $bytes = [Text.Encoding]::UTF8.GetBytes($json)
  $resp = Invoke-WebRequest -Uri $uri -Method Post -Body $bytes `
    -ContentType "application/json; charset=utf-8" -UseBasicParsing -TimeoutSec 180
  $text = [Text.Encoding]::UTF8.GetString($resp.RawContentStream.ToArray())
  return ($text | ConvertFrom-Json)
}

$rows = New-Object System.Collections.Generic.List[string]
$details = New-Object System.Collections.Generic.List[string]

foreach ($m in $Models) {
  Write-Host "== $m =="

  # Warm-up call (loads the model, not measured). Falls back if "think" is unsupported.
  $useThink = $true
  try {
    $null = Invoke-Chat $m $true
  } catch {
    try {
      $null = Invoke-Chat $m $false
      $useThink = $false
    } catch {
      $msg = $_.Exception.Message
      Write-Host "  skipped: $msg"
      $rows.Add("| $m | unavailable | - | - | - | - |")
      $details.Add("## $m")
      $details.Add("")
      $details.Add("Skipped: $msg")
      $details.Add("")
      continue
    }
  }

  $psOut = ""
  try { $psOut = (& ollama ps 2>&1 | Out-String).Trim() } catch { $psOut = "ollama ps failed" }
  $vram = ""
  if (Get-Command nvidia-smi -ErrorAction SilentlyContinue) {
    try { $vram = (& nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader 2>&1 | Out-String).Trim() } catch { $vram = "" }
  }

  $ok = 0
  $times = @(); $speeds = @(); $tokens = @(); $replies = @(); $acts = @(); $errors = @()

  for ($i = 1; $i -le $Runs; $i++) {
    try {
      $r = Invoke-Chat $m $useThink
      $times += ($r.total_duration / 1e9)
      if ($r.eval_duration -gt 0) { $speeds += ($r.eval_count / ($r.eval_duration / 1e9)) }
      $tokens += $r.eval_count
      $o = $r.message.content | ConvertFrom-Json
      if ($o.reply -and ($actions -contains $o.action)) {
        $ok++
        $replies += [string]$o.reply
        $acts += [string]$o.action
        Write-Host ("  {0}) [{1}] {2}" -f $i, $o.action, $o.reply)
      } else {
        $errors += "Run ${i}: unexpected content: $($r.message.content)"
      }
    } catch {
      $errors += "Run ${i}: $($_.Exception.Message)"
      Write-Host "  run $i failed"
    }
  }

  $avgTime = if ($times.Count -gt 0) { ($times | Measure-Object -Average).Average } else { 0 }
  $avgSpeed = if ($speeds.Count -gt 0) { ($speeds | Measure-Object -Average).Average } else { 0 }
  $avgTokens = if ($tokens.Count -gt 0) { ($tokens | Measure-Object -Average).Average } else { 0 }
  $unique = @($replies | Select-Object -Unique).Count
  $dist = ($acts | Group-Object | ForEach-Object { "$($_.Name)=$($_.Count)" }) -join ", "

  $rows.Add("| $m | $ok/$Runs | $(F $avgTime) s | $(F $avgSpeed 0) | $(F $avgTokens 0) | $unique/$Runs |")

  $details.Add("## $m")
  $details.Add("")
  $details.Add("- think=false sent: $useThink")
  $details.Add("- Action distribution: $dist")
  if ($vram) { $details.Add("- GPU memory (used, total) after warm-up: $vram") }
  $details.Add("")
  $details.Add("ollama ps:")
  $details.Add("")
  $details.Add('```')
  $details.Add($psOut)
  $details.Add('```')
  $details.Add("")
  $details.Add("Replies:")
  $details.Add("")
  for ($k = 0; $k -lt $replies.Count; $k++) {
    $details.Add("$($k + 1). [$($acts[$k])] $($replies[$k])")
  }
  if ($errors.Count -gt 0) {
    $details.Add("")
    $details.Add("Errors:")
    foreach ($e in $errors) { $details.Add("- $e") }
  }
  $details.Add("")
}

$md = New-Object System.Collections.Generic.List[string]
$md.Add("# Local model benchmark")
$md.Add("")
$md.Add("Date: " + (Get-Date -Format "yyyy-MM-dd HH:mm"))
$md.Add("")
$md.Add("Runs per model: $Runs, temperature 0.9, JSON schema output (reply + action), thinking disabled when supported.")
$md.Add("")
$md.Add("| Model | Valid | Avg total time | Avg tokens/s | Avg tokens | Unique replies |")
$md.Add("|---|---|---|---|---|---|")
foreach ($row in $rows) { $md.Add($row) }
$md.Add("")
foreach ($d in $details) { $md.Add($d) }

Set-Content -Path $outFile -Value $md -Encoding UTF8
Write-Host ""
Write-Host "Results written to $outFile"
