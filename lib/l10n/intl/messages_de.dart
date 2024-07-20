// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  static String m0(prefix) => "Inkrementieren: ${prefix}-Index";

  static String m1(toEnd, ordinal, insert, insertIndex) =>
      "Einfügen: \"${insert}\" an Position ${insertIndex}${Intl.select(toEnd, {
            'true': ' von hinten',
            'other': '',
          })}.";

  static String m2(delimiter, order) =>
      "Neu anordnen: Trennzeichen: ${delimiter}, Reihenfolge: ${order}.";

  static String m3(targetString) => "Entfernen: \"${targetString}\"";

  static String m4(targetString, replacementString) =>
      "Ersetzen: \"${targetString}\" durch \"${replacementString}\" ersetzen.";

  static String m5(toEnd) =>
      "Wechseln der Zählrichtung zwischen vom Anfang und vom Ende, aktuell wird gezählt ab ${Intl.select(toEnd, {
            'true': 'dem Ende',
            'false': 'dem Anfang',
            'other': '',
          })}";

  static String m6(value) =>
      "Dies ist eine Dropdown-Schaltfläche. Die aktuelle Auswahl ist \"${value}\". Doppelklicken Sie, um das Dropdown-Menü zu öffnen und eine andere Auswahl zu treffen.";

  static String m7(last) => "Zuletzt geändert am ${last}.";

  static String m8(last, size) =>
      "Zuletzt geändert am ${last}, Dateigröße: ${size}.";

  static String m9(entityType, selectStatus, filename) =>
      "${Intl.select(selectStatus, {
            'true': 'Ausgewählt',
            'false': 'Nicht ausgewählt',
            'other': '',
          })}${Intl.select(entityType, {
            'File': 'Datei',
            'Directory': 'Verzeichnis',
            'Link': 'Verknüpfung',
            'other': 'Dateisystemobjekt',
          })} mit dem Namen ${filename},";

  static String m10(type) => "Transliteration: ${type}.";

  static String m11(langName, type) =>
      "Transliteration: Von ${langName} ${type}.";

  static String m12(iTwoToEnd, iOneOrdinal, iOneToEnd, iTwoOrdinal, keepType,
          iOne, iTwo) =>
      "Kürzen: ${Intl.select(keepType, {
            'true': 'Behalten nur',
            'false': 'Entfernen',
            'other': '',
          })} vom ${Intl.select(iOneToEnd, {
            'true': 'Ende',
            'other': 'Anfang',
          })} bei ${iOne} bis ${Intl.select(iTwoToEnd, {
            'true': 'Ende',
            'other': 'Anfang',
          })} bei ${iTwo}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutContent": MessageLookupByLibrary.simpleMessage(
            "Diese App soll Benutzern beim Umbenennen von Dateien helfen. Sie wurde mit dem Flutter-Framework entwickelt und ist daher auch für andere Betriebssysteme geeignet. Sie ist vollständig Open Source und kann überprüft und verbessert werden."),
        "add": MessageLookupByLibrary.simpleMessage("Hinzufügen"),
        "addFile": MessageLookupByLibrary.simpleMessage("Datei hinzufügen"),
        "addFiles": MessageLookupByLibrary.simpleMessage(
            "Bitte fügen Sie Dateien hinzu."),
        "addRule": MessageLookupByLibrary.simpleMessage("Regel hinzufügen"),
        "androidRemindContent": MessageLookupByLibrary.simpleMessage(
            "Mit dem Flut Renamer können Sie nicht nur Dateien, sondern auch Verzeichnisse umbenennen. Drücken Sie lange auf ein Verzeichnis, um es auszuwählen, und wählen Sie dann \'Dateien & Verzeichnisse\' aus dem Dropdown-Button in der oberen linken Ecke, um die Umbenennung von Verzeichnissen zu aktivieren. Aus Sicherheitsgründen sind einige systemreservierte Verzeichnisse nicht auswählbar."),
        "androidRemindTitle":
            MessageLookupByLibrary.simpleMessage("Verzeichnis umbenennen"),
        "appError": MessageLookupByLibrary.simpleMessage("App-Fehler"),
        "appInfo": MessageLookupByLibrary.simpleMessage("App-Information"),
        "appName": MessageLookupByLibrary.simpleMessage("Flut Renamer"),
        "bg": MessageLookupByLibrary.simpleMessage("Bulgarisch"),
        "cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
        "cancelAll": MessageLookupByLibrary.simpleMessage("Alle abbrechen"),
        "caseSensitive": MessageLookupByLibrary.simpleMessage(
            "Groß-/Kleinschreibung beachten"),
        "collapseOptions":
            MessageLookupByLibrary.simpleMessage("Optionen ausblenden"),
        "currentName":
            MessageLookupByLibrary.simpleMessage("Aktueller Dateiname"),
        "descriptionIncrement": MessageLookupByLibrary.simpleMessage(
            "Inkrementieren Sie den Dateinamen, z. B. Foto-1, Foto-2, Foto-3."),
        "descriptionInsert": MessageLookupByLibrary.simpleMessage(
            "Fügen Sie den angegebenen Text (oder Dateimetadaten und EXIF-Daten) an der angegebenen Position in den Dateinamen ein."),
        "descriptionRearrange": MessageLookupByLibrary.simpleMessage(
            "Teilen Sie den Dateinamen anhand des vom Benutzer angegebenen Trennzeichens in Segmente auf und ordnen Sie diese Segmente gemäß der bereitgestellten Reihenfolge neu an."),
        "descriptionRemove": MessageLookupByLibrary.simpleMessage(
            "Entfernen Sie den angegebenen Text (oder den Text, der dem bereitgestellten regulären Ausdruck entspricht) aus dem Dateinamen."),
        "descriptionReplace": MessageLookupByLibrary.simpleMessage(
            "Ersetzen Sie den angegebenen Text (oder den Text, der dem bereitgestellten regulären Ausdruck entspricht) durch den angegebenen Ersatztext (oder Dateimetadaten und EXIF-Daten)."),
        "descriptionTransliterate": MessageLookupByLibrary.simpleMessage(
            "Konvertieren Sie Zeichen gemäß einer vordefinierten Norm, einschließlich Groß- oder Kleinschreibung, verschiedenen Textvarianten oder verschiedenen Schreibsystemen."),
        "descriptionTruncate": MessageLookupByLibrary.simpleMessage(
            "Entfernen oder behalten Sie einen bestimmten Teil des Dateinamens, von der ersten bis zur zweiten angegebenen Position."),
        "directories": MessageLookupByLibrary.simpleMessage("Verzeichnisse"),
        "doNotRemindAgain":
            MessageLookupByLibrary.simpleMessage("Nicht mehr erinnern"),
        "dragNotSupported": MessageLookupByLibrary.simpleMessage(
            "Aufgrund von Systemsicherheitsbeschränkungen wird das Ziehen und Ablegen von Dateien aus dieser App nicht unterstützt."),
        "dragToAdd": MessageLookupByLibrary.simpleMessage(
            "Ziehen Sie Dateien hierhin, um sie hinzuzufügen."),
        "dropToAdd": MessageLookupByLibrary.simpleMessage(
            "Legen Sie Dateien hier ab, um sie hinzuzufügen."),
        "errorDetails": MessageLookupByLibrary.simpleMessage("Fehlerdetails"),
        "exit": MessageLookupByLibrary.simpleMessage("Beenden"),
        "exitContent": MessageLookupByLibrary.simpleMessage(
            "Die Berechtigung zur Verwaltung des externen Speichers ermöglicht uns den Zugriff auf die auf Ihrem Gerät gespeicherten Dateien und deren Umbenennung. Ohne diese Berechtigung kann die App nicht auf den vollständigen Pfad der Dateien zugreifen und somit keine Umbenennung durchführen. Bitte gehen Sie manuell zu den Einstellungen und gewähren Sie die Berechtigung, sonst können wir keine Dienste anbieten."),
        "exitTitle": MessageLookupByLibrary.simpleMessage(
            "Kein Zugriff auf den externen Speicher"),
        "expandOptions":
            MessageLookupByLibrary.simpleMessage("Optionen erweitern"),
        "fileAlreadyExists": MessageLookupByLibrary.simpleMessage(
            "Dateiname wird bereits verwendet"),
        "fileCreateDate":
            MessageLookupByLibrary.simpleMessage("Dateierstellungsdatum"),
        "fileCreateTime":
            MessageLookupByLibrary.simpleMessage("Dateierstellungszeit"),
        "fileManagerBackButton": MessageLookupByLibrary.simpleMessage("Zurück"),
        "fileManagerSaveButton": MessageLookupByLibrary.simpleMessage(
            "Ausgewählte Dateien zur Liste hinzufügen"),
        "fileManagerSortButton":
            MessageLookupByLibrary.simpleMessage("Dateien sortieren"),
        "fileManagerStorageButton":
            MessageLookupByLibrary.simpleMessage("Speicher auswählen"),
        "fileModifyDate":
            MessageLookupByLibrary.simpleMessage("Dateiänderungsdatum"),
        "fileModifyTime":
            MessageLookupByLibrary.simpleMessage("Dateiänderungszeit"),
        "fileNotExist":
            MessageLookupByLibrary.simpleMessage("Datei existiert nicht"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Dateigröße"),
        "fileSortDate": MessageLookupByLibrary.simpleMessage("Datum"),
        "fileSortName": MessageLookupByLibrary.simpleMessage("Name"),
        "fileSortSize": MessageLookupByLibrary.simpleMessage("Größe"),
        "fileSortType": MessageLookupByLibrary.simpleMessage("Typ"),
        "files": MessageLookupByLibrary.simpleMessage("Dateien"),
        "filesDirs":
            MessageLookupByLibrary.simpleMessage("Dateien und Verzeichnisse"),
        "filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "fromStart":
            MessageLookupByLibrary.simpleMessage("Von Anfang an zählen"),
        "goingForward": MessageLookupByLibrary.simpleMessage("Vorwärts"),
        "hideHiddenFiles": MessageLookupByLibrary.simpleMessage(
            "Versteckte Dateien ausblenden"),
        "ifFileNotShown": MessageLookupByLibrary.simpleMessage(
            "Wenn keine Dateien in der Liste angezeigt werden, löschen Sie bitte alles und fahren Sie fort."),
        "ignoreExtension":
            MessageLookupByLibrary.simpleMessage("Dateierweiterung ignorieren"),
        "increment": MessageLookupByLibrary.simpleMessage("Inkrementieren"),
        "incrementToString": m0,
        "indexIncrementalStep":
            MessageLookupByLibrary.simpleMessage("Inkrementalschritt"),
        "indexOne": MessageLookupByLibrary.simpleMessage("Erste Stelle"),
        "indexTwo": MessageLookupByLibrary.simpleMessage("Zweite Stelle"),
        "insert": MessageLookupByLibrary.simpleMessage("Einfügen"),
        "insertBeforeIndex":
            MessageLookupByLibrary.simpleMessage("Vor dem Index einfügen"),
        "insertIndex":
            MessageLookupByLibrary.simpleMessage("Einzufügender Index"),
        "insertTagInsideAnother": MessageLookupByLibrary.simpleMessage(
            "Kein Einsetzen einer Markierung in eine andere."),
        "insertToString": m1,
        "insertedText":
            MessageLookupByLibrary.simpleMessage("Einzufügender Text"),
        "iosRemindContent": MessageLookupByLibrary.simpleMessage(
            "Um Dateien auf iOS auszuwählen, wählen Sie zunächst einen Ordner aus, der Ihre Dateien enthält. Wählen Sie dann in dem ausgewählten Ordner die Dateien aus, die Sie umbenennen möchten. Aufgrund von iOS-Beschränkungen müssen wir diese beiden Schritte durchführen, um einen sicheren Dateizugriff zu gewährleisten. Lass uns anfangen!"),
        "iosRemindTitle":
            MessageLookupByLibrary.simpleMessage("Dateiauswahl auf iOS"),
        "isRegex": MessageLookupByLibrary.simpleMessage(
            "Regulären Ausdruck verwenden"),
        "keepCharacters": MessageLookupByLibrary.simpleMessage(
            "Zeichen zwischen beiden behalten"),
        "language": MessageLookupByLibrary.simpleMessage("Sprache:"),
        "limit": MessageLookupByLibrary.simpleMessage("Limit"),
        "lowercaseAppName":
            MessageLookupByLibrary.simpleMessage("flut renamer"),
        "me": MessageLookupByLibrary.simpleMessage("Montenegrinisch"),
        "metadataParserNotProvided": MessageLookupByLibrary.simpleMessage(
            "Metadatentags vorhanden, aber kein Metadatenparser bereitgestellt."),
        "metadataTags": MessageLookupByLibrary.simpleMessage("Metadaten-Tags"),
        "mk": MessageLookupByLibrary.simpleMessage("Mazedonisch"),
        "mn": MessageLookupByLibrary.simpleMessage("Mongolisch"),
        "musicAlbumArtist":
            MessageLookupByLibrary.simpleMessage("Albumkünstler"),
        "musicAlbumLength":
            MessageLookupByLibrary.simpleMessage("Anzahl der Titel im Album"),
        "musicAlbumName": MessageLookupByLibrary.simpleMessage("Albumname"),
        "musicAuthor": MessageLookupByLibrary.simpleMessage("Autor des Titels"),
        "musicDiscNumber":
            MessageLookupByLibrary.simpleMessage("Position der Disc"),
        "musicGenres": MessageLookupByLibrary.simpleMessage("Genre des Titels"),
        "musicTrackArtist":
            MessageLookupByLibrary.simpleMessage("Künstler des Titels"),
        "musicTrackDuration":
            MessageLookupByLibrary.simpleMessage("Dauer des Titels"),
        "musicTrackName":
            MessageLookupByLibrary.simpleMessage("Name des Titels"),
        "musicTrackNumber": MessageLookupByLibrary.simpleMessage(
            "Position des Titels im Album"),
        "musicWriter":
            MessageLookupByLibrary.simpleMessage("Verfasser des Titels"),
        "musicYear": MessageLookupByLibrary.simpleMessage(
            "Veröffentlichungsjahr des Titels"),
        "newName": MessageLookupByLibrary.simpleMessage("Neuer Dateiname"),
        "noSysDir": MessageLookupByLibrary.simpleMessage(
            "Reservierte Systemverzeichnisse nicht umbenennen."),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "omitDash":
            MessageLookupByLibrary.simpleMessage("Bindestrich auslassen"),
        "onlySelected": MessageLookupByLibrary.simpleMessage(
            "Nur ausgewählte Dateien umbenennen"),
        "osNowTime": MessageLookupByLibrary.simpleMessage("Aktuelle Uhrzeit"),
        "osTodayDate": MessageLookupByLibrary.simpleMessage("Aktuelles Datum"),
        "permissionContent": MessageLookupByLibrary.simpleMessage(
            "Um den Dateiumbenennungsdienst bereitzustellen, benötigen wir Ihre Erlaubnis zur Verwaltung des externen Speichers. Dadurch können wir auf die auf Ihrem Gerät gespeicherten Dateien zugreifen und sie umbenennen. Ohne diese Berechtigung kann die App nicht auf den vollständigen Pfad der Dateien zugreifen und somit keine Umbenennung durchführen. Wir versichern Ihnen, dass wir Ihre Privatsphäre und Sicherheit sehr ernst nehmen und nur zum Zwecke der Umbenennung auf die Dateien zugreifen."),
        "permissionTitle": MessageLookupByLibrary.simpleMessage(
            "Externe Speicherberechtigung"),
        "photoAltitude":
            MessageLookupByLibrary.simpleMessage("Höhe des Fotos (EXIF)"),
        "photoAperture":
            MessageLookupByLibrary.simpleMessage("Blendenöffnungswert (EXIF)"),
        "photoCamName":
            MessageLookupByLibrary.simpleMessage("Kameraname (EXIF)"),
        "photoCopyright": MessageLookupByLibrary.simpleMessage(
            "Name des Urheberrechtsinhabers (EXIF)"),
        "photoDate": MessageLookupByLibrary.simpleMessage(
            "Aufnahmedatum des Fotos (EXIF)"),
        "photoFocalLength":
            MessageLookupByLibrary.simpleMessage("Brennweite (EXIF)"),
        "photoISO": MessageLookupByLibrary.simpleMessage("ISO-Wert (EXIF)"),
        "photoLatitude": MessageLookupByLibrary.simpleMessage(
            "Breitengrad des Fotos (EXIF)"),
        "photoLensName":
            MessageLookupByLibrary.simpleMessage("Objektivname (EXIF)"),
        "photoLongitude":
            MessageLookupByLibrary.simpleMessage("Längengrad des Fotos (EXIF)"),
        "photoPhotographer":
            MessageLookupByLibrary.simpleMessage("Name des Fotografen (EXIF)"),
        "photoShutter": MessageLookupByLibrary.simpleMessage(
            "Verschlussgeschwindigkeit (EXIF)"),
        "photoTime": MessageLookupByLibrary.simpleMessage(
            "Aufnahmezeit des Fotos (EXIF)"),
        "prefix": MessageLookupByLibrary.simpleMessage("Präfix"),
        "rating": MessageLookupByLibrary.simpleMessage("App-Bewertung"),
        "ratingContent": MessageLookupByLibrary.simpleMessage(
            "Mögen Sie unsere App? Geben Sie uns eine gute Bewertung im App Store oder geben Sie auf GitHub einen Stern, um uns zu unterstützen. Ihr Feedback ist uns sehr wichtig! Vielen Dank für Ihre Unterstützung."),
        "ratingGithub":
            MessageLookupByLibrary.simpleMessage("GitHub-Repository markieren"),
        "ratingStore":
            MessageLookupByLibrary.simpleMessage("Im Store bewerten"),
        "ratingTitle":
            MessageLookupByLibrary.simpleMessage("Bewerten Sie unsere App"),
        "rearrange": MessageLookupByLibrary.simpleMessage("Neu anordnen"),
        "rearrangeDelimiter":
            MessageLookupByLibrary.simpleMessage("Trennzeichen"),
        "rearrangeOrderHint": MessageLookupByLibrary.simpleMessage(
            "Bitte geben Sie die entsprechenden Zahlen ein, durch Kommas getrennt"),
        "rearrangeOrderLabel":
            MessageLookupByLibrary.simpleMessage("Reihenfolge neu anordnen"),
        "rearrangeToString": m2,
        "remove": MessageLookupByLibrary.simpleMessage("Entfernen"),
        "removeAll": MessageLookupByLibrary.simpleMessage("Alles entfernen"),
        "removeCharacters": MessageLookupByLibrary.simpleMessage(
            "Zeichen zwischen beiden entfernen"),
        "removeRenamed": MessageLookupByLibrary.simpleMessage(
            "Umbenannte Dateien entfernen"),
        "removeRule": MessageLookupByLibrary.simpleMessage("Regel entfernen"),
        "removeRules": MessageLookupByLibrary.simpleMessage(
            "Nach dem Umbenennen alle Regeln entfernen"),
        "removeToString": m3,
        "rename": MessageLookupByLibrary.simpleMessage("Umbenennen"),
        "renameFailed":
            MessageLookupByLibrary.simpleMessage("Umbenennen fehlgeschlagen"),
        "replace": MessageLookupByLibrary.simpleMessage("Ersetzen"),
        "replaceToString": m4,
        "replacement": MessageLookupByLibrary.simpleMessage("Ersetzung"),
        "ru": MessageLookupByLibrary.simpleMessage("Russisch"),
        "rulesSequentially": MessageLookupByLibrary.simpleMessage(
            "Regeln werden nacheinander ausgeführt. Klicken Sie auf eine Regel, um sie zu bearbeiten. Halten Sie die \'=\'-Taste auf der linken Seite gedrückt und ziehen Sie sie, um die Regeln zu sortieren."),
        "save": MessageLookupByLibrary.simpleMessage("Speichern"),
        "select": MessageLookupByLibrary.simpleMessage("Auswählen"),
        "selectAll": MessageLookupByLibrary.simpleMessage("Alle auswählen"),
        "semanticSwitchNumberToStartAndToEnd": m5,
        "semanticsDropdownButton": m6,
        "semanticsFileManagerDirSubtitle": m7,
        "semanticsFileManagerSubtitle": m8,
        "semanticsFileManagerTitle": m9,
        "semanticsFilesDropdownButton": MessageLookupByLibrary.simpleMessage(
            ". Wählen Sie es aus, um die Umbenennungsziele auf diesen Bereich zu beschränken."),
        "semanticsMultipleActionsHint": MessageLookupByLibrary.simpleMessage(
            ", blättern Sie nach oben oder unten, um weitere Aktionen anzuzeigen."),
        "semanticsOpenMetadataDialog": MessageLookupByLibrary.simpleMessage(
            "Doppelklicken Sie, um einen Dialog zu öffnen und Metadatentags auszuwählen, die eingefügt werden sollen."),
        "semanticsReorderableList": MessageLookupByLibrary.simpleMessage(
            "Die Regel-Liste ist derzeit leer. Klicken Sie auf \"Regel hinzufügen\", um eine Regel hinzuzufügen. Regeln werden sequenziell ausgeführt. Diese Liste kann neu angeordnet werden, sodass Sie Regeln nach oben, unten, an den Anfang oder das Ende verschieben können. Wenn der Cursor über einer Regel steht, verwenden Sie eine vertikale Wischgeste, um zwischen verschiedenen Aktionen zu wechseln, und doppelklicken Sie, um die ausgewählte Aktion auszuführen."),
        "semanticsRuleDropdownButton": MessageLookupByLibrary.simpleMessage(
            ". Wählen Sie es aus und klicken Sie auf die Schaltfläche \"Regel hinzufügen\", um diese Regel hinzuzufügen."),
        "showHiddenFiles":
            MessageLookupByLibrary.simpleMessage("Versteckte Dateien anzeigen"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Quellcode"),
        "sr": MessageLookupByLibrary.simpleMessage("Serbisch"),
        "startIndex": MessageLookupByLibrary.simpleMessage("Startindex"),
        "target": MessageLookupByLibrary.simpleMessage("Ziel"),
        "tj": MessageLookupByLibrary.simpleMessage("Tadschikisch"),
        "toLast": MessageLookupByLibrary.simpleMessage("Letzte Stelle"),
        "transliterate":
            MessageLookupByLibrary.simpleMessage("Transliteration"),
        "transliterateCyrillic2Latin": MessageLookupByLibrary.simpleMessage(
            "Von Kyrillisch in Lateinisch umwandeln"),
        "transliterateLatin2Cyrillic": MessageLookupByLibrary.simpleMessage(
            "Von Lateinisch in Kyrillisch umwandeln"),
        "transliterateLower": MessageLookupByLibrary.simpleMessage(
            "In Lateinische Kleinbuchstaben umwandeln"),
        "transliteratePinyin": MessageLookupByLibrary.simpleMessage(
            "Chinesisch in Pinyin umwandeln"),
        "transliterateSimplified": MessageLookupByLibrary.simpleMessage(
            "In vereinfachtes Chinesisch umwandeln"),
        "transliterateToString": m10,
        "transliterateToStringCyrillic": m11,
        "transliterateTraditional": MessageLookupByLibrary.simpleMessage(
            "In traditionelles Chinesisch umwandeln"),
        "transliterateUpper": MessageLookupByLibrary.simpleMessage(
            "In Lateinische Großbuchstaben umwandeln"),
        "truncate": MessageLookupByLibrary.simpleMessage("Kürzen"),
        "truncateToString": m12,
        "ua": MessageLookupByLibrary.simpleMessage("Ukrainisch")
      };
}
