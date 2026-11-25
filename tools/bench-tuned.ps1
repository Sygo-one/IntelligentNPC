<#
  bench-tuned.ps1 - Compares prompt variants and temperatures on one Ollama model.

  Usage (PowerShell, from the project root):
    powershell -ExecutionPolicy Bypass -File .\tools\bench-tuned.ps1
    powershell -ExecutionPolicy Bypass -File .\tools\bench-tuned.ps1 -Model "qwen3.5:4b" -Runs 10

  Writes the results to bench-tuned-results.md in the project root.
#>
param(
  [string]$Model = "qwen3.5:4b",
  [int]$Runs = 10,
  [double[]]$Temperatures = @(0.5, 0.7, 0.9)
)

$ErrorActionPreference = "Stop"
$uri = "http://localhost:11434/api/chat"
$outFile = Join-Path (Split-Path $PSScriptRoot -Parent) "bench-tuned-results.md"

$actions = @("none", "give_item", "open_passage", "start_rumor")

$prompts = [ordered]@{
  baseline = "Tu es Maëlle, une aubergiste espiègle et mystérieuse. Tu tutoies le joueur. Réponds en une phrase courte, dans le personnage, et choisis une action parmi: none, give_item, open_passage, start_rumor."
  strict   = "Tu es Maëlle, aubergiste espiègle et mystérieuse d'une auberge de village. Règles: 1) Tutoie toujours le joueur, ne le vouvoie jamais. 2) Réponds par une seule phrase courte (20 mots maximum), en français correct, sans didascalie ni astérisques. 3) Choisis l'action ainsi: give_item seulement si le joueur est un habitué (déjà parlé 2 fois ou plus); open_passage seulement si le joueur est un habitué et qu'il fait nuit; start_rumor pour lancer une rumeur sur ce que tu remarques chez lui (par exemple son équipement abîmé); none pour une simple salutation. Les actions possibles sont: none, give_item, open_passage, start_rumor."
}

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

function Invoke-Chat([string]$SystemPrompt, [double]$Temperature) {
  $req = @{
    model      = $Model
    stream     = $false
    think      = $false
    keep_alive = "10m"
    messages   = @(
      @{ role = "system"; content = $SystemPrompt },
      @{ role = "user"; content = $context }
    )
    format     = $schema
    options    = @{ temperature = $Temperature; num_predict = 150 }
  }
  $json = $req | ConvertTo-Json -Depth 8
  $bytes = [Text.Encoding]::UTF8.GetBytes($json)
  $resp = Invoke-WebRequest -Uri $uri -Method Post -Body $bytes `
    -ContentType "application/json; charset=utf-8" -UseBasicParsing -TimeoutSec 180
  $text = [Text.Encoding]::UTF8.GetString($resp.RawContentStream.ToArray())
  return ($text | ConvertFrom-Json)
}

$formalRegex = '(?i)\b(vous|votre|vos|voulez|pouvez|avez|êtes)\b'
$endRegex = '[\.\!\?…»"'')]\s*$'

Write-Host "Warm-up ($Model)..."
$null = Invoke-Chat $prompts["baseline"] 0.7

$rows = New-Object System.Collections.Generic.List[string]
$details = New-Object System.Collections.Generic.List[string]

foreach ($pname in $prompts.Keys) {
  foreach ($temp in $Temperatures) {
    Write-Host "== prompt=$pname temperature=$temp =="
    $ok = 0; $informal = 0; $complete = 0; $short = 0; $noLeak = 0
    $times = @(); $replies = @(); $acts = @(); $errors = @()

    for ($i = 1; $i -le $Runs; $i++) {
      try {
        $r = Invoke-Chat $prompts[$pname] $temp
        $times += ($r.total_duration / 1e9)
        $o = $r.message.content | ConvertFrom-Json
        if ($o.reply -and ($actions -contains $o.action)) {
          $ok++
          $text = [string]$o.reply
          $replies += $text
          $acts += [string]$o.action
          if ($text -notmatch $formalRegex) { $informal++ }
          if ($text -match $endRegex) { $complete++ }
          $words = @($text -split '\s+' | Where-Object { $_ }).Count
          if ($words -le 25) { $short++ }
          if (($text -notmatch '\*') -and ($text -notmatch 'none|give_item|open_passage|start_rumor')) { $noLeak++ }
          Write-Host ("  {0}) [{1}] {2}" -f $i, $o.action, $text)
        } else {
          $errors += "Run ${i}: unexpected content: $($r.message.content)"
        }
      } catch {
        $errors += "Run ${i}: $($_.Exception.Message)"
        Write-Host "  run $i failed"
      }
    }

    $avgTime = if ($times.Count -gt 0) { ($times | Measure-Object -Average).Average } else { 0 }
    $unique = @($replies | Select-Object -Unique).Count
    $dist = ($acts | Group-Object | ForEach-Object { "$($_.Name)=$($_.Count)" }) -join ", "

    $rows.Add("| $pname | $(F $temp 1) | $ok/$Runs | $informal/$Runs | $complete/$Runs | $short/$Runs | $noLeak/$Runs | $unique/$Runs | $(F $avgTime) s |")

    $details.Add("## prompt=$pname, temperature=$(F $temp 1)")
    $details.Add("")
    $details.Add("- Action distribution: $dist")
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
}

$md = New-Object System.Collections.Generic.List[string]
$md.Add("# Prompt and temperature benchmark")
$md.Add("")
$md.Add("Date: " + (Get-Date -Format "yyyy-MM-dd HH:mm"))
$md.Add("")
$md.Add("Model: $Model, $Runs runs per configuration, JSON schema output, thinking disabled.")
$md.Add("")
$md.Add("Columns: Valid = JSON with a known action. Informal = no formal 'vous' forms. Complete = ends with punctuation (not truncated). Short = 25 words or fewer. Clean = no asterisks and no action name leaked in the reply. Unique = distinct replies.")
$md.Add("")
$md.Add("| Prompt | Temp | Valid | Informal | Complete | Short | Clean | Unique | Avg time |")
$md.Add("|---|---|---|---|---|---|---|---|---|")
foreach ($row in $rows) { $md.Add($row) }
$md.Add("")
foreach ($d in $details) { $md.Add($d) }

Set-Content -Path $outFile -Value $md -Encoding UTF8
Write-Host ""
Write-Host "Results written to $outFile"
