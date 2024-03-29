// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class L10n {
  L10n();

  static L10n? _current;

  static L10n get current {
    assert(_current != null,
        'No instance of L10n was loaded. Try to initialize the L10n delegate before accessing L10n.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<L10n> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = L10n();
      L10n._current = instance;

      return instance;
    });
  }

  static L10n of(BuildContext context) {
    final instance = L10n.maybeOf(context);
    assert(instance != null,
        'No instance of L10n present in the widget tree. Did you add L10n.delegate in localizationsDelegates?');
    return instance!;
  }

  static L10n? maybeOf(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  /// `Flut Renamer`
  String get appName {
    return Intl.message(
      'Flut Renamer',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `flut renamer`
  String get lowercaseAppName {
    return Intl.message(
      'flut renamer',
      name: 'lowercaseAppName',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Permission for external storage`
  String get permissionTitle {
    return Intl.message(
      'Permission for external storage',
      name: 'permissionTitle',
      desc: '',
      args: [],
    );
  }

  /// `To provide you with our file renaming service, we need your permission to manage external storage. This allows us to access and rename files stored on your device. Without this permission, the app won't be able to access the complete file paths and therefore can't rename files. We assure you that your privacy and security are our top priorities, and we only access files for the purpose of renaming.`
  String get permissionContent {
    return Intl.message(
      'To provide you with our file renaming service, we need your permission to manage external storage. This allows us to access and rename files stored on your device. Without this permission, the app won\'t be able to access the complete file paths and therefore can\'t rename files. We assure you that your privacy and security are our top priorities, and we only access files for the purpose of renaming.',
      name: 'permissionContent',
      desc: '',
      args: [],
    );
  }

  /// `Cannot access external storage`
  String get exitTitle {
    return Intl.message(
      'Cannot access external storage',
      name: 'exitTitle',
      desc: '',
      args: [],
    );
  }

  /// `The manage external storage permission allows us to access and rename files stored on your device. Without this permission, the app won't be able to access the complete file paths and therefore can't rename files. Please go to the Settings page and grant the permission manually; otherwise, we cannot provide any service.`
  String get exitContent {
    return Intl.message(
      'The manage external storage permission allows us to access and rename files stored on your device. Without this permission, the app won\'t be able to access the complete file paths and therefore can\'t rename files. Please go to the Settings page and grant the permission manually; otherwise, we cannot provide any service.',
      name: 'exitContent',
      desc: '',
      args: [],
    );
  }

  /// `About picking files on iOS`
  String get iosRemindTitle {
    return Intl.message(
      'About picking files on iOS',
      name: 'iosRemindTitle',
      desc: '',
      args: [],
    );
  }

  /// `To pick files on iOS, first choose the directory where your files are located. Then, within the selected folder, pick the files you want to rename. Due to the restrictions of iOS, we have to use a two-step process, which ensures safe file management. Let's get started!`
  String get iosRemindContent {
    return Intl.message(
      'To pick files on iOS, first choose the directory where your files are located. Then, within the selected folder, pick the files you want to rename. Due to the restrictions of iOS, we have to use a two-step process, which ensures safe file management. Let\'s get started!',
      name: 'iosRemindContent',
      desc: '',
      args: [],
    );
  }

  /// `Rename directory`
  String get androidRemindTitle {
    return Intl.message(
      'Rename directory',
      name: 'androidRemindTitle',
      desc: '',
      args: [],
    );
  }

  /// `Using the Flut Renamer, you can rename not only files but also directories. Long-press a directory to select it, and select 'Files & Dirs' from the dropdown button in the upper-left corner to enable directory renaming. For security reasons, some system reserved directories are not selectable.`
  String get androidRemindContent {
    return Intl.message(
      'Using the Flut Renamer, you can rename not only files but also directories. Long-press a directory to select it, and select \'Files & Dirs\' from the dropdown button in the upper-left corner to enable directory renaming. For security reasons, some system reserved directories are not selectable.',
      name: 'androidRemindContent',
      desc: '',
      args: [],
    );
  }

  /// `OK. Do not remind me again.`
  String get doNotRemindAgain {
    return Intl.message(
      'OK. Do not remind me again.',
      name: 'doNotRemindAgain',
      desc: '',
      args: [],
    );
  }

  /// `Rename`
  String get rename {
    return Intl.message(
      'Rename',
      name: 'rename',
      desc: '',
      args: [],
    );
  }

  /// `App info`
  String get appInfo {
    return Intl.message(
      'App info',
      name: 'appInfo',
      desc: '',
      args: [],
    );
  }

  /// `This application is designed to help users rename their files. It is built with Flutter - a multi-platform application framework, and therefore it is also available on other operating systems. It is totally open source and can be reviewed or contributed to.`
  String get aboutContent {
    return Intl.message(
      'This application is designed to help users rename their files. It is built with Flutter - a multi-platform application framework, and therefore it is also available on other operating systems. It is totally open source and can be reviewed or contributed to.',
      name: 'aboutContent',
      desc: '',
      args: [],
    );
  }

  /// `Rating the app`
  String get rating {
    return Intl.message(
      'Rating the app',
      name: 'rating',
      desc: '',
      args: [],
    );
  }

  /// `Rate Our App`
  String get ratingTitle {
    return Intl.message(
      'Rate Our App',
      name: 'ratingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enjoying our app? Help us grow by giving it a quick rating on the store or GitHub. Your feedback means the world to us! Thanks for your support.`
  String get ratingContent {
    return Intl.message(
      'Enjoying our app? Help us grow by giving it a quick rating on the store or GitHub. Your feedback means the world to us! Thanks for your support.',
      name: 'ratingContent',
      desc: '',
      args: [],
    );
  }

  /// `Rate the app on store`
  String get ratingStore {
    return Intl.message(
      'Rate the app on store',
      name: 'ratingStore',
      desc: '',
      args: [],
    );
  }

  /// `Star it on Github`
  String get ratingGithub {
    return Intl.message(
      'Star it on Github',
      name: 'ratingGithub',
      desc: '',
      args: [],
    );
  }

  /// `Source code`
  String get sourceCode {
    return Intl.message(
      'Source code',
      name: 'sourceCode',
      desc: '',
      args: [],
    );
  }

  /// `Collapse options`
  String get collapseOptions {
    return Intl.message(
      'Collapse options',
      name: 'collapseOptions',
      desc: '',
      args: [],
    );
  }

  /// `Expand options`
  String get expandOptions {
    return Intl.message(
      'Expand options',
      name: 'expandOptions',
      desc: '',
      args: [],
    );
  }

  /// `Only selected`
  String get onlySelected {
    return Intl.message(
      'Only selected',
      name: 'onlySelected',
      desc: '',
      args: [],
    );
  }

  /// `Remove renamed files`
  String get removeRenamed {
    return Intl.message(
      'Remove renamed files',
      name: 'removeRenamed',
      desc: '',
      args: [],
    );
  }

  /// `Remove this rule`
  String get removeRule {
    return Intl.message(
      'Remove this rule',
      name: 'removeRule',
      desc: '',
      args: [],
    );
  }

  /// `Remove rules after renaming`
  String get removeRules {
    return Intl.message(
      'Remove rules after renaming',
      name: 'removeRules',
      desc: '',
      args: [],
    );
  }

  /// `Add Rule`
  String get addRule {
    return Intl.message(
      'Add Rule',
      name: 'addRule',
      desc: '',
      args: [],
    );
  }

  /// `Remove all`
  String get removeAll {
    return Intl.message(
      'Remove all',
      name: 'removeAll',
      desc: '',
      args: [],
    );
  }

  /// `Replace`
  String get replace {
    return Intl.message(
      'Replace',
      name: 'replace',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Insert`
  String get insert {
    return Intl.message(
      'Insert',
      name: 'insert',
      desc: '',
      args: [],
    );
  }

  /// `Increment`
  String get increment {
    return Intl.message(
      'Increment',
      name: 'increment',
      desc: '',
      args: [],
    );
  }

  /// `Rearrange`
  String get rearrange {
    return Intl.message(
      'Rearrange',
      name: 'rearrange',
      desc: '',
      args: [],
    );
  }

  /// `Transliterate`
  String get transliterate {
    return Intl.message(
      'Transliterate',
      name: 'transliterate',
      desc: '',
      args: [],
    );
  }

  /// `Truncate`
  String get truncate {
    return Intl.message(
      'Truncate',
      name: 'truncate',
      desc: '',
      args: [],
    );
  }

  /// `Cancel All`
  String get cancelAll {
    return Intl.message(
      'Cancel All',
      name: 'cancelAll',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Select All`
  String get selectAll {
    return Intl.message(
      'Select All',
      name: 'selectAll',
      desc: '',
      args: [],
    );
  }

  /// `Current name`
  String get currentName {
    return Intl.message(
      'Current name',
      name: 'currentName',
      desc: '',
      args: [],
    );
  }

  /// `New name`
  String get newName {
    return Intl.message(
      'New name',
      name: 'newName',
      desc: '',
      args: [],
    );
  }

  /// `File not exist`
  String get fileNotExist {
    return Intl.message(
      'File not exist',
      name: 'fileNotExist',
      desc: '',
      args: [],
    );
  }

  /// `Files`
  String get files {
    return Intl.message(
      'Files',
      name: 'files',
      desc: '',
      args: [],
    );
  }

  /// `Directories`
  String get directories {
    return Intl.message(
      'Directories',
      name: 'directories',
      desc: '',
      args: [],
    );
  }

  /// `Files & Dirs`
  String get filesDirs {
    return Intl.message(
      'Files & Dirs',
      name: 'filesDirs',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Add file`
  String get addFile {
    return Intl.message(
      'Add file',
      name: 'addFile',
      desc: '',
      args: [],
    );
  }

  /// `Add files`
  String get addFiles {
    return Intl.message(
      'Add files',
      name: 'addFiles',
      desc: '',
      args: [],
    );
  }

  /// `Drag and drop to add files.`
  String get dragToAdd {
    return Intl.message(
      'Drag and drop to add files.',
      name: 'dragToAdd',
      desc: '',
      args: [],
    );
  }

  /// `Drop to add files.`
  String get dropToAdd {
    return Intl.message(
      'Drop to add files.',
      name: 'dropToAdd',
      desc: '',
      args: [],
    );
  }

  /// `Due to system security restriction, drag-drop files from this app is not supported.`
  String get dragNotSupported {
    return Intl.message(
      'Due to system security restriction, drag-drop files from this app is not supported.',
      name: 'dragNotSupported',
      desc: '',
      args: [],
    );
  }

  /// `Filename already used by another file`
  String get fileAlreadyExists {
    return Intl.message(
      'Filename already used by another file',
      name: 'fileAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Rename failed`
  String get renameFailed {
    return Intl.message(
      'Rename failed',
      name: 'renameFailed',
      desc: '',
      args: [],
    );
  }

  /// `Rules are executed sequentially. Click a rule to edit it. Hold the '=' button on the left and drag it to sort rules.`
  String get rulesSequentially {
    return Intl.message(
      'Rules are executed sequentially. Click a rule to edit it. Hold the \'=\' button on the left and drag it to sort rules.',
      name: 'rulesSequentially',
      desc: '',
      args: [],
    );
  }

  /// `Do not rename a system reserved directory.`
  String get noSysDir {
    return Intl.message(
      'Do not rename a system reserved directory.',
      name: 'noSysDir',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get fileSortName {
    return Intl.message(
      'Name',
      name: 'fileSortName',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get fileSortSize {
    return Intl.message(
      'Size',
      name: 'fileSortSize',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get fileSortDate {
    return Intl.message(
      'Date',
      name: 'fileSortDate',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get fileSortType {
    return Intl.message(
      'Type',
      name: 'fileSortType',
      desc: '',
      args: [],
    );
  }

  /// `Latin characters to upper case`
  String get transliterateUpper {
    return Intl.message(
      'Latin characters to upper case',
      name: 'transliterateUpper',
      desc: '',
      args: [],
    );
  }

  /// `Latin characters to lower case`
  String get transliterateLower {
    return Intl.message(
      'Latin characters to lower case',
      name: 'transliterateLower',
      desc: '',
      args: [],
    );
  }

  /// `Chinese characters to traditional Chinese`
  String get transliterateTraditional {
    return Intl.message(
      'Chinese characters to traditional Chinese',
      name: 'transliterateTraditional',
      desc: '',
      args: [],
    );
  }

  /// `Chinese characters to simplified Chinese`
  String get transliterateSimplified {
    return Intl.message(
      'Chinese characters to simplified Chinese',
      name: 'transliterateSimplified',
      desc: '',
      args: [],
    );
  }

  /// `Chinese characters to pinyin`
  String get transliteratePinyin {
    return Intl.message(
      'Chinese characters to pinyin',
      name: 'transliteratePinyin',
      desc: '',
      args: [],
    );
  }

  /// `Cyrillic characters to Latin`
  String get transliterateCyrillic2Latin {
    return Intl.message(
      'Cyrillic characters to Latin',
      name: 'transliterateCyrillic2Latin',
      desc: '',
      args: [],
    );
  }

  /// `Latin characters to Cyrillic`
  String get transliterateLatin2Cyrillic {
    return Intl.message(
      'Latin characters to Cyrillic',
      name: 'transliterateLatin2Cyrillic',
      desc: '',
      args: [],
    );
  }

  /// `Do not insert a tag inside another tag.`
  String get insertTagInsideAnother {
    return Intl.message(
      'Do not insert a tag inside another tag.',
      name: 'insertTagInsideAnother',
      desc: '',
      args: [],
    );
  }

  /// `Application error`
  String get appError {
    return Intl.message(
      'Application error',
      name: 'appError',
      desc: '',
      args: [],
    );
  }

  /// `Error details`
  String get errorDetails {
    return Intl.message(
      'Error details',
      name: 'errorDetails',
      desc: '',
      args: [],
    );
  }

  /// `If files does not shown in file list, please clear all and continue.`
  String get ifFileNotShown {
    return Intl.message(
      'If files does not shown in file list, please clear all and continue.',
      name: 'ifFileNotShown',
      desc: '',
      args: [],
    );
  }

  /// `Metadata tags`
  String get metadataTags {
    return Intl.message(
      'Metadata tags',
      name: 'metadataTags',
      desc: '',
      args: [],
    );
  }

  /// `Date of today`
  String get osTodayDate {
    return Intl.message(
      'Date of today',
      name: 'osTodayDate',
      desc: '',
      args: [],
    );
  }

  /// `Time of now`
  String get osNowTime {
    return Intl.message(
      'Time of now',
      name: 'osNowTime',
      desc: '',
      args: [],
    );
  }

  /// `Size of file`
  String get fileSize {
    return Intl.message(
      'Size of file',
      name: 'fileSize',
      desc: '',
      args: [],
    );
  }

  /// `Create date of file`
  String get fileCreateDate {
    return Intl.message(
      'Create date of file',
      name: 'fileCreateDate',
      desc: '',
      args: [],
    );
  }

  /// `Create time of file`
  String get fileCreateTime {
    return Intl.message(
      'Create time of file',
      name: 'fileCreateTime',
      desc: '',
      args: [],
    );
  }

  /// `Modify date of file`
  String get fileModifyDate {
    return Intl.message(
      'Modify date of file',
      name: 'fileModifyDate',
      desc: '',
      args: [],
    );
  }

  /// `Modify time of file`
  String get fileModifyTime {
    return Intl.message(
      'Modify time of file',
      name: 'fileModifyTime',
      desc: '',
      args: [],
    );
  }

  /// `Photographing date from exif`
  String get photoDate {
    return Intl.message(
      'Photographing date from exif',
      name: 'photoDate',
      desc: '',
      args: [],
    );
  }

  /// `Photographing time from exif`
  String get photoTime {
    return Intl.message(
      'Photographing time from exif',
      name: 'photoTime',
      desc: '',
      args: [],
    );
  }

  /// `Camera name from exif`
  String get photoCamName {
    return Intl.message(
      'Camera name from exif',
      name: 'photoCamName',
      desc: '',
      args: [],
    );
  }

  /// `Lens name from exif`
  String get photoLensName {
    return Intl.message(
      'Lens name from exif',
      name: 'photoLensName',
      desc: '',
      args: [],
    );
  }

  /// `Focal length from exif`
  String get photoFocalLength {
    return Intl.message(
      'Focal length from exif',
      name: 'photoFocalLength',
      desc: '',
      args: [],
    );
  }

  /// `Aperture value from exif`
  String get photoAperture {
    return Intl.message(
      'Aperture value from exif',
      name: 'photoAperture',
      desc: '',
      args: [],
    );
  }

  /// `Shutter speed from exif`
  String get photoShutter {
    return Intl.message(
      'Shutter speed from exif',
      name: 'photoShutter',
      desc: '',
      args: [],
    );
  }

  /// `ISO value from exif`
  String get photoISO {
    return Intl.message(
      'ISO value from exif',
      name: 'photoISO',
      desc: '',
      args: [],
    );
  }

  /// `Longitude of photo GPS from exif`
  String get photoLongitude {
    return Intl.message(
      'Longitude of photo GPS from exif',
      name: 'photoLongitude',
      desc: '',
      args: [],
    );
  }

  /// `Latitude of photo GPS from exif`
  String get photoLatitude {
    return Intl.message(
      'Latitude of photo GPS from exif',
      name: 'photoLatitude',
      desc: '',
      args: [],
    );
  }

  /// `Altitude of photo GPS from exif`
  String get photoAltitude {
    return Intl.message(
      'Altitude of photo GPS from exif',
      name: 'photoAltitude',
      desc: '',
      args: [],
    );
  }

  /// `Photographer name from exif`
  String get photoPhotographer {
    return Intl.message(
      'Photographer name from exif',
      name: 'photoPhotographer',
      desc: '',
      args: [],
    );
  }

  /// `Copyright holder name from exif`
  String get photoCopyright {
    return Intl.message(
      'Copyright holder name from exif',
      name: 'photoCopyright',
      desc: '',
      args: [],
    );
  }

  /// `Name of the album`
  String get musicAlbumName {
    return Intl.message(
      'Name of the album',
      name: 'musicAlbumName',
      desc: '',
      args: [],
    );
  }

  /// `Name of the album artist`
  String get musicAlbumArtist {
    return Intl.message(
      'Name of the album artist',
      name: 'musicAlbumArtist',
      desc: '',
      args: [],
    );
  }

  /// `Number of tracks in the album`
  String get musicAlbumLength {
    return Intl.message(
      'Number of tracks in the album',
      name: 'musicAlbumLength',
      desc: '',
      args: [],
    );
  }

  /// `Publishing year of the track`
  String get musicYear {
    return Intl.message(
      'Publishing year of the track',
      name: 'musicYear',
      desc: '',
      args: [],
    );
  }

  /// `Duration of the track`
  String get musicTrackDuration {
    return Intl.message(
      'Duration of the track',
      name: 'musicTrackDuration',
      desc: '',
      args: [],
    );
  }

  /// `Name of the track`
  String get musicTrackName {
    return Intl.message(
      'Name of the track',
      name: 'musicTrackName',
      desc: '',
      args: [],
    );
  }

  /// `Names of the artists performing in the track`
  String get musicTrackArtist {
    return Intl.message(
      'Names of the artists performing in the track',
      name: 'musicTrackArtist',
      desc: '',
      args: [],
    );
  }

  /// `Position of track in the album`
  String get musicTrackNumber {
    return Intl.message(
      'Position of track in the album',
      name: 'musicTrackNumber',
      desc: '',
      args: [],
    );
  }

  /// `Position of disc`
  String get musicDiscNumber {
    return Intl.message(
      'Position of disc',
      name: 'musicDiscNumber',
      desc: '',
      args: [],
    );
  }

  /// `Art type of the music`
  String get musicGenres {
    return Intl.message(
      'Art type of the music',
      name: 'musicGenres',
      desc: '',
      args: [],
    );
  }

  /// `Author of the track`
  String get musicAuthor {
    return Intl.message(
      'Author of the track',
      name: 'musicAuthor',
      desc: '',
      args: [],
    );
  }

  /// `Writer of the track`
  String get musicWriter {
    return Intl.message(
      'Writer of the track',
      name: 'musicWriter',
      desc: '',
      args: [],
    );
  }

  /// `Prefix`
  String get prefix {
    return Intl.message(
      'Prefix',
      name: 'prefix',
      desc: '',
      args: [],
    );
  }

  /// `Start index`
  String get startIndex {
    return Intl.message(
      'Start index',
      name: 'startIndex',
      desc: '',
      args: [],
    );
  }

  /// `Index incremental step`
  String get indexIncrementalStep {
    return Intl.message(
      'Index incremental step',
      name: 'indexIncrementalStep',
      desc: '',
      args: [],
    );
  }

  /// `Omit dash`
  String get omitDash {
    return Intl.message(
      'Omit dash',
      name: 'omitDash',
      desc: '',
      args: [],
    );
  }

  /// `Ignore Extension`
  String get ignoreExtension {
    return Intl.message(
      'Ignore Extension',
      name: 'ignoreExtension',
      desc: '',
      args: [],
    );
  }

  /// `Text to be inserted`
  String get insertedText {
    return Intl.message(
      'Text to be inserted',
      name: 'insertedText',
      desc: '',
      args: [],
    );
  }

  /// `Insert index`
  String get insertIndex {
    return Intl.message(
      'Insert index',
      name: 'insertIndex',
      desc: '',
      args: [],
    );
  }

  /// `From start`
  String get fromStart {
    return Intl.message(
      'From start',
      name: 'fromStart',
      desc: '',
      args: [],
    );
  }

  /// `Insert before index`
  String get insertBeforeIndex {
    return Intl.message(
      'Insert before index',
      name: 'insertBeforeIndex',
      desc: '',
      args: [],
    );
  }

  /// `Rearrange delimiter`
  String get rearrangeDelimiter {
    return Intl.message(
      'Rearrange delimiter',
      name: 'rearrangeDelimiter',
      desc: '',
      args: [],
    );
  }

  /// `Rearrange order`
  String get rearrangeOrderLabel {
    return Intl.message(
      'Rearrange order',
      name: 'rearrangeOrderLabel',
      desc: '',
      args: [],
    );
  }

  /// `numbers separated with comma`
  String get rearrangeOrderHint {
    return Intl.message(
      'numbers separated with comma',
      name: 'rearrangeOrderHint',
      desc: '',
      args: [],
    );
  }

  /// `target`
  String get target {
    return Intl.message(
      'target',
      name: 'target',
      desc: '',
      args: [],
    );
  }

  /// `Replacement`
  String get replacement {
    return Intl.message(
      'Replacement',
      name: 'replacement',
      desc: '',
      args: [],
    );
  }

  /// `limit`
  String get limit {
    return Intl.message(
      'limit',
      name: 'limit',
      desc: '',
      args: [],
    );
  }

  /// `Case sensitive`
  String get caseSensitive {
    return Intl.message(
      'Case sensitive',
      name: 'caseSensitive',
      desc: '',
      args: [],
    );
  }

  /// `Is regex`
  String get isRegex {
    return Intl.message(
      'Is regex',
      name: 'isRegex',
      desc: '',
      args: [],
    );
  }

  /// `Language: `
  String get language {
    return Intl.message(
      'Language: ',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `First character index`
  String get indexOne {
    return Intl.message(
      'First character index',
      name: 'indexOne',
      desc: '',
      args: [],
    );
  }

  /// `Second character index`
  String get indexTwo {
    return Intl.message(
      'Second character index',
      name: 'indexTwo',
      desc: '',
      args: [],
    );
  }

  /// `-to-last`
  String get toLast {
    return Intl.message(
      '-to-last',
      name: 'toLast',
      desc: '',
      args: [],
    );
  }

  /// `Going forward`
  String get goingForward {
    return Intl.message(
      'Going forward',
      name: 'goingForward',
      desc: '',
      args: [],
    );
  }

  /// `Keep characters between them`
  String get keepCharacters {
    return Intl.message(
      'Keep characters between them',
      name: 'keepCharacters',
      desc: '',
      args: [],
    );
  }

  /// `Remove characters between them`
  String get removeCharacters {
    return Intl.message(
      'Remove characters between them',
      name: 'removeCharacters',
      desc: '',
      args: [],
    );
  }

  /// `Contains metadata tag while MetadataParser was not provided.`
  String get metadataParserNotProvided {
    return Intl.message(
      'Contains metadata tag while MetadataParser was not provided.',
      name: 'metadataParserNotProvided',
      desc: '',
      args: [],
    );
  }

  /// `Replace "{targetString}" with "{replacementString}".`
  String replaceToString(String targetString, String replacementString) {
    return Intl.message(
      'Replace "$targetString" with "$replacementString".',
      name: 'replaceToString',
      desc: '',
      args: [targetString, replacementString],
    );
  }

  /// `Remove "{targetString}"`
  String removeToString(String targetString) {
    return Intl.message(
      'Remove "$targetString"',
      name: 'removeToString',
      desc: '',
      args: [targetString],
    );
  }

  /// `Insert "{insert}" at the {insertIndex}{ordinal, select, o1{st} o2{nd} o3{rd} other{th}}{toEnd, select, true{-to-end} false{} other{}} character.`
  String insertToString(
      String toEnd, String ordinal, String insert, num insertIndex) {
    return Intl.message(
      'Insert "$insert" at the $insertIndex${Intl.select(ordinal, {
            'o1': 'st',
            'o2': 'nd',
            'o3': 'rd',
            'other': 'th'
          })}${Intl.select(toEnd, {
            'true': '-to-end',
            'false': '',
            'other': ''
          })} character.',
      name: 'insertToString',
      desc: '',
      args: [toEnd, ordinal, insert, insertIndex],
    );
  }

  /// `Incremental renaming: {prefix}-index`
  String incrementToString(String prefix) {
    return Intl.message(
      'Incremental renaming: $prefix-index',
      name: 'incrementToString',
      desc: '',
      args: [prefix],
    );
  }

  /// `Rearrange: delimiter: {delimiter}, order: {order}.`
  String rearrangeToString(String delimiter, String order) {
    return Intl.message(
      'Rearrange: delimiter: $delimiter, order: $order.',
      name: 'rearrangeToString',
      desc: '',
      args: [delimiter, order],
    );
  }

  /// `Transliterate: convert {type}.`
  String transliterateToString(String type) {
    return Intl.message(
      'Transliterate: convert $type.',
      name: 'transliterateToString',
      desc: '',
      args: [type],
    );
  }

  /// `Transliterate: convert {langName} {type}.`
  String transliterateToStringCyrillic(String langName, String type) {
    return Intl.message(
      'Transliterate: convert $langName $type.',
      name: 'transliterateToStringCyrillic',
      desc: '',
      args: [langName, type],
    );
  }

  /// `Truncate: {keepType, select, true{keep only} false{remove} other{}} characters between the {iOne}{iTwoOrdinal, select, o1{st} o2{nd} o3{rd} other{th}}{iOneToEnd, select, true{-to-end} false{} other{}} character and the {iTwo}{iOneOrdinal, select, o1{st} o2{nd} o3{rd} other{th}}{iTwoToEnd, select, true{-to-end} false{} other{}}.`
  String truncateToString(
      String iTwoToEnd,
      String iOneOrdinal,
      String iOneToEnd,
      String iTwoOrdinal,
      String keepType,
      num iOne,
      num iTwo) {
    return Intl.message(
      'Truncate: ${Intl.select(keepType, {
            'true': 'keep only',
            'false': 'remove',
            'other': ''
          })} characters between the $iOne${Intl.select(iTwoOrdinal, {
            'o1': 'st',
            'o2': 'nd',
            'o3': 'rd',
            'other': 'th'
          })}${Intl.select(iOneToEnd, {
            'true': '-to-end',
            'false': '',
            'other': ''
          })} character and the $iTwo${Intl.select(iOneOrdinal, {
            'o1': 'st',
            'o2': 'nd',
            'o3': 'rd',
            'other': 'th'
          })}${Intl.select(iTwoToEnd, {
            'true': '-to-end',
            'false': '',
            'other': ''
          })}.',
      name: 'truncateToString',
      desc: '',
      args: [
        iTwoToEnd,
        iOneOrdinal,
        iOneToEnd,
        iTwoOrdinal,
        keepType,
        iOne,
        iTwo
      ],
    );
  }

  /// `Replace the specified text (or text matching the provided regular expression) with the given replacement text (or file metadata and EXIF data).`
  String get descriptionReplace {
    return Intl.message(
      'Replace the specified text (or text matching the provided regular expression) with the given replacement text (or file metadata and EXIF data).',
      name: 'descriptionReplace',
      desc: '',
      args: [],
    );
  }

  /// `Remove the specified text (or text matching the provided regular expression) from the filename.`
  String get descriptionRemove {
    return Intl.message(
      'Remove the specified text (or text matching the provided regular expression) from the filename.',
      name: 'descriptionRemove',
      desc: '',
      args: [],
    );
  }

  /// `Insert the specified text (or file metadata and EXIF data) at the designated position.`
  String get descriptionInsert {
    return Intl.message(
      'Insert the specified text (or file metadata and EXIF data) at the designated position.',
      name: 'descriptionInsert',
      desc: '',
      args: [],
    );
  }

  /// `Increment the filename, e.g., Photo-1, Photo-2, Photo-3.`
  String get descriptionIncrement {
    return Intl.message(
      'Increment the filename, e.g., Photo-1, Photo-2, Photo-3.',
      name: 'descriptionIncrement',
      desc: '',
      args: [],
    );
  }

  /// `Splitting the filename by the user-specified delimiter and rearrange segments according to the provided order.`
  String get descriptionRearrange {
    return Intl.message(
      'Splitting the filename by the user-specified delimiter and rearrange segments according to the provided order.',
      name: 'descriptionRearrange',
      desc: '',
      args: [],
    );
  }

  /// `Transliterate characters according to predefined specifications, including converting characters to upper or lower case, converting between character sets, or converting characters to phonetic equivalents.`
  String get descriptionTransliterate {
    return Intl.message(
      'Transliterate characters according to predefined specifications, including converting characters to upper or lower case, converting between character sets, or converting characters to phonetic equivalents.',
      name: 'descriptionTransliterate',
      desc: '',
      args: [],
    );
  }

  /// `Remove or keep the specified part of the filename, starting from one designated position to another.`
  String get descriptionTruncate {
    return Intl.message(
      'Remove or keep the specified part of the filename, starting from one designated position to another.',
      name: 'descriptionTruncate',
      desc: '',
      args: [],
    );
  }

  /// `Bulgarian`
  String get bg {
    return Intl.message(
      'Bulgarian',
      name: 'bg',
      desc: '',
      args: [],
    );
  }

  /// `Montenegrin`
  String get me {
    return Intl.message(
      'Montenegrin',
      name: 'me',
      desc: '',
      args: [],
    );
  }

  /// `Macedonian`
  String get mk {
    return Intl.message(
      'Macedonian',
      name: 'mk',
      desc: '',
      args: [],
    );
  }

  /// `Mongolian`
  String get mn {
    return Intl.message(
      'Mongolian',
      name: 'mn',
      desc: '',
      args: [],
    );
  }

  /// `Russian`
  String get ru {
    return Intl.message(
      'Russian',
      name: 'ru',
      desc: '',
      args: [],
    );
  }

  /// `Serbian`
  String get sr {
    return Intl.message(
      'Serbian',
      name: 'sr',
      desc: '',
      args: [],
    );
  }

  /// `Tajik`
  String get tj {
    return Intl.message(
      'Tajik',
      name: 'tj',
      desc: '',
      args: [],
    );
  }

  /// `Ukrainian`
  String get ua {
    return Intl.message(
      'Ukrainian',
      name: 'ua',
      desc: '',
      args: [],
    );
  }

  /// `Sort by`
  String get fileManagerSortButton {
    return Intl.message(
      'Sort by',
      name: 'fileManagerSortButton',
      desc: '',
      args: [],
    );
  }

  /// `Select storage`
  String get fileManagerStorageButton {
    return Intl.message(
      'Select storage',
      name: 'fileManagerStorageButton',
      desc: '',
      args: [],
    );
  }

  /// `Add selections to the list`
  String get fileManagerSaveButton {
    return Intl.message(
      'Add selections to the list',
      name: 'fileManagerSaveButton',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get fileManagerBackButton {
    return Intl.message(
      'Back',
      name: 'fileManagerBackButton',
      desc: '',
      args: [],
    );
  }

  /// `{selectStatus, select, true{Selected} false{Unselected} other{}} {entityType, select, File{File} Directory{Folder} Link{Link} other{File system entity}}, filename is {filename}, `
  String semanticsFileManagerTitle(
      String entityType, String selectStatus, String filename) {
    return Intl.message(
      '${Intl.select(selectStatus, {
            'true': 'Selected',
            'false': 'Unselected',
            'other': ''
          })} ${Intl.select(entityType, {
            'File': 'File',
            'Directory': 'Folder',
            'Link': 'Link',
            'other': 'File system entity'
          })}, filename is $filename, ',
      name: 'semanticsFileManagerTitle',
      desc: '',
      args: [entityType, selectStatus, filename],
    );
  }

  /// `last modified at {last}, sized {size}.`
  String semanticsFileManagerSubtitle(String last, String size) {
    return Intl.message(
      'last modified at $last, sized $size.',
      name: 'semanticsFileManagerSubtitle',
      desc: '',
      args: [last, size],
    );
  }

  /// `last modified at {last}.`
  String semanticsFileManagerDirSubtitle(String last) {
    return Intl.message(
      'last modified at $last.',
      name: 'semanticsFileManagerDirSubtitle',
      desc: '',
      args: [last],
    );
  }

  /// `This is a dropdown button, current value is "{value}", double click to open the it and pick another value.`
  String semanticsDropdownButton(String value) {
    return Intl.message(
      'This is a dropdown button, current value is "$value", double click to open the it and pick another value.',
      name: 'semanticsDropdownButton',
      desc: '',
      args: [value],
    );
  }

  /// `. Select and then click the "Add Rule" button to add this rule.`
  String get semanticsRuleDropdownButton {
    return Intl.message(
      '. Select and then click the "Add Rule" button to add this rule.',
      name: 'semanticsRuleDropdownButton',
      desc: '',
      args: [],
    );
  }

  /// `. Select this item to restrict renaming targets.`
  String get semanticsFilesDropdownButton {
    return Intl.message(
      '. Select this item to restrict renaming targets.',
      name: 'semanticsFilesDropdownButton',
      desc: '',
      args: [],
    );
  }

  /// `This is the rule list, it is empty now. Click the 'Add rule' button to add one. Rules are executed sequentially. This list is reorderable, allowing you to move a rule up, down, and to the top or bottom. When the cursor is on a rule, use a vertical swipe gesture to switch between actions, and use a double click to execute the selected action.`
  String get semanticsReorderableList {
    return Intl.message(
      'This is the rule list, it is empty now. Click the \'Add rule\' button to add one. Rules are executed sequentially. This list is reorderable, allowing you to move a rule up, down, and to the top or bottom. When the cursor is on a rule, use a vertical swipe gesture to switch between actions, and use a double click to execute the selected action.',
      name: 'semanticsReorderableList',
      desc: '',
      args: [],
    );
  }

  /// `Double tap to open a dialog and select a metadata tag to be inserted.`
  String get semanticsOpenMetadataDialog {
    return Intl.message(
      'Double tap to open a dialog and select a metadata tag to be inserted.',
      name: 'semanticsOpenMetadataDialog',
      desc: '',
      args: [],
    );
  }

  /// `, switch between actions by a vertical swipe gesture`
  String get semanticsMultipleActionsHint {
    return Intl.message(
      ', switch between actions by a vertical swipe gesture',
      name: 'semanticsMultipleActionsHint',
      desc: '',
      args: [],
    );
  }

  /// `Switching counting direction between from the beginning and from the end`
  String get semanticNumberWithDirection {
    return Intl.message(
      'Switching counting direction between from the beginning and from the end',
      name: 'semanticNumberWithDirection',
      desc: '',
      args: [],
    );
  }

  /// `Switching counting direction between from the beginning and from the end, currently counting from {toEnd, select, true{the end} false{the beginning} other{}}`
  String semanticSwitchNumberToStartAndToEnd(String toEnd) {
    return Intl.message(
      'Switching counting direction between from the beginning and from the end, currently counting from ${Intl.select(toEnd, {
            'true': 'the end',
            'false': 'the beginning',
            'other': ''
          })}',
      name: 'semanticSwitchNumberToStartAndToEnd',
      desc: '',
      args: [toEnd],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<L10n> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'th'),
      Locale.fromSubtags(languageCode: 'tr'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<L10n> load(Locale locale) => L10n.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
