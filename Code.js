/**
 * SHIFT GAS - GAS Execution Engine
 *
 * CLIから clasp run で直接実行するためのエンジン
 * Google OAuth 2.0 による認証でセキュア
 */

/**
 * 任意のGASコードを実行
 * @param {string} code - 実行するJavaScriptコード
 * @returns {Object} 実行結果
 */
function executeScript(code) {
  try {
    var startTime = Date.now();
    var func = new Function(code);
    var result = func();
    var executionTime = Date.now() - startTime;

    return {
      success: true,
      result: result,
      executionTime: executionTime
    };
  } catch (error) {
    return {
      success: false,
      error: error.message,
      stack: error.stack
    };
  }
}

/**
 * 接続テスト（全サービスのスコープをトリガーするための参照を含む）
 * @returns {Object} テスト結果
 */
function testConnection() {
  SpreadsheetApp;
  DriveApp;
  GmailApp;
  CalendarApp;
  DocumentApp;
  FormApp;
  SlidesApp;
  return {
    success: true,
    message: 'SHIFT GAS is working!',
    timestamp: new Date().toISOString()
  };
}

/**
 * 利用可能なサービス一覧を取得
 * @returns {Object} サービス一覧
 */
function listAvailableServices() {
  return {
    success: true,
    services: [
      { name: 'GmailApp', description: 'Gmail操作（送信、検索、下書き）' },
      { name: 'CalendarApp', description: 'カレンダー操作（予定作成、取得）' },
      { name: 'DriveApp', description: 'Googleドライブ操作（ファイル管理）' },
      { name: 'SpreadsheetApp', description: 'スプレッドシート操作' },
      { name: 'DocumentApp', description: 'Googleドキュメント操作' },
      { name: 'FormApp', description: 'Googleフォーム操作' },
      { name: 'SlidesApp', description: 'Googleスライド操作' },
      { name: 'YouTube', description: 'YouTube Data API' },
      { name: 'UrlFetchApp', description: 'HTTP リクエスト' },
      { name: 'Utilities', description: 'ユーティリティ関数' }
    ]
  };
}
