# SESSHUU-ANIMA-RESEARCH データベース 設定メモ

## AI社員KAWAIへの指示

このリポジトリ（KAWAI プライベート）で作業する際、リサーチデータは以下の**公開データベースリポジトリ**を参照・更新してください。

---

## データベースリポジトリ

| 項目 | 内容 |
|------|------|
| リポジトリ名 | SESSHUU-ANIMA-RESEARCH |
| URL | https://github.com/yukikiki2011-cloud/SESSHUU-ANIMA-RESEARCH |
| 公開設定 | Public |
| メインファイル | `RESEARCH_KAWAI.csv` |

---

## アクセス認証（GitHub PAT）

```
ghp_************************************
```

git操作時はこのトークンを使用してください：

```bash
git clone https://ghp_************************************@github.com/yukikiki2011-cloud/SESSHUU-ANIMA-RESEARCH
```

---

## データベースのカラム構成

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

## 自動更新スケジュール

毎日 **23:00 JST** にリモートエージェントが自動でKAWAI（川合卓也 / @kawai_design）の新着投稿をリサーチして追記します。

- トリガーID: `trig_0166rVRMVYRfjSSZtn7mxivN`
- 管理: https://claude.ai/code/scheduled/trig_0166rVRMVYRfjSSZtn7mxivN

---

## AI社員KAWAIが作業する際の手順

1. `RESEARCH_KAWAI.csv` をcloneまたはpullして最新データを取得
2. データを参照してリサーチ・分析を行う
3. 新しい知見や更新があれば追記してpush

```bash
# 最新データ取得
git clone https://ghp_************************************@github.com/yukikiki2011-cloud/SESSHUU-ANIMA-RESEARCH
cd SESSHUU-ANIMA-RESEARCH

# 更新後にpush
git config user.email "kawai-research-bot@auto.com"
git config user.name "KAWAI Research Bot"
git add RESEARCH_KAWAI.csv
git commit -m "YYYY-MM-DD 更新内容"
git push
```
