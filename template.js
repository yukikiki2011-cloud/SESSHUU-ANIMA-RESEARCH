function runSync() {
  var db = __DB_PLACEHOLDER__;
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
        row.push(obj[keys[k]] || " ");
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