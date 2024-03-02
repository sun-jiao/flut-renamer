// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static String m0(prefix) => "递增：${prefix}-索引";

  static String m1(location, insert, insertIndex) =>
      "插入：在${Intl.plural(location, zero: '倒数的', one: '', other: '')}第${insertIndex}个字符处插入“${insert}”。";

  static String m2(delimiter, order) => "重排：分隔符：${delimiter}，顺序：${order}。";

  static String m3(targetString) => "删除：“${targetString}”";

  static String m4(targetString, replacementString) =>
      "替换：将“${targetString}”替换为“${replacementString}”。";

  static String m5(type) => "转写：${type}。";

  static String m6(langName, type) => "转写：将${langName}${type}。";

  static String m7(keepType, i1toEnd, i2toEnd, i1, i2) =>
      "截取：${Intl.plural(keepType, zero: '仅保留', one: '移除', other: '')}从${Intl.plural(i1toEnd, zero: '倒数的', one: '', other: '')}第${i1}个字符至${Intl.plural(i2toEnd, zero: '倒数的', one: '', other: '')}第${i2}个字符之间的内容。";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutContent": MessageLookupByLibrary.simpleMessage(
            "此应用旨在帮助用户重命名文件。它使用Flutter框架开发，因此也适用于其他操作系统。它是完全开源的，可以进行审查和贡献。"),
        "add": MessageLookupByLibrary.simpleMessage("添加"),
        "addFile": MessageLookupByLibrary.simpleMessage("添加文件"),
        "addFiles": MessageLookupByLibrary.simpleMessage("请添加文件。"),
        "addRule": MessageLookupByLibrary.simpleMessage("添加规则"),
        "androidRemindContent": MessageLookupByLibrary.simpleMessage(
            "使用批量重命名，您不仅可以重命名文件，还可以重命名目录。长按目录将其选中，然后在左上角下拉按钮中选择“文件和目录”即可启用目录重命名功能。出于安全考虑，某些系统保留目录不可选。"),
        "androidRemindTitle": MessageLookupByLibrary.simpleMessage("重命名目录"),
        "appError": MessageLookupByLibrary.simpleMessage("应用程序错误"),
        "appInfo": MessageLookupByLibrary.simpleMessage("应用信息"),
        "appName": MessageLookupByLibrary.simpleMessage("批量重命名"),
        "bg": MessageLookupByLibrary.simpleMessage("保加利亚语"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "cancelAll": MessageLookupByLibrary.simpleMessage("全部取消"),
        "caseSensitive": MessageLookupByLibrary.simpleMessage("区分大小写"),
        "collapseOptions": MessageLookupByLibrary.simpleMessage("收起选项"),
        "currentName": MessageLookupByLibrary.simpleMessage("当前文件名"),
        "descriptionIncrement": MessageLookupByLibrary.simpleMessage(
            "递增文件名，例如 Photo-1、Photo-2、Photo-3。"),
        "descriptionInsert":
            MessageLookupByLibrary.simpleMessage("在指定位置插入指定文本（或文件元数据和EXIF数据）。"),
        "descriptionRearrange": MessageLookupByLibrary.simpleMessage(
            "以用户指定的分隔符将文件名分割成若干片段，并根据提供的顺序重新排列。"),
        "descriptionRemove": MessageLookupByLibrary.simpleMessage(
            "从文件名中删除指定的文本（或与提供的正则表达式匹配的文本）。"),
        "descriptionReplace": MessageLookupByLibrary.simpleMessage(
            "用给定的替换文本（或文件元数据和EXIF数据）替换指定的文本（或与提供的正则表达式匹配的文本）。"),
        "descriptionTransliterate": MessageLookupByLibrary.simpleMessage(
            "根据预先定义的规范转换字符，包括将字母转换为大写或小写、转换为不同的文字变体或转换为不同的书写系统。"),
        "descriptionTruncate": MessageLookupByLibrary.simpleMessage(
            "删除或保留文件名的指定部分，从一个指定位置开始到另一个指定位置。"),
        "directories": MessageLookupByLibrary.simpleMessage("目录"),
        "doNotRemindAgain": MessageLookupByLibrary.simpleMessage("确定，不再提醒"),
        "dragToAdd": MessageLookupByLibrary.simpleMessage("拖放文件进行添加。"),
        "dropToAdd": MessageLookupByLibrary.simpleMessage("在此处释放文件。"),
        "errorDetails": MessageLookupByLibrary.simpleMessage("错误详情"),
        "exit": MessageLookupByLibrary.simpleMessage("退出"),
        "exitContent": MessageLookupByLibrary.simpleMessage(
            "管理外部存储的权限允许我们访问和重命名您设备上存储的文件。如果没有此权限，应用将无法访问文件的完整路径，从而无法进行重命名操作。请前往设置页面手动授予权限，否则我们将无法提供任何服务。"),
        "exitTitle": MessageLookupByLibrary.simpleMessage("无法访问外部存储"),
        "expandOptions": MessageLookupByLibrary.simpleMessage("展开选项"),
        "fileCreateDate": MessageLookupByLibrary.simpleMessage("文件创建日期"),
        "fileCreateTime": MessageLookupByLibrary.simpleMessage("文件创建时间"),
        "fileModifyDate": MessageLookupByLibrary.simpleMessage("文件修改日期"),
        "fileModifyTime": MessageLookupByLibrary.simpleMessage("文件修改时间"),
        "fileSize": MessageLookupByLibrary.simpleMessage("文件大小"),
        "fileSortDate": MessageLookupByLibrary.simpleMessage("日期"),
        "fileSortName": MessageLookupByLibrary.simpleMessage("名称"),
        "fileSortSize": MessageLookupByLibrary.simpleMessage("大小"),
        "fileSortType": MessageLookupByLibrary.simpleMessage("类型"),
        "files": MessageLookupByLibrary.simpleMessage("文件"),
        "filesDirs": MessageLookupByLibrary.simpleMessage("文件和目录"),
        "filter": MessageLookupByLibrary.simpleMessage("筛选"),
        "fromStart": MessageLookupByLibrary.simpleMessage("从开头计数"),
        "goingForward": MessageLookupByLibrary.simpleMessage("向前"),
        "ifFileNotShown":
            MessageLookupByLibrary.simpleMessage("如果文件列表中未显示文件，请清除所有内容并继续。"),
        "ignoreExtension": MessageLookupByLibrary.simpleMessage("忽略扩展名"),
        "increment": MessageLookupByLibrary.simpleMessage("递增"),
        "incrementToString": m0,
        "indexIncrementalStep": MessageLookupByLibrary.simpleMessage("索引递增量"),
        "indexOne": MessageLookupByLibrary.simpleMessage("第一处位置"),
        "indexTwo": MessageLookupByLibrary.simpleMessage("第二处位置"),
        "insert": MessageLookupByLibrary.simpleMessage("插入"),
        "insertBeforeIndex": MessageLookupByLibrary.simpleMessage("在插入位置前侧插入"),
        "insertIndex": MessageLookupByLibrary.simpleMessage("插入位置"),
        "insertTagInsideAnother":
            MessageLookupByLibrary.simpleMessage("请勿在一个标签内插入另一个标签。"),
        "insertToString": m1,
        "insertedText": MessageLookupByLibrary.simpleMessage("要插入的文本"),
        "iosRemindContent": MessageLookupByLibrary.simpleMessage(
            "要在iOS上选取文件，首先选择一个包含您的文件的文件夹。然后，在选定的文件夹中，选择您要重命名的文件。由于iOS的限制，我们必须采取这两个步骤，这可以确保安全的文件访问。让我们开始吧！"),
        "iosRemindTitle": MessageLookupByLibrary.simpleMessage("关于在iOS上选取文件"),
        "isRegex": MessageLookupByLibrary.simpleMessage("使用正则表达式"),
        "keepCharacters": MessageLookupByLibrary.simpleMessage("保留二者之间的字符"),
        "language": MessageLookupByLibrary.simpleMessage("语言："),
        "limit": MessageLookupByLibrary.simpleMessage("次数"),
        "lowercaseAppName": MessageLookupByLibrary.simpleMessage("批量重命名"),
        "me": MessageLookupByLibrary.simpleMessage("黑山语"),
        "metadataParserNotProvided":
            MessageLookupByLibrary.simpleMessage("包含元数据标签，但未提供元数据解析器。"),
        "metadataTags": MessageLookupByLibrary.simpleMessage("元数据标签"),
        "mk": MessageLookupByLibrary.simpleMessage("马其顿语"),
        "mn": MessageLookupByLibrary.simpleMessage("蒙古语"),
        "musicAlbumArtist": MessageLookupByLibrary.simpleMessage("专辑艺术家姓名"),
        "musicAlbumLength": MessageLookupByLibrary.simpleMessage("专辑中的曲目数"),
        "musicAlbumName": MessageLookupByLibrary.simpleMessage("专辑名称"),
        "musicAuthor": MessageLookupByLibrary.simpleMessage("曲目的作者（Author）"),
        "musicTrackArtist": MessageLookupByLibrary.simpleMessage("表演曲目的艺术家姓名"),
        "musicTrackDuration": MessageLookupByLibrary.simpleMessage("曲目的持续时间"),
        "musicTrackName": MessageLookupByLibrary.simpleMessage("曲目名称"),
        "musicTrackNumber": MessageLookupByLibrary.simpleMessage("曲目在专辑中的位置"),
        "musicWriter": MessageLookupByLibrary.simpleMessage("曲目的作家（Writer）"),
        "musicYear": MessageLookupByLibrary.simpleMessage("曲目的出版年份"),
        "newName": MessageLookupByLibrary.simpleMessage("新文件名"),
        "noSysDir": MessageLookupByLibrary.simpleMessage("请勿重命名系统保留目录。"),
        "ok": MessageLookupByLibrary.simpleMessage("确定"),
        "omitDash": MessageLookupByLibrary.simpleMessage("省略短横线"),
        "onlySelected": MessageLookupByLibrary.simpleMessage("仅重命名选中的文件"),
        "osNowTime": MessageLookupByLibrary.simpleMessage("当前时间"),
        "osTodayDate": MessageLookupByLibrary.simpleMessage("当前日期"),
        "permissionContent": MessageLookupByLibrary.simpleMessage(
            "为了提供文件重命名服务，我们需要您授权我们管理外部存储。这样我们才能访问并重命名您设备上存储的文件。如果没有此权限，应用将无法访问文件的完整路径，从而无法进行重命名操作。我们向您保证，我们非常重视您的隐私和安全，我们只会在重命名目的下访问文件。"),
        "permissionTitle": MessageLookupByLibrary.simpleMessage("外部存储权限"),
        "photoAltitude":
            MessageLookupByLibrary.simpleMessage("照片GPS海拔（来自exif）"),
        "photoAperture": MessageLookupByLibrary.simpleMessage("光圈数值（来自exif）"),
        "photoCamName": MessageLookupByLibrary.simpleMessage("相机名称（来自exif）"),
        "photoCopyright":
            MessageLookupByLibrary.simpleMessage("版权所有者姓名（来自exif）"),
        "photoDate": MessageLookupByLibrary.simpleMessage("照片拍摄日期（来自exif）"),
        "photoFocalLength": MessageLookupByLibrary.simpleMessage("焦距（来自exif）"),
        "photoISO": MessageLookupByLibrary.simpleMessage("ISO数值（来自exif）"),
        "photoLatitude":
            MessageLookupByLibrary.simpleMessage("照片GPS纬度（来自exif）"),
        "photoLensName": MessageLookupByLibrary.simpleMessage("镜头名称（来自exif）"),
        "photoLongitude":
            MessageLookupByLibrary.simpleMessage("照片GPS经度（来自exif）"),
        "photoPhotographer":
            MessageLookupByLibrary.simpleMessage("摄影师姓名（来自exif）"),
        "photoShutter": MessageLookupByLibrary.simpleMessage("快门速度（来自exif）"),
        "photoTime": MessageLookupByLibrary.simpleMessage("照片拍摄时间（来自exif）"),
        "prefix": MessageLookupByLibrary.simpleMessage("前缀"),
        "rating": MessageLookupByLibrary.simpleMessage("应用评分"),
        "ratingContent": MessageLookupByLibrary.simpleMessage(
            "喜欢我们的应用吗？在应用商店给个好评或在GitHub上点赞来帮助我们成长。您的反馈对我们非常重要！感谢您的支持。"),
        "ratingGithub": MessageLookupByLibrary.simpleMessage("给GitHub仓库点赞"),
        "ratingStore": MessageLookupByLibrary.simpleMessage("去商店评分"),
        "ratingTitle": MessageLookupByLibrary.simpleMessage("评价我们的应用"),
        "rearrange": MessageLookupByLibrary.simpleMessage("重排"),
        "rearrangeDelimiter": MessageLookupByLibrary.simpleMessage("分隔符"),
        "rearrangeOrderHint":
            MessageLookupByLibrary.simpleMessage("请输入相应数字，以英文逗号隔开"),
        "rearrangeOrderLabel": MessageLookupByLibrary.simpleMessage("重排的顺序"),
        "rearrangeToString": m2,
        "remove": MessageLookupByLibrary.simpleMessage("删除"),
        "removeAll": MessageLookupByLibrary.simpleMessage("移除全部"),
        "removeCharacters": MessageLookupByLibrary.simpleMessage("移除二者之间的字符"),
        "removeRenamed": MessageLookupByLibrary.simpleMessage("移除已重命名文件"),
        "removeRules": MessageLookupByLibrary.simpleMessage("重命名后移除所有规则"),
        "removeToString": m3,
        "rename": MessageLookupByLibrary.simpleMessage("重命名"),
        "replace": MessageLookupByLibrary.simpleMessage("替换"),
        "replaceToString": m4,
        "replacement": MessageLookupByLibrary.simpleMessage("替换为"),
        "ru": MessageLookupByLibrary.simpleMessage("俄语"),
        "save": MessageLookupByLibrary.simpleMessage("保存"),
        "selectAll": MessageLookupByLibrary.simpleMessage("全选"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("源代码"),
        "sr": MessageLookupByLibrary.simpleMessage("塞尔维亚语"),
        "startIndex": MessageLookupByLibrary.simpleMessage("起始索引"),
        "target": MessageLookupByLibrary.simpleMessage("目标"),
        "tj": MessageLookupByLibrary.simpleMessage("塔吉克语"),
        "toLast": MessageLookupByLibrary.simpleMessage("倒数"),
        "transliterate": MessageLookupByLibrary.simpleMessage("转写"),
        "transliterateCyrillic2Latin":
            MessageLookupByLibrary.simpleMessage("从西里尔字符转为拉丁字符"),
        "transliterateLatin2Cyrillic":
            MessageLookupByLibrary.simpleMessage("从拉丁字符转为西里尔字符"),
        "transliterateLower": MessageLookupByLibrary.simpleMessage("转换为小写拉丁字符"),
        "transliteratePinyin": MessageLookupByLibrary.simpleMessage("转换中文为拼音"),
        "transliterateSimplified":
            MessageLookupByLibrary.simpleMessage("转换为简体中文"),
        "transliterateToString": m5,
        "transliterateToStringCyrillic": m6,
        "transliterateTraditional":
            MessageLookupByLibrary.simpleMessage("转换为繁体中文"),
        "transliterateUpper": MessageLookupByLibrary.simpleMessage("转换为大写拉丁字符"),
        "truncate": MessageLookupByLibrary.simpleMessage("截取"),
        "truncateToString": m7,
        "ua": MessageLookupByLibrary.simpleMessage("乌克兰语")
      };
}
