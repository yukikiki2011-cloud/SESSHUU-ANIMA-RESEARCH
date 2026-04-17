# SESSHUU-ANIMA 自律同期・リサーチスクリプト v2.0
# 役割: 深夜の同期漏れを物理的に解消し、常に最新のX投稿をデータベースに反映する。

$Targets = @(
    @{ Name = "KAWAI"; X_ID = "@kawai_design"; CSV = "RESEARCH_KAWAI.csv" },
    @{ Name = "KIUCHI"; X_ID = "@shota7180"; CSV = "RESEARCH_KIUCHI.csv" }
)

Write-Host "--- SESSHUU-ANIMA 自律同期開始 ---" -ForegroundColor Cyan

# 1. 最新リポジトリの取得
git pull origin main

# 2. 差分リサーチ（エージェントによる物理スキャンを促すトリガー）
foreach ($T in $Targets) {
    $LastDate = (Import-Csv $T.CSV | Select-Object -Last 1).Date
    $Today = Get-Date -Format "yyyy-MM-dd"
    
    if ($LastDate -ne $Today) {
        Write-Host "[!] ALERT: $($T.Name) のデータが最新ではありません（最終行: $LastDate）" -ForegroundColor Yellow
        Write-Host "エージェント（Antigravity）による直接スキャンが必要不可欠です。"
        # ここでエージェントに対する「強制スキャンの指示」をログに出力
        "REBUILD_REQUIRED: $($T.Name) is stale since $LastDate" | Out-File -Append "SYNC_LOG.txt"
    } else {
        Write-Host "[OK] $($T.Name) は最新の状態です。" -ForegroundColor Green
    }
}

# 3. データのPush
git add .
git commit -m "Auto-Sync: Verification by $env:COMPUTERNAME at $(Get-Date)"
git push origin main

Write-Host "--- 全PC同期 完了 ---" -ForegroundColor Cyan
