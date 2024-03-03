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

  static String m1(toEnd, ordinal, insert, insertIndex) =>
      "Insert \"${insert}\" at the ${insertIndex}${Intl.select(ordinal, {
            'o1': 'st',
            'o2': 'nd',
            'o3': 'rd',
            'other': 'th',
          })}${Intl.select(toEnd, {
            'true': '-to-end',
            'false': '',
            'other': '',
          })} character.";

  static String m2(delimiter, order) =>
      "Rearrange: delimiter: ${delimiter}, order: ${order}.";

  static String m3(targetString) => "Remove \"${targetString}\"";

  static String m4(targetString, replacementString) =>
      "Replace \"${targetString}\" with \"${replacementString}\".";

  static String m5(toEnd) =>
      "Switching counting direction between from the beginning and from the end, currently counting from ${Intl.select(toEnd, {
            'true': 'the end',
            'false': 'the beginning',
            'other': '',
          })}";

  static String m6(value) =>
      "This is a dropdown button, current value is \"${value}\", double click to open the it and pick another value.";

  static String m7(last) => "last modified at ${last}.";

  static String m8(last, size) => "last modified at ${last}, sized ${size}.";

  static String m9(entityType, selectStatus, filename) =>
      "${Intl.select(selectStatus, {
            'true': 'Selected',
            'false': 'Unselected',
            'other': '',
          })} ${Intl.select(entityType, {
            'File': 'File',
            'Directory': 'Folder',
            'Link': 'Link',
            'other': 'File system entity',
          })}, filename is ${filename}, ";

  static String m10(type) => "Transliterate: convert ${type}.";

  static String m11(langName, type) =>
      "Transliterate: convert ${langName} ${type}.";

  static String m12(iTwoToEnd, iOneOrdinal, iOneToEnd, iTwoOrdinal, keepType,
          iOne, iTwo) =>
      "Truncate: ${Intl.select(keepType, {
            'true': 'keep only',
            'false': 'remove',
            'other': '',
          })} characters between the ${iOne}${Intl.select(iTwoOrdinal, {
            'o1': 'st',
            'o2': 'nd',
            'o3': 'rd',
            'other': 'th',
          })}${Intl.select(iOneToEnd, {
            'true': '-to-end',
            'false': '',
            'other': '',
          })} character and the ${iTwo}${Intl.select(iOneOrdinal, {
            'o1': 'st',
            'o2': 'nd',
            'o3': 'rd',
            'other': 'th',
          })}${Intl.select(iTwoToEnd, {
            'true': '-to-end',
            'false': '',
            'other': '',
          })}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutContent": MessageLookupByLibrary.simpleMessage(
            "This application is designed to help users rename their files. It is built with Flutter - a multi-platform application framework, and therefore it is also available on other operating systems. It is totally open source and can be reviewed or contributed to."),
        "add": MessageLookupByLibrary.simpleMessage("Add"),
        "addFile": MessageLookupByLibrary.simpleMessage("Add file"),
        "addFiles": MessageLookupByLibrary.simpleMessage("Add files"),
        "addRule": MessageLookupByLibrary.simpleMessage("Add Rule"),
        "androidRemindContent": MessageLookupByLibrary.simpleMessage(
            "Using the renamer, you can not only rename files but also directories. Long-press a directory to select it, then select \'Files & Dirs\' from the drop-down button in the upper-left corner to enable directory renaming. For security reasons, some system reserved directories are not selectable."),
        "androidRemindTitle":
            MessageLookupByLibrary.simpleMessage("Rename directory"),
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
        "descriptionIncrement": MessageLookupByLibrary.simpleMessage(
            "Increment the filename, e.g., Photo-1, Photo-2, Photo-3."),
        "descriptionInsert": MessageLookupByLibrary.simpleMessage(
            "Insert the specified text (or file metadata and EXIF data) at the designated position."),
        "descriptionRearrange": MessageLookupByLibrary.simpleMessage(
            "Splitting the filename by the user-specified delimiter and rearrange segments according to the provided order."),
        "descriptionRemove": MessageLookupByLibrary.simpleMessage(
            "Remove the specified text (or text matching the provided regular expression) from the filename."),
        "descriptionReplace": MessageLookupByLibrary.simpleMessage(
            "Replace the specified text (or text matching the provided regular expression) with the given replacement text (or file metadata and EXIF data)."),
        "descriptionTransliterate": MessageLookupByLibrary.simpleMessage(
            "Transliterate characters according to predefined specifications, including converting characters to upper or lower case, converting between character sets, or converting characters to phonetic equivalents."),
        "descriptionTruncate": MessageLookupByLibrary.simpleMessage(
            "Remove or keep the specified part of the filename, starting from one designated position to another."),
        "directories": MessageLookupByLibrary.simpleMessage("Directories"),
        "doNotRemindAgain":
            MessageLookupByLibrary.simpleMessage("OK. Do not remind me again."),
        "dragToAdd":
            MessageLookupByLibrary.simpleMessage("Drag and drop to add files."),
        "dropToAdd": MessageLookupByLibrary.simpleMessage("Drop to add files."),
        "errorDetails": MessageLookupByLibrary.simpleMessage("Error details"),
        "exit": MessageLookupByLibrary.simpleMessage("Exit"),
        "exitContent": MessageLookupByLibrary.simpleMessage(
            "The manage external storage permission allows us to access and rename files stored on your device. Without this permission, the app won\'t be able to access the complete file paths and therefore can\'t rename files. Please go to the Settings page and grant the permission manually; otherwise, we cannot provide any service."),
        "exitTitle": MessageLookupByLibrary.simpleMessage(
            "Cannot access external storage"),
        "expandOptions": MessageLookupByLibrary.simpleMessage("Expand options"),
        "fileCreateDate":
            MessageLookupByLibrary.simpleMessage("Create date of file"),
        "fileCreateTime":
            MessageLookupByLibrary.simpleMessage("Create time of file"),
        "fileManagerBackButton": MessageLookupByLibrary.simpleMessage("Back"),
        "fileManagerSaveButton":
            MessageLookupByLibrary.simpleMessage("Add selections to the list"),
        "fileManagerSortButton":
            MessageLookupByLibrary.simpleMessage("Sort by"),
        "fileManagerStorageButton":
            MessageLookupByLibrary.simpleMessage("Select storage"),
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
        "indexOne":
            MessageLookupByLibrary.simpleMessage("First character index"),
        "indexTwo":
            MessageLookupByLibrary.simpleMessage("Second character index"),
        "insert": MessageLookupByLibrary.simpleMessage("Insert"),
        "insertBeforeIndex":
            MessageLookupByLibrary.simpleMessage("Insert before index"),
        "insertIndex": MessageLookupByLibrary.simpleMessage("Insert index"),
        "insertTagInsideAnother": MessageLookupByLibrary.simpleMessage(
            "Do not insert a tag inside another tag."),
        "insertToString": m1,
        "insertedText":
            MessageLookupByLibrary.simpleMessage("Text to be inserted"),
        "iosRemindContent": MessageLookupByLibrary.simpleMessage(
            "To pick files on iOS, first choose the directory where your files are located. Then, within the selected folder, pick the files you want to rename. Due to the restrictions of iOS, we have to use a two-step process, which ensures safe file management. Let\'s get started!"),
        "iosRemindTitle":
            MessageLookupByLibrary.simpleMessage("About picking files on iOS"),
        "isRegex": MessageLookupByLibrary.simpleMessage("Is regex"),
        "keepCharacters": MessageLookupByLibrary.simpleMessage(
            "Keep characters between them"),
        "language": MessageLookupByLibrary.simpleMessage("Language: "),
        "limit": MessageLookupByLibrary.simpleMessage("limit"),
        "lowercaseAppName": MessageLookupByLibrary.simpleMessage("renamer"),
        "me": MessageLookupByLibrary.simpleMessage("Montenegrin"),
        "metadataParserNotProvided": MessageLookupByLibrary.simpleMessage(
            "Contains metadata tag while MetadataParser was not provided."),
        "metadataTags": MessageLookupByLibrary.simpleMessage("Metadata tags"),
        "mk": MessageLookupByLibrary.simpleMessage("Macedonian"),
        "mn": MessageLookupByLibrary.simpleMessage("Mongolian"),
        "musicAlbumArtist":
            MessageLookupByLibrary.simpleMessage("Name of the album artist"),
        "musicAlbumLength": MessageLookupByLibrary.simpleMessage(
            "Number of tracks in the album"),
        "musicAlbumName":
            MessageLookupByLibrary.simpleMessage("Name of the album"),
        "musicAuthor":
            MessageLookupByLibrary.simpleMessage("Author of the track"),
        "musicDiscNumber":
            MessageLookupByLibrary.simpleMessage("Position of disc"),
        "musicGenres":
            MessageLookupByLibrary.simpleMessage("Art type of the music"),
        "musicTrackArtist": MessageLookupByLibrary.simpleMessage(
            "Names of the artists performing in the track"),
        "musicTrackDuration":
            MessageLookupByLibrary.simpleMessage("Duration of the track"),
        "musicTrackName":
            MessageLookupByLibrary.simpleMessage("Name of the track"),
        "musicTrackNumber": MessageLookupByLibrary.simpleMessage(
            "Position of track in the album"),
        "musicWriter":
            MessageLookupByLibrary.simpleMessage("Writer of the track"),
        "musicYear": MessageLookupByLibrary.simpleMessage(
            "Publishing year of the track"),
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
        "removeCharacters": MessageLookupByLibrary.simpleMessage(
            "Remove characters between them"),
        "removeRenamed": MessageLookupByLibrary.simpleMessage("Remove renamed"),
        "removeRule": MessageLookupByLibrary.simpleMessage("Remove this rule"),
        "removeRules":
            MessageLookupByLibrary.simpleMessage("Remove rules after renaming"),
        "removeToString": m3,
        "rename": MessageLookupByLibrary.simpleMessage("Rename"),
        "replace": MessageLookupByLibrary.simpleMessage("Replace"),
        "replaceToString": m4,
        "replacement": MessageLookupByLibrary.simpleMessage("Replacement"),
        "ru": MessageLookupByLibrary.simpleMessage("Russian"),
        "rulesSequentially": MessageLookupByLibrary.simpleMessage(
            "Rules are executed sequentially. Hold the \'=\' button on the left and drag it to sort rules."),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "select": MessageLookupByLibrary.simpleMessage("Select"),
        "selectAll": MessageLookupByLibrary.simpleMessage("Select All"),
        "semanticNumberWithDirection": MessageLookupByLibrary.simpleMessage(
            "Switching counting direction between from the beginning and from the end"),
        "semanticSwitchNumberToStartAndToEnd": m5,
        "semanticsDropdownButton": m6,
        "semanticsFileManagerDirSubtitle": m7,
        "semanticsFileManagerSubtitle": m8,
        "semanticsFileManagerTitle": m9,
        "semanticsFilesDropdownButton": MessageLookupByLibrary.simpleMessage(
            ". Select this item to restrict renaming targets."),
        "semanticsMultipleActionsHint": MessageLookupByLibrary.simpleMessage(
            ", switch between actions by a vertical swipe gesture"),
        "semanticsOpenMetadataDialog": MessageLookupByLibrary.simpleMessage(
            "Double tap to open a dialog and select a metadata tag to be inserted."),
        "semanticsReorderableList": MessageLookupByLibrary.simpleMessage(
            "This is the rule list, it is empty now. Click the \'Add rule\' button to add one. Rules are executed sequentially. This list is reorderable, allowing you to move a rule up, down, and to the top or bottom. When the cursor is on a rule, use a vertical swipe gesture to switch between actions, and use a double click to execute the selected action."),
        "semanticsRuleDropdownButton": MessageLookupByLibrary.simpleMessage(
            ". Select and then click the \"Add Rule\" button to add this rule."),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Source code"),
        "sr": MessageLookupByLibrary.simpleMessage("Serbian"),
        "startIndex": MessageLookupByLibrary.simpleMessage("Start index"),
        "target": MessageLookupByLibrary.simpleMessage("target"),
        "tj": MessageLookupByLibrary.simpleMessage("Tajik"),
        "toLast": MessageLookupByLibrary.simpleMessage("-to-last"),
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
        "transliterateToString": m10,
        "transliterateToStringCyrillic": m11,
        "transliterateTraditional": MessageLookupByLibrary.simpleMessage(
            "Chinese characters to traditional Chinese"),
        "transliterateUpper": MessageLookupByLibrary.simpleMessage(
            "Latin characters to upper case"),
        "truncate": MessageLookupByLibrary.simpleMessage("Truncate"),
        "truncateToString": m12,
        "ua": MessageLookupByLibrary.simpleMessage("Ukrainian")
      };
}
