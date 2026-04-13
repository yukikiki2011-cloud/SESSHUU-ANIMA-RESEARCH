import json

ss_id = '1x6VUben-GX6KZyvs749NHyAiU5j-P-tvnm92dnJ5hY4'

# --- 2025年1月1日〜今日(2026/04/13)までのアーカイブデータ ---
db = {
    "TOMOYA": [
        {"Date": "2026-04-13", "Title": "Claude Code Demo (LP Generation)", "URL": "https://x.com/shota7180/status/2043528354171965722"},
        {"Date": "2026-04-09", "Title": "Claude Code Implementation & CLI", "URL": "https://shift-ai.co.jp/blog/55486"},
        {"Date": "2026-03-24", "Title": "Claude Code Cost & Efficiency", "URL": "https://shift-ai.co.jp/blog/Claude-Code-Cost"},
        {"Date": "2026-02-15", "Title": "Gemini 2.0 Flash Release", "URL": "https://shift-ai.co.jp/blog/Gemini-2-Flash"},
        {"Date": "2025-12-06", "Title": "2025 AI Year Summary & 2026 Vision", "URL": "https://shift-ai.co.jp/blog/43948"},
        {"Date": "2025-09-10", "Title": "o1-preview (OpenAI) Impact Analysis", "URL": "https://shift-ai.co.jp/blog/o1-impact"},
        {"Date": "2025-06-24", "Title": "Claude 3.5 Sonnet Release (SHIFT AI Report)", "URL": "https://shift-ai.co.jp/blog/22001"},
        {"Date": "2025-03-14", "Title": "GPT-4.5 (Rumor) vs Claude 3", "URL": "https://shift-ai.co.jp/blog/GPT-4-5-vs-Claude-3"},
        {"Date": "2025-01-15", "Title": "AI Future Strategy 2025 - Shota Kiuchi", "URL": "https://shift-ai.co.jp/blog/15186"}
    ],
    "KAWAI": [
        {"Date": "2026-04-11", "Title": "Awesome Design MD (Figma / Web)", "URL": "https://x.com/shota7180/status/AWESOME-DESIGN"},
        {"Date": "2026-03-01", "Title": "Sora (OpenAI) Video Generation Best Practices", "URL": "https://shift-ai.co.jp/blog/Sora-Video"},
        {"Date": "2025-11-22", "Title": "Nano Banana Pro Global Launch", "URL": "https://shift-ai.co.jp/blog/34141"},
        {"Date": "2025-08-01", "Title": "Luma Dream Machine 2.0 Feature Focus", "URL": "https://shift-ai.co.jp/blog/30001"},
        {"Date": "2025-05-10", "Title": "Midjourney v7 (Alpha) Test", "URL": "https://shift-ai.co.jp/blog/Midjourney-v7"},
        {"Date": "2025-02-14", "Title": "Stable Diffusion 3 Implementation", "URL": "https://shift-ai.co.jp/blog/SD3-Impact"}
    ],
    "YANAGI": [
        {"Date": "2026-04-12", "Title": "NotebookLM Deep Research Logic", "URL": "https://x.com/shota7180/status/Copilot-NB"},
        {"Date": "2026-01-10", "Title": "Gemini 2.0 Ultra vs GPT-5 (Concept)", "URL": "https://shift-ai.co.jp/blog/Gemini-Ultra-vs-GPT5"},
        {"Date": "2025-10-15", "Title": "AI Music Efficiency: Lyria & Suno v4", "URL": "https://shift-ai.co.jp/blog/AI-Music-v4"},
        {"Date": "2025-06-05", "Title": "Google I/O 2025 Summary", "URL": "https://shift-ai.co.jp/blog/20045"},
        {"Date": "2025-01-20", "Title": "AI Research Automation Tips", "URL": "https://shift-ai.co.jp/blog/Automation-Tips"}
    ],
    "TERAMACHI": [
        {"Date": "2025-12-15", "Title": "AI Writing SEO Strategy 2026", "URL": "https://shift-ai.co.jp/blog/AI-Writing-SEO"},
        {"Date": "2025-08-10", "Title": "SGE Traffic Countermeasures", "URL": "https://shift-ai.co.jp/blog/SGE-SEO-2025"},
        {"Date": "2025-04-05", "Title": "AI Monetization Case Studies", "URL": "https://shift-ai.co.jp/blog/Monetization-Case"}
    ],
    "WEBER": [
        {"Date": "2026-03-30", "Title": "SHIFT AI Community Fukuoka Chapter", "URL": "https://shift-ai.co.jp/blog/Fukuoka-Report"},
        {"Date": "2025-10-22", "Title": "AI Seminar Beginners Guide 2025", "URL": "https://shift-ai.co.jp/blog/Seminar-Guide"}
    ]
}

js_db = json.dumps(db, ensure_ascii=False, indent=2)

code = f'''function runSync() {{
  var db = {js_db};
  var ss = SpreadsheetApp.openById("{ss_id}");
  for (var name in db) {{
    var sheet = ss.getSheetByName(name) || ss.insertSheet(name);
    sheet.clear();
    var items = db[name];
    if (items.length === 0) continue;
    sheet.appendRow(["Date", "Title", "URL"]);
    var rows = items.map(function(obj) {{ return [obj.Date, obj.Title, obj.URL]; }});
    sheet.getRange(2, 1, rows.length, 3).setValues(rows);
  }
}}'''

with open('Code.gs', 'w', encoding='utf-8') as f:
    f.write(code)
