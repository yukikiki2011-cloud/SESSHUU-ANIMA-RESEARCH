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

## 自動更新スケジュール

| 時刻 | 内容 |
|------|------|
| **23:00 JST** | リサーチ実行（全メンバーの新着投稿 + Claude Code 辞典更新） |
| **23:50 JST** | 日報スケジュール（別系統、競合回避のため固定） |
| **00:30 JST** | 実行完了の再確認コマンド実行（リサーチ＋日報の完了を確認） |

- トリガーID: `trig_0166rVRMVYRfjSSZtn7mxivN`
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
