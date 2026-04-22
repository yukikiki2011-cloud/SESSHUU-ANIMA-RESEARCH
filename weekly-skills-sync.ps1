# weekly-skills-sync.ps1
# 半自動リサーチ → SKILLS.md更新パイプライン
# 実行: 毎週月曜 10:00（Windowsタスクスケジューラから起動）
# 設計: TOMOYA確定 / Snow実装 / KURO品質ゲート / 代表承認 2026-04-22

$repoRoot      = "$env:USERPROFILE\Documents\GitHub"
$animaRepo     = "$repoRoot\sesshuu-anima"
$researchRepo  = "$repoRoot\SESSHUU-ANIMA-RESEARCH"
$logFile       = "$researchRepo\weekly-skills-sync-log.txt"
$proposalFile  = "$animaRepo\SNOW\MINUTES\weekly-skills-$(Get-Date -Format 'yyyy-MM-dd').md"

function Write-Log($msg) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm"
    "$ts | $msg" | Tee-Object -FilePath $logFile -Append | Write-Host
}

# --- 振り分けルール（TOMOYA定義 2026-04-22） ---
$routingRules = @(
    @{ Keywords = @("デザイン","ビジュアル","画像生成","サムネ","フォント","配色","CARP","Canva","MiriCanvas","Figma"); Member = "KAWAI" },
    @{ Keywords = @("エージェント","Web","開発","GitHub","API","Claude Code","プログラム","スクリプト","自動化"); Member = "YANAGI" },
    @{ Keywords = @("経営","コミュニティ","マーケ","集客","SNS","YouTube","メディア","スケール"); Member = "KIUCHI" },
    @{ Keywords = @("SEO","コンテンツ","ライティング","記事","ブログ","キーワード","検索"); Member = "TERAMACHI" },
    @{ Keywords = @("戦略","組織","教育","AI教育","ロードマップ","キャリア","研修"); Member = "TOMOYA" }
)

function Get-RoutingMember($text) {
    $scores = @{}
    foreach ($rule in $routingRules) {
        $count = 0
        foreach ($kw in $rule.Keywords) {
            if ($text -match [regex]::Escape($kw)) { $count++ }
        }
        if ($count -gt 0) { $scores[$rule.Member] = $count }
    }
    if ($scores.Count -eq 0) { return "SNOW（振り分け不能・要確認）" }
    return ($scores.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Key
}

Write-Log "=== weekly-skills-sync 開始 ==="

# --- STEP 1: リポジトリ最新化 ---
Write-Log "STEP1: git pull"
git -C $researchRepo pull origin main --quiet
git -C $animaRepo pull origin master --quiet

# --- STEP 2: RESEARCH_SHIFTAI_BLOG.csv の未処理行を検出 ---
$blogCsv = "$researchRepo\RESEARCH_SHIFTAI_BLOG.csv"
$proposals = @()

if (Test-Path $blogCsv) {
    $rows = [System.IO.File]::ReadAllLines($blogCsv, [System.Text.Encoding]::UTF8)
    $header = $rows[0]
    $newRows = $rows | Select-Object -Skip 1 | Where-Object {
        $_ -ne "" -and $_ -notmatch "^#"
    }

    foreach ($row in $newRows) {
        $cols = $row -split ","
        if ($cols.Count -lt 3) { continue }
        $title   = $cols[2]
        $memo    = if ($cols.Count -ge 6) { $cols[5] } else { "" }
        $text    = "$title $memo"
        $member  = Get-RoutingMember $text
        $proposals += [PSCustomObject]@{
            行     = $row
            タイトル = $title
            振り分け = $member
        }
    }
    Write-Log "STEP2: $($proposals.Count) 件の候補を検出"
} else {
    Write-Log "STEP2: RESEARCH_SHIFTAI_BLOG.csv が見つかりません → スキップ"
}

# --- STEP 3: KURO審査用 提案ファイルを生成 ---
$md = @"
# SKILLS更新候補レポート — $(Get-Date -Format 'yyyy-MM-dd')
**生成: weekly-skills-sync.ps1 / Snow自動生成**
**次のアクション: KUROが品質ゲートを実行 → 承認後Snowが SKILLS.md更新**

---

## 振り分け候補一覧

| タイトル（抜粋） | 振り分け先 |
|---|---|
"@

foreach ($p in $proposals) {
    $t = if ($p.タイトル.Length -gt 40) { $p.タイトル.Substring(0,40) + "…" } else { $p.タイトル }
    $md += "| $t | $($p.振り分け) |`n"
}

$md += @"

---

## KURO品質ゲート（要確認）

- [ ] ソースが1件のみの情報はないか
- [ ] 役職・ポジション変更を伴う更新はないか
- [ ] 削除を伴う更新はないか

**合格 → Snowが SKILLS.md更新 → git push**
**差し戻し → 理由を記載してSnowへ返却**

---
*Snow 自動生成 $(Get-Date -Format 'yyyy-MM-dd HH:mm')*
"@

[System.IO.File]::WriteAllText($proposalFile, $md, [System.Text.Encoding]::UTF8)
Write-Log "STEP3: 提案ファイル生成 → $proposalFile"

Write-Log "=== weekly-skills-sync 完了 — KUROの審査を待ちます ==="
