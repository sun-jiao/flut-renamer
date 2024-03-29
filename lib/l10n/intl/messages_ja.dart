// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ja';

  static String m0(prefix) => "増分：${prefix}-インデックス";

  static String m1(toEnd, ordinal, insert, insertIndex) =>
      "挿入：${Intl.select(toEnd, {
            'true': '末尾から',
            'false': '',
            'other': '',
          })}第${insertIndex}文字に「${insert}」を挿入します。";

  static String m2(delimiter, order) => "並べ替え：区切り文字：${delimiter}、順序：${order}。";

  static String m3(targetString) => "削除：「${targetString}」";

  static String m4(targetString, replacementString) =>
      "置換：「${targetString}」を「${replacementString}」に置換します。";

  static String m5(toEnd) => "開始から終わりまでの数え方を切り替え、現在は${Intl.select(toEnd, {
            'true': '終わり',
            'false': '始まり',
            'other': '',
          })}から数えています";

  static String m6(value) =>
      "これはドロップダウンボタンです。現在選択されているのは「${value}」です。ダブルクリックしてドロップダウンボタンを開き、別の値を選択します。";

  static String m7(last) => "最終更新日は${last}です。";

  static String m8(last, size) => "最終更新日は${last}、ファイルサイズは${size}です。";

  static String m9(entityType, selectStatus, filename) =>
      "${Intl.select(selectStatus, {
            'true': '選択中の',
            'false': '選択されていない',
            'other': '',
          })}${Intl.select(entityType, {
            'File': 'ファイル',
            'Directory': 'ディレクトリ',
            'Link': 'リンク',
            'other': 'ファイルシステムオブジェクト',
          })}、ファイル名は${filename}、";

  static String m10(type) => "転写：${type}。";

  static String m11(langName, type) => "転写：${type}：${langName}。";

  static String m12(iTwoToEnd, iOneOrdinal, iOneToEnd, iTwoOrdinal, keepType,
          iOne, iTwo) =>
      "切り詰め：${Intl.select(keepType, {
            'true': '保持する',
            'false': '削除する',
            'other': '',
          })}${Intl.select(iOneToEnd, {
            'true': '末尾から',
            'false': '',
            'other': '',
          })}第${iOne}文字から${Intl.select(iTwoToEnd, {
            'true': '末尾から',
            'false': '',
            'other': '',
          })}第${iTwo}文字までの内容。";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutContent": MessageLookupByLibrary.simpleMessage(
            "このアプリはファイルのリネームを支援するためのものです。Flutterフレームワークを使用して開発されており、他のオペレーティングシステムでも使用できます。完全にオープンソースであり、レビューおよび貢献が可能です。"),
        "add": MessageLookupByLibrary.simpleMessage("追加"),
        "addFile": MessageLookupByLibrary.simpleMessage("ファイルを追加"),
        "addFiles": MessageLookupByLibrary.simpleMessage("ファイルを追加してください。"),
        "addRule": MessageLookupByLibrary.simpleMessage("ルールを追加"),
        "androidRemindContent": MessageLookupByLibrary.simpleMessage(
            "Flut Renamerを使用すると、ファイルだけでなくディレクトリも名前を変更できます。ディレクトリを長押しして選択し、左上隅のドロップダウンボタンから「ファイルとディレクトリ」を選択してディレクトリの名前を変更できます。セキュリティ上の理由から、一部のシステム予約ディレクトリは選択できません。"),
        "androidRemindTitle":
            MessageLookupByLibrary.simpleMessage("ディレクトリのリネーム"),
        "appError": MessageLookupByLibrary.simpleMessage("アプリケーションエラー"),
        "appInfo": MessageLookupByLibrary.simpleMessage("アプリ情報"),
        "appName": MessageLookupByLibrary.simpleMessage("Flut Renamer"),
        "bg": MessageLookupByLibrary.simpleMessage("ブルガリア語"),
        "cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
        "cancelAll": MessageLookupByLibrary.simpleMessage("すべてキャンセル"),
        "caseSensitive": MessageLookupByLibrary.simpleMessage("大文字と小文字を区別する"),
        "collapseOptions": MessageLookupByLibrary.simpleMessage("オプションを折りたたむ"),
        "currentName": MessageLookupByLibrary.simpleMessage("現在のファイル名"),
        "descriptionIncrement": MessageLookupByLibrary.simpleMessage(
            "ファイル名を増分します。例：写真-1、写真-2、写真-3。"),
        "descriptionInsert": MessageLookupByLibrary.simpleMessage(
            "指定された位置に指定されたテキスト（またはファイルメタデータおよびEXIFデータ）を挿入します。"),
        "descriptionRearrange": MessageLookupByLibrary.simpleMessage(
            "ファイル名を指定された区切り文字で分割し、提供された順序に従って並べ替えます。"),
        "descriptionRemove": MessageLookupByLibrary.simpleMessage(
            "指定されたテキスト（または提供された正規表現に一致するテキスト）をファイル名から削除します。"),
        "descriptionReplace": MessageLookupByLibrary.simpleMessage(
            "指定されたテキスト（またはファイルメタデータおよびEXIFデータ）を指定されたテキスト（または提供された正規表現に一致するテキスト）で置換します。"),
        "descriptionTransliterate": MessageLookupByLibrary.simpleMessage(
            "指定された仕様に従って文字を変換します。大文字や小文字への変換、異なる文字バリアントへの変換、別の文字体系への変換などが含まれます。"),
        "descriptionTruncate": MessageLookupByLibrary.simpleMessage(
            "ファイル名の指定された部分を削除または保持し、指定された位置から別の指定された位置までの内容を取得します。"),
        "directories": MessageLookupByLibrary.simpleMessage("ディレクトリ"),
        "doNotRemindAgain": MessageLookupByLibrary.simpleMessage("今後表示しない"),
        "dragNotSupported": MessageLookupByLibrary.simpleMessage(
            "システムのセキュリティ制限により、このアプリからのファイルのドラッグ＆ドロップはサポートされていません。"),
        "dragToAdd": MessageLookupByLibrary.simpleMessage(
            "追加するためにファイルをドラッグ＆ドロップしてください。"),
        "dropToAdd":
            MessageLookupByLibrary.simpleMessage("ここにファイルをドロップして追加してください。"),
        "errorDetails": MessageLookupByLibrary.simpleMessage("エラーの詳細"),
        "exit": MessageLookupByLibrary.simpleMessage("終了"),
        "exitContent": MessageLookupByLibrary.simpleMessage(
            "外部ストレージの管理権限は、デバイスに保存されているファイルにアクセスしてリネームするために必要です。この許可がない場合、アプリはファイルの完全なパスにアクセスできないため、リネーム操作を行うことができません。設定ページに移動して、手動で権限を付与してください。そうしないと、サービスを提供できません。"),
        "exitTitle": MessageLookupByLibrary.simpleMessage("外部ストレージにアクセスできません"),
        "expandOptions": MessageLookupByLibrary.simpleMessage("オプションを展開する"),
        "fileAlreadyExists":
            MessageLookupByLibrary.simpleMessage("ファイル名がすでに存在します"),
        "fileCreateDate": MessageLookupByLibrary.simpleMessage("ファイル作成日"),
        "fileCreateTime": MessageLookupByLibrary.simpleMessage("ファイル作成時間"),
        "fileManagerBackButton": MessageLookupByLibrary.simpleMessage("戻る"),
        "fileManagerSaveButton":
            MessageLookupByLibrary.simpleMessage("選択したファイルをリストに追加"),
        "fileManagerSortButton":
            MessageLookupByLibrary.simpleMessage("ファイルの並べ替え"),
        "fileManagerStorageButton":
            MessageLookupByLibrary.simpleMessage("ストレージの選択"),
        "fileModifyDate": MessageLookupByLibrary.simpleMessage("ファイル変更日"),
        "fileModifyTime": MessageLookupByLibrary.simpleMessage("ファイル変更時間"),
        "fileNotExist": MessageLookupByLibrary.simpleMessage("ファイルが存在しません"),
        "fileSize": MessageLookupByLibrary.simpleMessage("ファイルサイズ"),
        "fileSortDate": MessageLookupByLibrary.simpleMessage("日付"),
        "fileSortName": MessageLookupByLibrary.simpleMessage("名前"),
        "fileSortSize": MessageLookupByLibrary.simpleMessage("サイズ"),
        "fileSortType": MessageLookupByLibrary.simpleMessage("タイプ"),
        "files": MessageLookupByLibrary.simpleMessage("ファイル"),
        "filesDirs": MessageLookupByLibrary.simpleMessage("ファイルとディレクトリ"),
        "filter": MessageLookupByLibrary.simpleMessage("フィルター"),
        "fromStart": MessageLookupByLibrary.simpleMessage("先頭から"),
        "goingForward": MessageLookupByLibrary.simpleMessage("前進中"),
        "ifFileNotShown": MessageLookupByLibrary.simpleMessage(
            "ファイルがリストに表示されない場合は、すべてクリアして続行してください。"),
        "ignoreExtension": MessageLookupByLibrary.simpleMessage("拡張子を無視"),
        "increment": MessageLookupByLibrary.simpleMessage("増加"),
        "incrementToString": m0,
        "indexIncrementalStep":
            MessageLookupByLibrary.simpleMessage("インデックスの増分ステップ"),
        "indexOne": MessageLookupByLibrary.simpleMessage("位置1"),
        "indexTwo": MessageLookupByLibrary.simpleMessage("位置2"),
        "insert": MessageLookupByLibrary.simpleMessage("挿入"),
        "insertBeforeIndex": MessageLookupByLibrary.simpleMessage("指定位置の前に挿入"),
        "insertIndex": MessageLookupByLibrary.simpleMessage("挿入位置"),
        "insertTagInsideAnother":
            MessageLookupByLibrary.simpleMessage("他のタグ内にタグを挿入しないでください。"),
        "insertToString": m1,
        "insertedText": MessageLookupByLibrary.simpleMessage("挿入するテキスト"),
        "iosRemindContent": MessageLookupByLibrary.simpleMessage(
            "iOSでファイルを選択するには、まずファイルが含まれているフォルダを選択します。次に、選択したフォルダからファイルを選択します。iOSの制限のため、これらの2つのステップが必要で、安全なファイルアクセスが確保されます。さあ、始めましょう！"),
        "iosRemindTitle":
            MessageLookupByLibrary.simpleMessage("iOSでのファイル選択について"),
        "isRegex": MessageLookupByLibrary.simpleMessage("正規表現を使用"),
        "keepCharacters": MessageLookupByLibrary.simpleMessage("両方の文字を保持"),
        "language": MessageLookupByLibrary.simpleMessage("言語："),
        "limit": MessageLookupByLibrary.simpleMessage("回数制限"),
        "lowercaseAppName":
            MessageLookupByLibrary.simpleMessage("flut renamer"),
        "me": MessageLookupByLibrary.simpleMessage("モンテネグロ語"),
        "metadataParserNotProvided": MessageLookupByLibrary.simpleMessage(
            "メタデータタグが含まれていますが、メタデータパーサーが提供されていません。"),
        "metadataTags": MessageLookupByLibrary.simpleMessage("メタデータタグ"),
        "mk": MessageLookupByLibrary.simpleMessage("マケドニア語"),
        "mn": MessageLookupByLibrary.simpleMessage("モンゴル語"),
        "musicAlbumArtist": MessageLookupByLibrary.simpleMessage("アルバムアーティスト名"),
        "musicAlbumLength": MessageLookupByLibrary.simpleMessage("アルバム内の曲数"),
        "musicAlbumName": MessageLookupByLibrary.simpleMessage("アルバム名"),
        "musicAuthor": MessageLookupByLibrary.simpleMessage("曲の作者"),
        "musicDiscNumber": MessageLookupByLibrary.simpleMessage("ディスク番号"),
        "musicGenres": MessageLookupByLibrary.simpleMessage("曲のジャンル"),
        "musicTrackArtist": MessageLookupByLibrary.simpleMessage("曲のアーティスト名"),
        "musicTrackDuration": MessageLookupByLibrary.simpleMessage("曲の再生時間"),
        "musicTrackName": MessageLookupByLibrary.simpleMessage("曲名"),
        "musicTrackNumber": MessageLookupByLibrary.simpleMessage("曲のトラック番号"),
        "musicWriter": MessageLookupByLibrary.simpleMessage("曲の作詞者"),
        "musicYear": MessageLookupByLibrary.simpleMessage("曲の発売年"),
        "newName": MessageLookupByLibrary.simpleMessage("新しいファイル名"),
        "noSysDir":
            MessageLookupByLibrary.simpleMessage("システム予約ディレクトリはリネームしないでください。"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "omitDash": MessageLookupByLibrary.simpleMessage("ダッシュを省略"),
        "onlySelected": MessageLookupByLibrary.simpleMessage("選択したファイルのみリネーム"),
        "osNowTime": MessageLookupByLibrary.simpleMessage("現在の時刻"),
        "osTodayDate": MessageLookupByLibrary.simpleMessage("今日の日付"),
        "permissionContent": MessageLookupByLibrary.simpleMessage(
            "ファイルのリネームサービスを提供するために、外部ストレージの管理を許可してください。これにより、デバイスに保存されているファイルにアクセスしてリネームできるようになります。この許可がない場合、アプリはファイルの完全なパスにアクセスできないため、リネーム操作を行うことができません。お客様のプライバシーとセキュリティを非常に重視しており、リネーム目的でのみファイルにアクセスします。"),
        "permissionTitle": MessageLookupByLibrary.simpleMessage("外部ストレージの許可"),
        "photoAltitude":
            MessageLookupByLibrary.simpleMessage("写真のGPS高度（Exifから）"),
        "photoAperture": MessageLookupByLibrary.simpleMessage("絞り値（Exifから）"),
        "photoCamName": MessageLookupByLibrary.simpleMessage("カメラ名（Exifから）"),
        "photoCopyright":
            MessageLookupByLibrary.simpleMessage("著作権者の名前（Exifから）"),
        "photoDate": MessageLookupByLibrary.simpleMessage("写真撮影日（Exifから）"),
        "photoFocalLength":
            MessageLookupByLibrary.simpleMessage("焦点距離（Exifから）"),
        "photoISO": MessageLookupByLibrary.simpleMessage("ISO値（Exifから）"),
        "photoLatitude":
            MessageLookupByLibrary.simpleMessage("写真のGPS緯度（Exifから）"),
        "photoLensName": MessageLookupByLibrary.simpleMessage("レンズ名（Exifから）"),
        "photoLongitude":
            MessageLookupByLibrary.simpleMessage("写真のGPS経度（Exifから）"),
        "photoPhotographer":
            MessageLookupByLibrary.simpleMessage("写真家の名前（Exifから）"),
        "photoShutter":
            MessageLookupByLibrary.simpleMessage("シャッタースピード（Exifから）"),
        "photoTime": MessageLookupByLibrary.simpleMessage("写真撮影時間（Exifから）"),
        "prefix": MessageLookupByLibrary.simpleMessage("接頭辞"),
        "rating": MessageLookupByLibrary.simpleMessage("アプリ評価"),
        "ratingContent": MessageLookupByLibrary.simpleMessage(
            "当アプリを気に入りましたか？アプリストアで評価していただくか、GitHubでスターを付けていただくと成長に役立ちます。お客様のフィードバックは非常に重要です。ご支援いただきありがとうございます。"),
        "ratingGithub": MessageLookupByLibrary.simpleMessage("GitHubでスターを付ける"),
        "ratingStore": MessageLookupByLibrary.simpleMessage("ストアで評価"),
        "ratingTitle": MessageLookupByLibrary.simpleMessage("アプリを評価する"),
        "rearrange": MessageLookupByLibrary.simpleMessage("並べ替え"),
        "rearrangeDelimiter": MessageLookupByLibrary.simpleMessage("区切り文字"),
        "rearrangeOrderHint":
            MessageLookupByLibrary.simpleMessage("該当する数字を入力し、カンマで区切ってください"),
        "rearrangeOrderLabel": MessageLookupByLibrary.simpleMessage("並べ替え順序"),
        "rearrangeToString": m2,
        "remove": MessageLookupByLibrary.simpleMessage("削除"),
        "removeAll": MessageLookupByLibrary.simpleMessage("すべて削除"),
        "removeCharacters": MessageLookupByLibrary.simpleMessage("両方の文字を削除"),
        "removeRenamed": MessageLookupByLibrary.simpleMessage("リネーム済みファイルを削除"),
        "removeRule": MessageLookupByLibrary.simpleMessage("このルールを削除"),
        "removeRules": MessageLookupByLibrary.simpleMessage("リネーム後にすべてのルールを削除"),
        "removeToString": m3,
        "rename": MessageLookupByLibrary.simpleMessage("リネーム"),
        "renameFailed": MessageLookupByLibrary.simpleMessage("リネームに失敗しました"),
        "replace": MessageLookupByLibrary.simpleMessage("置換"),
        "replaceToString": m4,
        "replacement": MessageLookupByLibrary.simpleMessage("置換文字"),
        "ru": MessageLookupByLibrary.simpleMessage("ロシア語"),
        "rulesSequentially": MessageLookupByLibrary.simpleMessage(
            "ルールは順次実行されます。ルールを編集するにはクリックします。左側の「=」ボタンを押しながらドラッグしてルールを並べ替えることができます。"),
        "save": MessageLookupByLibrary.simpleMessage("保存"),
        "select": MessageLookupByLibrary.simpleMessage("選択"),
        "selectAll": MessageLookupByLibrary.simpleMessage("すべて選択"),
        "semanticSwitchNumberToStartAndToEnd": m5,
        "semanticsDropdownButton": m6,
        "semanticsFileManagerDirSubtitle": m7,
        "semanticsFileManagerSubtitle": m8,
        "semanticsFileManagerTitle": m9,
        "semanticsFilesDropdownButton": MessageLookupByLibrary.simpleMessage(
            "。この項目を選択して、リネーム対象をこの範囲に制限します。"),
        "semanticsMultipleActionsHint":
            MessageLookupByLibrary.simpleMessage("上下にスワイプして他の操作に移動します。"),
        "semanticsOpenMetadataDialog": MessageLookupByLibrary.simpleMessage(
            "ダブルクリックしてダイアログを開き、挿入するメタデータタグを選択します。"),
        "semanticsReorderableList": MessageLookupByLibrary.simpleMessage(
            "ルールリストは現在空です。ルールは順番に実行されます。リストを並べ替えてルールを上下に移動したり、先頭や末尾に移動したりすることができます。ルールを選択した状態で、垂直スワイプジェスチャを使用して異なる操作を切り替え、ダブルクリックして選択した操作を実行します。"),
        "semanticsRuleDropdownButton": MessageLookupByLibrary.simpleMessage(
            "。この項目を選択し、「ルールを追加」ボタンをクリックしてルールを追加します。"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("ソースコード"),
        "sr": MessageLookupByLibrary.simpleMessage("セルビア語"),
        "startIndex": MessageLookupByLibrary.simpleMessage("開始インデックス"),
        "target": MessageLookupByLibrary.simpleMessage("ターゲット"),
        "tj": MessageLookupByLibrary.simpleMessage("タジク語"),
        "toLast": MessageLookupByLibrary.simpleMessage("最後まで"),
        "transliterate": MessageLookupByLibrary.simpleMessage("転写"),
        "transliterateCyrillic2Latin":
            MessageLookupByLibrary.simpleMessage("キリル文字をラテン文字に変換"),
        "transliterateLatin2Cyrillic":
            MessageLookupByLibrary.simpleMessage("ラテン文字をキリル文字に変換"),
        "transliterateLower":
            MessageLookupByLibrary.simpleMessage("小文字のラテン文字に変換"),
        "transliteratePinyin":
            MessageLookupByLibrary.simpleMessage("中国語をピンインに変換"),
        "transliterateSimplified":
            MessageLookupByLibrary.simpleMessage("簡体字に変換"),
        "transliterateToString": m10,
        "transliterateToStringCyrillic": m11,
        "transliterateTraditional":
            MessageLookupByLibrary.simpleMessage("繁体字に変換"),
        "transliterateUpper":
            MessageLookupByLibrary.simpleMessage("大文字のラテン文字に変換"),
        "truncate": MessageLookupByLibrary.simpleMessage("切り詰め"),
        "truncateToString": m12,
        "ua": MessageLookupByLibrary.simpleMessage("ウクライナ語")
      };
}
