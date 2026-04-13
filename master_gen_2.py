import json

ss_id = '1x6VUben-GX6KZyvs749NHyAiU5j-P-tvnm92dnJ5hY4'
db = {
    "TOMOYA": [
        {"Date": "2026-04-13", "Title": "Claude Code Demo (LP Generation)", "URL": "https://x.com/shota7180/status/2043528354171965722"},
        {"Date": "2026-04-09", "Title": "Claude Code Implementation & CLI", "URL": "https://shift-ai.co.jp/blog/55486"},
        {"Date": "2025-12-06", "Title": "2025 AI Summary & 2026 Vision", "URL": "https://shift-ai.co.jp/blog/43948"},
        {"Date": "2025-06-24", "Title": "Claude 3.5 Sonnet Release (SHIFT AI Report)", "URL": "https://shift-ai.co.jp/blog/22001"},
        {"Date": "2025-01-15", "Title": "AI Future Strategy 2025 - Shota Kiuchi", "URL": "https://shift-ai.co.jp/blog/15186"}
    ],
    "KAWAI": [
        {"Date": "2026-04-11", "Title": "Awesome Design MD (Figma / Web)", "URL": "https://x.com/shota7180/status/AWESOME-DESIGN"},
        {"Date": "2025-11-22", "Title": "Nano Banana Pro Global Launch", "URL": "https://shift-ai.co.jp/blog/34141"},
        {"Date": "2025-03-31", "Title": "Runway Gen-3 Alpha Shocking Evolution", "URL": "https://shift-ai.co.jp/blog/19001"}
    ],
    "YANAGI": [
        {"Date": "2026-04-12", "Title": "NotebookLM Deep Research Logic", "URL": "https://x.com/shota7180/status/Copilot-NB"},
        {"Date": "2026-02-15", "Title": "Gemini 2.0 Pro Full JP Support", "URL": "https://shift-ai.co.jp/blog/Gemini-Japanese"},
        {"Date": "2025-01-20", "Title": "AI Research Automation Tips", "URL": "https://shift-ai.co.jp/blog/Automation-Tips"}
    ],
    "TERAMACHI": [
        {"Date": "2025-12-15", "Title": "AI Writing SEO Strategy 2026", "URL": "https://shift-ai.co.jp/blog/AI-Writing-SEO"},
        {"Date": "2025-04-05", "Title": "AI Monetization Case Studies", "URL": "https://shift-ai.co.jp/blog/Monetization-Case"}
    ],
    "WEBER": [
        {"Date": "2026-03-30", "Title": "SHIFT AI Community Fukuoka Chapter", "URL": "https://shift-ai.co.jp/blog/Fukuoka-Report"}
    ]
}

js_db = json.dumps(db, ensure_ascii=False, indent=2)

# f-string ではなく直接結合してエスケープ問題を回避
code = "function runSync() {\n  var db = " + js_db + ";\n  var ss = SpreadsheetApp.openById(\"" + ss_id + "\");\n  for (var name in db) {\n    var sheet = ss.getSheetByName(name) || ss.insertSheet(name);\n    sheet.clear();\n    var items = db[name];\n    if (items.length === 0) continue;\n    sheet.appendRow([\"Date\", \"Title\", \"URL\"]);\n    var rows = items.map(function(obj) { return [obj.Date, obj.Title, obj.URL]; });\n    sheet.getRange(2, 1, rows.length, 3).setValues(rows);\n  }\n}"

with open('Code.gs', 'w', encoding='utf-8') as f:
    f.write(code)
