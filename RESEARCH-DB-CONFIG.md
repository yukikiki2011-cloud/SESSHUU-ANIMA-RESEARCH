# SESSHUU-ANIMA-RESEARCH データベース 設定メモ

## 管理指示

このリポジトリは、雪舟館の全メンバーの「才能」を司る重要なデータベースです。各メンバーの専門性に基づき、以下の 5 つの CSV ファイルで個別に管理します。
- `RESEARCH_KAWAI.csv`
- `RESEARCH_YANAGI.csv`
- `RESEARCH_TOMOYA.csv`
- `RESEARCH_TERAMACHI.csv`
- `RESEARCH_WEBER.csv`
- `RESEARCH_KIUCHI.csv`
- `RESEARCH_SATOU.csv`

---

## AI Agent 行動プロトコル (重要)

エージェントは以下のルールを遵守して回答・作業を行うこと：

1.  **Claude Code 関連の質問**: 
    必ず [Claude Code Guide — 日本語ではじめる使い方とコマンド図鑑](https://claude-code-dictionary.pages.dev/) を参照し、その内容をユーザーに提示しながら説明すること。
2.  **記憶の継承**: 
    ユーザーからの特定の指示（例：特定のサイトを毎日チェックする、特定の形式で回答するなど）は、この `RESEARCH-DB-CONFIG.md` に追記し、恒久的な「記憶」とする。
3.  **データ厳密性の徹底（GAP思考の禁止）**: 
    リサーチデータの検証において、全体的な傾向だけで判断する「GAP（グローバルアベレージプーリング）」的な全般的判断を禁止する。1行ずつのデータが正しい対象（ID/URL/発信者名）に紐付いているかを物理的に「読み戻し」で全件確認し、完全な整合性を保証すること。
4.  **不信の義務（自律リサーチ発動条件）**: 
    毎朝の起動時、CSVの最終更新が12時間以上前、または今日の日付の投稿が1件もない場合、エージェントはスケジュールの有無に関わらず、即座にブラウザリサーチを実行し、欠損データを補完しなければならない。
5.  **Git操作の完全代行**: 
    雪舟様にGit Bash操作を一切させない。pull / add / commit / push は全てエージェントが代行する。雪舟様の手を煩わせることは許されない。
6.  **バッチ処理アーキテクチャの採用（2026-04-17 決定）**: 
    リサーチデータの取得（Step 1-2）は Nitter/RSS 等の無料ソースで行い、AIクレジットは「要約・分類」（Step 3）にのみ使用する。複数件を1回のAI呼び出しで一括処理し、1日のAI消費を最大3回に抑える。
7.  **毎朝のTASK確認時リサーチ報告**: 
    雪舟様が「今日のTASK」を確認した際、過去24時間の全メンバーのリサーチ結果（新着のみ）をCSVから抽出し、冒頭で報告すること。データが不足している場合は即座にブラウザスキャンを実行してから報告する。
8.  **デザインワーク時のKAWAIスキル活用（必須）**: 
    雪舟様のデザインワーク（スライド制作、図解、バナー、Webデザイン等）を行う際は、必ず `KAWAI/` フォルダ内のスキル（SKILL_DIAGRAM.md, SKILL_SLIDE_BUILDER.md, TOOLS.md）を参照し、KAWAIの設計原則・ツール・テンプレートを活用すること。

---

## データベース・リサーチ対象

| 項目 | 内容 |
|------|------|
| リポジトリ名 | SESSHUU-ANIMA-RESEARCH |
| URL | https://github.com/yukikiki2011-cloud/SESSHUU-ANIMA-RESEARCH |
| 公開設定 | Public |
| **監視対象 (共通)** | [Claude Code Guide](https://claude-code-dictionary.pages.dev/) |
| **監視対象 (KAWAI)** | X (`@kawai_design`), note (`note.com/kawaidesign`), Threads (`@kawai_design_ig`), Voicy |
| **監視対象 (YANAGI)** | X (`@ryonihonyanagi`, `@yanagi_shiftai`) |
| **監視対象 (TOMOYA)** | X (`@AIParaCareer`) |
| **監視対象 (TERAMACHI)** | X (`@tewriter_0327`), note (`note.com/tera684`), `webwriter-school.net` |
| **監視対象 (WEBER)** | X (`@sesshuuX`) |
| **監視対象 (KIUCHI)** | X (`@shota7180`), YouTube (`@shota_kiuchi`) |
| **監視対象 (SATOU)** | X (`@seiichi_satoweb`), note (`note.com/seiichi_sato919`) |

---

## 自動更新スケジュール（v3.1 確定版 2026-04-17）

### 実行スケジュール（JST）

| 時刻 | 対象 | 内容 |
|------|------|------|
| **10:00** | **全メンバー** | 朝スキャン（前夜〜午前の新着） |
| **15:00** | **全メンバー** | 昼スキャン（午前〜午後の新着） |
| **23:00** | **全メンバー** | 夜間バッチ（1日の総括 + Claude Code辞典更新） |
| **23:50** | — | 日報スケジュール（別系統） |

### 処理アーキテクチャ（バッチ処理・クレジット節約型）

```
Step 1: PowerShell が Nitter/RSS から生テキストを無料取得
        → raw_[メンバー名].txt に保存（クレジット: ¥0）

Step 2: CSVの最終投稿IDと比較 → 新着のみ抽出
        → 新着なし → スキップ（クレジット: ¥0）
        → 新着あり → new_posts.txt に保存

Step 3: new_posts.txt をまとめて AI（Flash）に1回だけ投げる
        → CSV形式で要約・分類を返却（クレジット: 1回分のみ）

Step 4: 出力をCSVに追記 → Git Push
```

### 差分スキャンルール

- CSVの最終行の日付が **今日** → そのメンバーは **スキップ**
- CSVの最終行の日付が **昨日以前** → 新着スキャンを実行
- 前回の最終投稿IDを `SYNC_STATE.json` に記録し、重複取得を防止

### エージェント自律発動ルール（フェイルセーフ）

> **CSVの最終行の日付が「今日」でない場合、エージェントはスケジュールの有無に関わらず、即座にブラウザリサーチを実行し、欠損データを補完しなければならない。**
> これは「不信の義務」に基づく絶対命令である。

- トリガーID: `trig_0166rVRMVYRfjSSZtn7mxivN`（※10:00/15:00の新トリガー追加が必要）
- 管理: https://claude.ai/code/scheduled/trig_0166rVRMVYRfjSSZtn7mxivN




---

## データベースのカラム構成（共通）

| カラム | 内容 |
|--------|------|
| メディア | X または note |
| 投稿日（推定） | YYYY-MM-DD形式 |
| タイトル／本文（抜粋） | 投稿タイトルまたは本文冒頭100文字 |
| カテゴリ | デザイン思考/AI/ビジネス/ブランディング/教育/その他 |
| URL | 投稿のURL |
| メモ・要点 | 要点を1〜2文で |
| チェックすべき関連サイト | 投稿内で言及されているサイト・ツール |
| 重要なワード | キーワード（カンマ区切り） |
| 今後深堀すべきポイント | フォローすべき視点・問い |

---

## 自動・手動更新時のGit作業手順

1. `SESSHUU-ANIMA-RESEARCH` リポジトリをcloneまたはpullして最新データを取得
2. データを参照してリサーチ・分析を行う
3. 新しい知見や更新があれば該当する `RESEARCH_○○.csv` に追記してpush

```bash
# 最新データ取得
git clone https://ghp_************************************@github.com/yukikiki2011-cloud/SESSHUU-ANIMA-RESEARCH
cd SESSHUU-ANIMA-RESEARCH

# 更新後に該当ファイルのpush (AI自動更新の場合の例)
git config user.email "ai-research-bot@auto.com"
git config user.name "AI Research Bot"
git add RESEARCH_*.csv
git commit -m "YYYY-MM-DD 更新内容"
git push
```

---

*SESSHUU ANIMA RESEARCH v2.0 / Unified Configuration*
