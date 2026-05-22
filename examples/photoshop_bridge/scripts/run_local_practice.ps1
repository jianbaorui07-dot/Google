param(
    [string]$OutputDir
)

$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\..\..")
if (-not $OutputDir) {
    $OutputDir = Join-Path $RepoRoot "output\photoshop_bridge_practice"
}

$OutputDir = [System.IO.Path]::GetFullPath($OutputDir)
New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

$probeOutput = Join-Path $OutputDir "codex_photoshop_probe.png"
$subjectInput = Join-Path $OutputDir "subject_input_clean.png"
$subjectOutput = Join-Path $OutputDir "subject_cutout_clean.png"

function New-PublicSubjectImage {
    param([string]$Path)

    Add-Type -AssemblyName System.Drawing
    $bitmap = New-Object System.Drawing.Bitmap 900, 600
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.Clear([System.Drawing.Color]::White)

    $shadowBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(55, 0, 0, 0))
    $subjectBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 40, 120, 210))
    $accentBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 235, 80, 70))

    $graphics.FillEllipse($shadowBrush, 285, 485, 330, 55)
    $graphics.FillEllipse($subjectBrush, 300, 80, 300, 420)
    $graphics.FillRectangle($accentBrush, 410, 235, 80, 180)
    $bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)

    $graphics.Dispose()
    $bitmap.Dispose()
    $shadowBrush.Dispose()
    $subjectBrush.Dispose()
    $accentBrush.Dispose()
}

$probe = & (Join-Path $PSScriptRoot "com_probe.ps1") -OutputPath $probeOutput | ConvertFrom-Json
New-PublicSubjectImage -Path $subjectInput
$cutout = & (Join-Path $PSScriptRoot "extract_subject_to_png.ps1") -InputPath $subjectInput -OutputPath $subjectOutput | ConvertFrom-Json

[pscustomobject]@{
    ok = [bool]($probe.ok -and $cutout.ok)
    status_label = "Photoshop local bridge practice completed"
    photoshop_version = $probe.photoshopVersion
    probe_output = $probe.output
    subject_input = $subjectInput
    subject_cutout_method = $cutout.method
    subject_cutout_output = $cutout.output
    subject_cutout_exists = $cutout.exists
    output_dir = $OutputDir
    note = "The output directory is local generated content and is ignored by the output/ rule in .gitignore."
} | ConvertTo-Json -Depth 6
