// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(prefix) => "Incremental renaming: ${prefix}-index";

  static String m1(location, insert, insertIndex) =>
      "Insert ${insert} at the char #${insertIndex} from ${Intl.plural(location, zero: 'end', one: 'start', other: 'other')}.";

  static String m2(delimiter, order) =>
      "Rearrange: delimiter: ${delimiter}, order: ${order}.";

  static String m3(targetString) => "Remove \"${targetString}\"";

  static String m4(targetString, replacementString) =>
      "Replace \"${targetString}\" with \"${replacementString}\".";

  static String m5(type) => "Transliterate: convert ${type}.";

  static String m6(langName, type) =>
      "Transliterate: convert ${langName} ${type}.";

  static String m7(keepType, location, direction, length, startIndex) =>
      "Truncate: ${Intl.plural(keepType, zero: 'remove', one: 'keep', other: 'other')} ${length} characters starting from the char #${startIndex} from ${Intl.plural(location, zero: 'end', one: 'start', other: 'other')} going ${Intl.plural(direction, zero: 'backward', one: 'forward', other: 'other')}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutContent": MessageLookupByLibrary.simpleMessage(
            "This application is designed to help users rename their files. It is built with Flutter - a multi-platform application framework, and therefore it is also available on other operating systems. It is totally open source and could be reviewed or contributed to."),
        "add": MessageLookupByLibrary.simpleMessage("Add"),
        "addFile": MessageLookupByLibrary.simpleMessage("Add file"),
        "addFiles": MessageLookupByLibrary.simpleMessage("Add files"),
        "addRule": MessageLookupByLibrary.simpleMessage("Add Rule"),
        "appError": MessageLookupByLibrary.simpleMessage("Application error"),
        "appInfo": MessageLookupByLibrary.simpleMessage("App info"),
        "appName": MessageLookupByLibrary.simpleMessage("Renamer"),
        "bg": MessageLookupByLibrary.simpleMessage("Bulgarian"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancelAll": MessageLookupByLibrary.simpleMessage("Cancel All"),
        "caseSensitive": MessageLookupByLibrary.simpleMessage("Case sensitive"),
        "collapseOptions":
            MessageLookupByLibrary.simpleMessage("Collapse options"),
        "currentName": MessageLookupByLibrary.simpleMessage("Current name"),
        "directories": MessageLookupByLibrary.simpleMessage("Directories"),
        "dragToAdd":
            MessageLookupByLibrary.simpleMessage("Drag and drop to add files."),
        "dropToAdd": MessageLookupByLibrary.simpleMessage("Drop to add files."),
        "errorDetails": MessageLookupByLibrary.simpleMessage("Error details"),
        "exit": MessageLookupByLibrary.simpleMessage("Exit"),
        "exitContent": MessageLookupByLibrary.simpleMessage(
            "The manage external storage permission allows us to access and rename files stored on your device. Without this permission, the app won\'t be able to access the complete file paths and therefore can\'t rename files. Please go to Settings page and grant the permission manually, otherwise we cannot provide any service."),
        "exitTitle": MessageLookupByLibrary.simpleMessage(
            "Can not access external storage"),
        "expandOptions": MessageLookupByLibrary.simpleMessage("Expand options"),
        "fileCreateDate":
            MessageLookupByLibrary.simpleMessage("Create date of file"),
        "fileCreateTime":
            MessageLookupByLibrary.simpleMessage("Create time of file"),
        "fileModifyDate":
            MessageLookupByLibrary.simpleMessage("Modify date of file"),
        "fileModifyTime":
            MessageLookupByLibrary.simpleMessage("Modify time of file"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Size of file"),
        "fileSortDate": MessageLookupByLibrary.simpleMessage("Date"),
        "fileSortName": MessageLookupByLibrary.simpleMessage("Name"),
        "fileSortSize": MessageLookupByLibrary.simpleMessage("Size"),
        "fileSortType": MessageLookupByLibrary.simpleMessage("Type"),
        "files": MessageLookupByLibrary.simpleMessage("Files"),
        "filesDirs": MessageLookupByLibrary.simpleMessage("Files & Dirs"),
        "filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "fromStart": MessageLookupByLibrary.simpleMessage("From start"),
        "goingForward": MessageLookupByLibrary.simpleMessage("Going forward"),
        "ifFileNotShown": MessageLookupByLibrary.simpleMessage(
            "If files does not shown in file list, please clear all and continue."),
        "ignoreExtension":
            MessageLookupByLibrary.simpleMessage("Ignore Extension"),
        "increment": MessageLookupByLibrary.simpleMessage("Increment"),
        "incrementToString": m0,
        "indexIncrementalStep":
            MessageLookupByLibrary.simpleMessage("Index incremental step"),
        "insert": MessageLookupByLibrary.simpleMessage("Insert"),
        "insertBeforeIndex":
            MessageLookupByLibrary.simpleMessage("Insert before index"),
        "insertIndex": MessageLookupByLibrary.simpleMessage("Insert index"),
        "insertTagInsideAnother": MessageLookupByLibrary.simpleMessage(
            "Do not insert a tag inside another tag."),
        "insertToString": m1,
        "insertedText":
            MessageLookupByLibrary.simpleMessage("Text to be inserted"),
        "isRegex": MessageLookupByLibrary.simpleMessage("Is regex"),
        "keepCharacters":
            MessageLookupByLibrary.simpleMessage("Keep characters"),
        "language": MessageLookupByLibrary.simpleMessage("Language: "),
        "limit": MessageLookupByLibrary.simpleMessage("limit"),
        "lowercaseAppName": MessageLookupByLibrary.simpleMessage("renamer"),
        "me": MessageLookupByLibrary.simpleMessage("Montenegrin"),
        "metadataParserNotProvided": MessageLookupByLibrary.simpleMessage(
            "Contains metadata tag while MetadataParser was not provided."),
        "metadataTags": MessageLookupByLibrary.simpleMessage("Metadata tags"),
        "mk": MessageLookupByLibrary.simpleMessage("Macedonian"),
        "mn": MessageLookupByLibrary.simpleMessage("Mongolian"),
        "newName": MessageLookupByLibrary.simpleMessage("New name"),
        "noSysDir": MessageLookupByLibrary.simpleMessage(
            "Do not rename a system reserved directory."),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "omitDash": MessageLookupByLibrary.simpleMessage("Omit dash"),
        "onlySelected": MessageLookupByLibrary.simpleMessage("Only Selected"),
        "osNowTime": MessageLookupByLibrary.simpleMessage("Time of now"),
        "osTodayDate": MessageLookupByLibrary.simpleMessage("Date of today"),
        "permissionContent": MessageLookupByLibrary.simpleMessage(
            "To provide you with our file renaming service, we need your permission to manage external storage. This allows us to access and rename files stored on your device. Without this permission, the app won\'t be able to access the complete file paths and therefore can\'t rename files. We assure you that your privacy and security are our top priorities, and we only access files for the purpose of renaming."),
        "permissionTitle": MessageLookupByLibrary.simpleMessage(
            "Permission for external storage"),
        "photoAltitude": MessageLookupByLibrary.simpleMessage(
            "Altitude of photo GPS from exif"),
        "photoAperture":
            MessageLookupByLibrary.simpleMessage("Aperture value from exif"),
        "photoCamName":
            MessageLookupByLibrary.simpleMessage("Camera name from exif"),
        "photoCopyright": MessageLookupByLibrary.simpleMessage(
            "Copyright holder name from exif"),
        "photoDate": MessageLookupByLibrary.simpleMessage(
            "Photographing date from exif"),
        "photoFocalLength":
            MessageLookupByLibrary.simpleMessage("Focal length from exif"),
        "photoISO": MessageLookupByLibrary.simpleMessage("ISO value from exif"),
        "photoLatitude": MessageLookupByLibrary.simpleMessage(
            "Latitude of photo GPS from exif"),
        "photoLensName":
            MessageLookupByLibrary.simpleMessage("Lens name from exif"),
        "photoLongitude": MessageLookupByLibrary.simpleMessage(
            "Longitude of photo GPS from exif"),
        "photoPhotographer":
            MessageLookupByLibrary.simpleMessage("Photographer name from exif"),
        "photoShutter":
            MessageLookupByLibrary.simpleMessage("Shutter speed from exif"),
        "photoTime": MessageLookupByLibrary.simpleMessage(
            "Photographing time from exif"),
        "prefix": MessageLookupByLibrary.simpleMessage("Prefix"),
        "rating": MessageLookupByLibrary.simpleMessage("Rating the app"),
        "ratingContent": MessageLookupByLibrary.simpleMessage(
            "Enjoying our app? Help us grow by giving it a quick rating on the store or GitHub. Your feedback means the world to us! Thanks for your support."),
        "ratingGithub":
            MessageLookupByLibrary.simpleMessage("Star it on Github"),
        "ratingStore":
            MessageLookupByLibrary.simpleMessage("Rate the app on store"),
        "ratingTitle": MessageLookupByLibrary.simpleMessage("Rate Our App"),
        "rearrange": MessageLookupByLibrary.simpleMessage("Rearrange"),
        "rearrangeDelimiter":
            MessageLookupByLibrary.simpleMessage("Rearrange delimiter"),
        "rearrangeOrderHint": MessageLookupByLibrary.simpleMessage(
            "numbers separated with comma"),
        "rearrangeOrderLabel":
            MessageLookupByLibrary.simpleMessage("Rearrange order"),
        "rearrangeToString": m2,
        "remove": MessageLookupByLibrary.simpleMessage("Remove"),
        "removeAll": MessageLookupByLibrary.simpleMessage("Remove all"),
        "removeRenamed": MessageLookupByLibrary.simpleMessage("Remove renamed"),
        "removeRules":
            MessageLookupByLibrary.simpleMessage("Remove rules after renaming"),
        "removeToString": m3,
        "rename": MessageLookupByLibrary.simpleMessage("Rename"),
        "replace": MessageLookupByLibrary.simpleMessage("Replace"),
        "replaceToString": m4,
        "replacement": MessageLookupByLibrary.simpleMessage("Replacement"),
        "ru": MessageLookupByLibrary.simpleMessage("Russian"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "selectAll": MessageLookupByLibrary.simpleMessage("Select All"),
        "selectionLength":
            MessageLookupByLibrary.simpleMessage("Selection length"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Source code"),
        "sr": MessageLookupByLibrary.simpleMessage("Serbian"),
        "startIndex": MessageLookupByLibrary.simpleMessage("Start index"),
        "target": MessageLookupByLibrary.simpleMessage("target"),
        "tj": MessageLookupByLibrary.simpleMessage("Tajik"),
        "transliterate": MessageLookupByLibrary.simpleMessage("Transliterate"),
        "transliterateCyrillic2Latin": MessageLookupByLibrary.simpleMessage(
            "Cyrillic characters to Latin"),
        "transliterateLatin2Cyrillic": MessageLookupByLibrary.simpleMessage(
            "Latin characters to Cyrillic"),
        "transliterateLower": MessageLookupByLibrary.simpleMessage(
            "Latin characters to lower case"),
        "transliteratePinyin": MessageLookupByLibrary.simpleMessage(
            "Chinese characters to pinyin"),
        "transliterateSimplified": MessageLookupByLibrary.simpleMessage(
            "Chinese characters to simplified Chinese"),
        "transliterateToString": m5,
        "transliterateToStringCyrillic": m6,
        "transliterateTraditional": MessageLookupByLibrary.simpleMessage(
            "Chinese characters to traditional Chinese"),
        "transliterateUpper": MessageLookupByLibrary.simpleMessage(
            "Latin characters to upper case"),
        "truncate": MessageLookupByLibrary.simpleMessage("Truncate"),
        "truncateToString": m7,
        "ua": MessageLookupByLibrary.simpleMessage("Ukrainian")
      };
}
