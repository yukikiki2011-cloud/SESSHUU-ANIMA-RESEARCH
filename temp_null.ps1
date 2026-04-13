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
$jsonDb = [System.Text.RegularExpressions.Regex]::Replace($jsonDb, "(?i)\\u([0-9a-f]{4})", { param($m) [char][int]::Parse($m.Groups[1].Value, [System.Globalization.NumberStyles]::HexNumber) })

# Load actual JS file without the garbled string block, use the exact one
$script = @"
function runSync() {
  var db = $jsonDb;
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  for(var sheetName in db) {
    var dataObjs = db[sheetName];
    if(!dataObjs || dataObjs.length === 0) continue;
    
    if(!Array.isArray(dataObjs)) {
        dataObjs = [dataObjs];
    }
    
    var firstObj = dataObjs[0];
    var keys = [
      "メディア",
      "投稿日（推定）",
      "タイトル／本文（抜粋）",
      "カテゴリ",
      "URL",
      "メモ・要点",
      "チェックすべき関連サイト",
      "重要なワード",
      "今後深堀すべきポイント"
    ];
    
    var actualKeys = Object.keys(firstObj);
    if (actualKeys.length !== keys.length) {
        keys = actualKeys;
    }

    var data = [keys];
    for(var i=0; i<dataObjs.length; i++){
      var obj = dataObjs[i];
      var row = [];
      for(var k=0; k<keys.length; k++){
        row.push(obj[keys[k]] || "");
      }
      data.push(row);
    }
    var sheet = ss.getSheetByName(sheetName);
    if(sheet) {
      sheet.clear();
      sheet.getRange(1, 1, data.length, data[0].length).setValues(data);
    }
  }
}
"@

# The HEREDOC string $script gets garbled because of powershell parsing it. 
# So we need to put it in a separate template file and replace it, or read it strictly.
"@ | Out-Null
