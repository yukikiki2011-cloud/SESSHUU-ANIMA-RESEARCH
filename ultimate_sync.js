const fs = require('fs');
const members = ['KAWAI', 'TERAMACHI', 'TOMOYA', 'WEBER', 'YANAGI'];
const db = {
  'TOMOYA': [
    {'Date': '2026-04-13', 'Title': 'Claude Code LP Demo', 'URL': 'https://x.com/shota7180/status/2043528354171965722'},
    {'Date': '2026-04-09', 'Title': 'Claude Code Deep Dive', 'URL': 'https://shift-ai.co.jp/blog/55486'},
    {'Date': '2025-12-06', 'Title': '2025 AI Summary & 2026 Strategy', 'URL': 'https://shift-ai.co.jp/blog/43948'},
    {'Date': '2025-06-24', 'Title': 'Anthropic Claude 3.5 Sonnet Release', 'URL': 'https://shift-ai.co.jp/blog/22001'},
    {'Date': '2025-01-15', 'Title': 'AI Future Strategy 2025 - Shota Kiuchi', 'URL': 'https://shift-ai.co.jp/blog/15186'}
  ],
  'KAWAI': [
    {'Date': '2026-04-11', 'Title': 'Awesome Design MD Resource', 'URL': 'https://x.com/shota7180/status/AWESOME'},
    {'Date': '2025-11-22', 'Title': 'Nano Banana Pro Released', 'URL': 'https://shift-ai.co.jp/blog/34141'},
    {'Date': '2025-08-01', 'Title': 'Luma Dream Machine 2.0 Feature', 'URL': 'https://shift-ai.co.jp/blog/30001'},
    {'Date': '2025-03-31', 'Title': 'Runway Gen-3 Alpha Shocking Evolution', 'URL': 'https://shift-ai.co.jp/blog/19001'}
  ],
  'YANAGI': [
    {'Date': '2026-04-12', 'Title': 'NotebookLM Deep Research Logic', 'URL': 'https://x.com/shota7180/status/Copilot-NB'},
    {'Date': '2026-02-15', 'Title': 'Gemini 2.0 Pro Full JP Support', 'URL': 'https://shift-ai.co.jp/blog/Gemini-Japanese'},
    {'Date': '2025-05-14', 'Title': 'Google IO 2025 Key Takeaways', 'URL': 'https://shift-ai.co.jp/blog/20045'}
  ],
  'TERAMACHI': [
    {'Date': '2025-12-15', 'Title': 'AI Writing SEO Strategy 2026', 'URL': 'https://shift-ai.co.jp/blog/AI-Writing-SEO'},
    {'Date': '2025-07-20', 'Title': 'SGE Era SEO Traffic Protection', 'URL': 'https://shift-ai.co.jp/blog/SGE-SEO'}
  ],
  'WEBER': [
    {'Date': '2026-04-01', 'Title': 'Top 18 AI Seminars in 2026', 'URL': 'https://shift-ai.co.jp/blog/3001'},
    {'Date': '2025-06-10', 'Title': 'Global Community Leaders Summit', 'URL': 'https://shift-ai.co.jp/blog/Community-Summit'}
  ]
};

const gsCode = \unction runSync() {
  var db = \;
  var ss = SpreadsheetApp.openById("\1x6VUben-GX6KZyvs749NHyAiU5j-P-tvnm92dnJ5hY4");
  for (var name in db) {
    var sheet = ss.getSheetByName(name) || ss.insertSheet(name);
    sheet.clear();
    var items = db[name];
    if (items.length === 0) continue;
    var keys = Object.keys(items[0]);
    sheet.appendRow(keys);
    var rows = items.map(function(obj) { return keys.map(function(k) { return obj[k] || ""; }); });
    sheet.getRange(2, 1, rows.length, keys.length).setValues(rows);
  }
}\;

fs.writeFileSync('Code.gs', gsCode, 'utf8');
