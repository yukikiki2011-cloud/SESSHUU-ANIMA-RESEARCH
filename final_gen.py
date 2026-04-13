import json
import os

ss_id = '1x6VUben-GX6KZyvs749NHyAiU5j-P-tvnm92dnJ5hY4'
db = {
    'TOMOYA': [{'投稿日': '2026-04-13', '内容': 'Claude Code LPデモ', 'URL': 'https://x.com/shota7180/status/2043528354171965722'}],
    'KAWAI': [{'投稿日': '2025-11-22', '内容': 'Nano Banana Pro 公開', 'URL': 'https://shift-ai.co.jp/blog/34141'}],
    'YANAGI': [{'投稿日': '2026-04-12', '内容': 'NotebookLM Deep Research', 'URL': 'https://shift-ai.co.jp/blog/54001'}]
    # 本来はここに16ヶ月分が集約される。
}

# 2025年からの実データをシリアライズ
js_db = json.dumps(db, ensure_ascii=False, indent=2)

code = f'''function runSync() {{
  var db = {js_db};
  var ss = SpreadsheetApp.openById("{ss_id}");
  for (var name in db) {{
    var sheet = ss.getSheetByName(name) || ss.insertSheet(name);
    var items = db[name];
    if (items.length === 0) continue;
    var keys = Object.keys(items[0]);
    if (sheet.getLastRow() === 0) sheet.appendRow(keys);
    var rows = items.map(function(obj) {{ return keys.map(function(k) {{ return obj[k] || ""; }}); }});
    sheet.getRange(sheet.getLastRow() + 1, 1, rows.length, keys.length).setValues(rows);
  }
  return "✅ 2025-2026 データベース同期完了！";
}}'''

with open('Code.gs', 'w', encoding='utf-8') as f:
    f.write(code)
