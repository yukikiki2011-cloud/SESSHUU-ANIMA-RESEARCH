$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$targetDir = "c:\Users\0000429445\Documents\GitHub\KAWAI-RESEARCH"
$files = Get-ChildItem -Path "$targetDir\RESEARCH_*.csv"
$db = @{}

foreach ($f in $files) {
    $member = $f.BaseName.Replace("RESEARCH_", "").ToUpper()
    # Read the CSV file bytes and convert to string using UTF8 strictly to bypass shell auto-decoding magic
    $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
    $text = [System.Text.Encoding]::UTF8.GetString($bytes)
    
    # Save to a temporary file without BOM just to be parsed safely
    $tempFile = "$targetDir\temp_$member.csv"
    [System.IO.File]::WriteAllText($tempFile, $text, [System.Text.Encoding]::UTF8)
    
    $data = Import-Csv -Path $tempFile -Encoding utf8
    if ($data) {
        $db[$member] = $data | ForEach-Object {
            $obj = @{}
            foreach ($prop in $_.PSObject.Properties) {
                # Ensure the keys are clean.
                $cleanKey = $prop.Name.Trim()
                $obj[$cleanKey] = $prop.Value
            }
            $obj
        }
    }
    Remove-Item $tempFile
}

function Convert-ToObject {
    param($InputObject)
    if ($InputObject -is [System.Collections.IDictionary]) {
        $hash = @{}
        foreach ($key in $InputObject.Keys) {
            $hash[$key] = Convert-ToObject -InputObject $InputObject[$key]
        }
        return $hash
    } elseif ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
        $array = @()
        foreach ($item in $InputObject) {
            $array += Convert-ToObject -InputObject $item
        }
        return $array
    } else {
        return $InputObject
    }
}

$cleanDb = Convert-ToObject -InputObject $db

$jsonDb = $cleanDb | ConvertTo-Json -Depth 10 -Compress

# Read template directly specifying UTF8
$templateBytes = [System.IO.File]::ReadAllBytes("$targetDir\template.js")
$templateStr = [System.Text.Encoding]::UTF8.GetString($templateBytes)

$script = $templateStr.Replace("__DB_PLACEHOLDER__", $jsonDb)

# Writing exactly as UTF-8
$utf8NoBom = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllText("$targetDir\Code.gs", $script, $utf8NoBom)
[System.IO.File]::WriteAllText("$targetDir\SyncScript.txt", $script, $utf8NoBom)

Write-Host "Updated Code.gs and SyncScript.txt using pure UTF-8 template."
