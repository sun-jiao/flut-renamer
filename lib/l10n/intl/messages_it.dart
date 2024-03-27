// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it locale. All the
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
  String get localeName => 'it';

  static String m0(prefix) => "Incrementa con prefisso- indice";

  static String m1(toEnd, ordinal, insert, insertIndex) =>
      "Inserisce \"${insert}\" all\'indice ${insertIndex}${Intl.select(toEnd, {
            'true': 'dalla fine',
            'false': '',
            'other': '',
          })}.";

  static String m2(delimiter, order) =>
      "Riordina usando il delimitatore: ${delimiter} e l\'ordine: ${order}.";

  static String m3(targetString) => "Rimuove \"${targetString}\".";

  static String m4(targetString, replacementString) =>
      "Sostituisce \"${targetString}\" con \"${replacementString}\".";

  static String m5(toEnd) =>
      "Cambiamento della direzione del conteggio tra dall\'inizio e dalla fine, attualmente il conteggio da ${Intl.select(toEnd, {
            'true': 'la fine',
            'false': 'l\'inizio',
            'other': '',
          })}";

  static String m6(value) =>
      "Attualmente selezionato \"${value}\". Tocca due volte per aprire il menu a discesa e selezionare un valore diverso.";

  static String m7(last) => "Ultima modifica il ${last}.";

  static String m8(last, size) =>
      "Ultima modifica il ${last} e di dimensioni ${size}.";

  static String m9(entityType, selectStatus, filename) =>
      "${Intl.select(selectStatus, {
            'true': 'Selezionato',
            'false': 'Non selezionato',
            'other': '',
          })}${Intl.select(entityType, {
            'File': 'file',
            'Directory': 'directory',
            'Link': 'link',
            'other': 'entity',
          })} chiamato ${filename},";

  static String m10(type) => "Traslittera: ${type}.";

  static String m11(langName, type) => "Traslittera in ${langName} ${type}.";

  static String m12(iTwoToEnd, iOneOrdinal, iOneToEnd, iTwoOrdinal, keepType,
          iOne, iTwo) =>
      "Tronca: ${Intl.select(keepType, {
            'true': 'Mantieni solo',
            'false': 'Rimuovi',
            'other': '',
          })} contenuto tra la posizione ${iOne} e ${iTwo}${Intl.select(iTwoToEnd, {
            'true': 'dalla fine',
            'false': '',
            'other': '',
          })}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutContent": MessageLookupByLibrary.simpleMessage(
            "Questa app è progettata per aiutare gli utenti a rinominare i file. È sviluppata utilizzando il framework Flutter, rendendola adatta anche per altri sistemi operativi. È completamente open source e può essere esaminata e contribuita liberamente."),
        "add": MessageLookupByLibrary.simpleMessage("Aggiungi"),
        "addFile": MessageLookupByLibrary.simpleMessage("Aggiungi file"),
        "addFiles": MessageLookupByLibrary.simpleMessage(
            "Si prega di aggiungere dei file."),
        "addRule": MessageLookupByLibrary.simpleMessage("Aggiungi regola"),
        "androidRemindContent": MessageLookupByLibrary.simpleMessage(
            "Usando il Flut Renamer, puoi rinominare non solo i file, ma anche le directory. Tieni premuta una directory per selezionarla, quindi seleziona \'File e directory\' dal pulsante a discesa nell\'angolo in alto a sinistra per abilitare la rinomina delle directory. Per motivi di sicurezza, alcune directory riservate al sistema non sono selezionabili."),
        "androidRemindTitle":
            MessageLookupByLibrary.simpleMessage("Rinomina directory"),
        "appError":
            MessageLookupByLibrary.simpleMessage("Errore dell\'applicazione"),
        "appInfo":
            MessageLookupByLibrary.simpleMessage("Informazioni sull\'app"),
        "appName": MessageLookupByLibrary.simpleMessage("Flut Renamer"),
        "bg": MessageLookupByLibrary.simpleMessage("Bulgaro"),
        "cancel": MessageLookupByLibrary.simpleMessage("Annulla"),
        "cancelAll": MessageLookupByLibrary.simpleMessage("Annulla tutto"),
        "caseSensitive":
            MessageLookupByLibrary.simpleMessage("Maiuscole/minuscole"),
        "collapseOptions":
            MessageLookupByLibrary.simpleMessage("Nascondi opzioni"),
        "currentName": MessageLookupByLibrary.simpleMessage("Nome attuale"),
        "descriptionIncrement": MessageLookupByLibrary.simpleMessage(
            "Incrementa il nome del file, ad esempio Foto-1, Foto-2, Foto-3."),
        "descriptionInsert": MessageLookupByLibrary.simpleMessage(
            "Inserisce il testo specificato (o i dati dei metadati del file ed EXIF) in una posizione specificata."),
        "descriptionRearrange": MessageLookupByLibrary.simpleMessage(
            "Separa il nome del file usando un delimitatore specificato dall\'utente e lo riordina secondo l\'ordine fornito."),
        "descriptionRemove": MessageLookupByLibrary.simpleMessage(
            "Rimuove il testo specificato (o il testo corrispondente all\'espressione regolare fornita) dal nome del file."),
        "descriptionReplace": MessageLookupByLibrary.simpleMessage(
            "Sostituisce il testo specificato (o il testo corrispondente all\'espressione regolare fornita) con il testo di sostituzione fornito (o i dati dei metadati del file ed EXIF)."),
        "descriptionTransliterate": MessageLookupByLibrary.simpleMessage(
            "Converte i caratteri in base a una specifica predefinita, inclusa la conversione in maiuscolo o minuscolo, in diverse varianti di caratteri o in diversi sistemi di scrittura."),
        "descriptionTruncate": MessageLookupByLibrary.simpleMessage(
            "Rimuove o mantiene solo una parte specificata del nome del file, da una posizione di inizio a una posizione finale specificate."),
        "directories": MessageLookupByLibrary.simpleMessage("Directory"),
        "doNotRemindAgain":
            MessageLookupByLibrary.simpleMessage("Non mostrare più"),
        "dragToAdd": MessageLookupByLibrary.simpleMessage(
            "Trascina i file per aggiungerli."),
        "dropToAdd": MessageLookupByLibrary.simpleMessage(
            "Rilascia i file qui per aggiungerli."),
        "errorDetails":
            MessageLookupByLibrary.simpleMessage("Dettagli dell\'errore"),
        "exit": MessageLookupByLibrary.simpleMessage("Esci"),
        "exitContent": MessageLookupByLibrary.simpleMessage(
            "Il permesso di gestione dell\'archiviazione esterna ci consente di accedere e rinominare i file archiviati sul tuo dispositivo. Senza questo permesso, l\'app non potrà accedere al percorso completo dei file e non potrà eseguire operazioni di rinomina. Vai alle impostazioni e concedi manualmente il permesso, altrimenti non saremo in grado di fornire alcun servizio."),
        "exitTitle": MessageLookupByLibrary.simpleMessage(
            "Impossibile accedere all\'archiviazione esterna"),
        "expandOptions":
            MessageLookupByLibrary.simpleMessage("Espandi opzioni"),
        "fileAlreadyExists": MessageLookupByLibrary.simpleMessage(
            "Il nome del file è già in uso"),
        "fileCreateDate":
            MessageLookupByLibrary.simpleMessage("Data creazione file"),
        "fileCreateTime":
            MessageLookupByLibrary.simpleMessage("Ora creazione file"),
        "fileManagerBackButton":
            MessageLookupByLibrary.simpleMessage("Indietro"),
        "fileManagerSaveButton": MessageLookupByLibrary.simpleMessage(
            "Aggiungi i file selezionati alla lista"),
        "fileManagerSortButton":
            MessageLookupByLibrary.simpleMessage("Ordina file"),
        "fileManagerStorageButton":
            MessageLookupByLibrary.simpleMessage("Seleziona memoria"),
        "fileModifyDate":
            MessageLookupByLibrary.simpleMessage("Data modifica file"),
        "fileModifyTime":
            MessageLookupByLibrary.simpleMessage("Ora modifica file"),
        "fileNotExist":
            MessageLookupByLibrary.simpleMessage("File non esistente"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Dimensione file"),
        "fileSortDate": MessageLookupByLibrary.simpleMessage("Data"),
        "fileSortName": MessageLookupByLibrary.simpleMessage("Nome"),
        "fileSortSize": MessageLookupByLibrary.simpleMessage("Dimensione"),
        "fileSortType": MessageLookupByLibrary.simpleMessage("Tipo"),
        "files": MessageLookupByLibrary.simpleMessage("File"),
        "filesDirs": MessageLookupByLibrary.simpleMessage("File e Directory"),
        "filter": MessageLookupByLibrary.simpleMessage("Filtra"),
        "fromStart": MessageLookupByLibrary.simpleMessage("Dall\'inizio"),
        "goingForward": MessageLookupByLibrary.simpleMessage("Avanti"),
        "ifFileNotShown": MessageLookupByLibrary.simpleMessage(
            "Se i file non vengono mostrati nell\'elenco, cancella tutto e continua."),
        "ignoreExtension":
            MessageLookupByLibrary.simpleMessage("Ignora l\'estensione"),
        "increment": MessageLookupByLibrary.simpleMessage("Incrementa"),
        "incrementToString": m0,
        "indexIncrementalStep": MessageLookupByLibrary.simpleMessage(
            "Passo incrementale dell\'indice"),
        "indexOne": MessageLookupByLibrary.simpleMessage("Posizione uno"),
        "indexTwo": MessageLookupByLibrary.simpleMessage("Posizione due"),
        "insert": MessageLookupByLibrary.simpleMessage("Inserisci"),
        "insertBeforeIndex": MessageLookupByLibrary.simpleMessage(
            "Inserisci prima dell\'indice"),
        "insertIndex":
            MessageLookupByLibrary.simpleMessage("Indice di inserimento"),
        "insertTagInsideAnother": MessageLookupByLibrary.simpleMessage(
            "Non inserire un tag all\'interno di un altro."),
        "insertToString": m1,
        "insertedText": MessageLookupByLibrary.simpleMessage("Testo inserito"),
        "iosRemindContent": MessageLookupByLibrary.simpleMessage(
            "Per selezionare i file su iOS, prima seleziona una cartella che contiene i tuoi file. Quindi, all\'interno della cartella selezionata, scegli i file che desideri rinominare. A causa delle restrizioni di iOS, dobbiamo seguire questi due passaggi per garantire un accesso sicuro ai file. Iniziamo!"),
        "iosRemindTitle":
            MessageLookupByLibrary.simpleMessage("Selezione dei file su iOS"),
        "isRegex":
            MessageLookupByLibrary.simpleMessage("Usa espressione regolare"),
        "keepCharacters": MessageLookupByLibrary.simpleMessage(
            "Mantieni i caratteri tra i due"),
        "language": MessageLookupByLibrary.simpleMessage("Lingua:"),
        "limit": MessageLookupByLibrary.simpleMessage("Limite"),
        "lowercaseAppName":
            MessageLookupByLibrary.simpleMessage("flut renamer"),
        "me": MessageLookupByLibrary.simpleMessage("Montenegrino"),
        "metadataParserNotProvided": MessageLookupByLibrary.simpleMessage(
            "Tag dei metadati presenti ma non è stato fornito alcun analizzatore di metadati."),
        "metadataTags":
            MessageLookupByLibrary.simpleMessage("Tag dei metadati"),
        "mk": MessageLookupByLibrary.simpleMessage("Macedone"),
        "mn": MessageLookupByLibrary.simpleMessage("Mongolo"),
        "musicAlbumArtist":
            MessageLookupByLibrary.simpleMessage("Artista dell\'album"),
        "musicAlbumLength": MessageLookupByLibrary.simpleMessage(
            "Numero di tracce nell\'album"),
        "musicAlbumName":
            MessageLookupByLibrary.simpleMessage("Nome dell\'album"),
        "musicAuthor":
            MessageLookupByLibrary.simpleMessage("Autore della traccia"),
        "musicDiscNumber":
            MessageLookupByLibrary.simpleMessage("Numero del disco"),
        "musicGenres":
            MessageLookupByLibrary.simpleMessage("Generi della traccia"),
        "musicTrackArtist":
            MessageLookupByLibrary.simpleMessage("Artista della traccia"),
        "musicTrackDuration":
            MessageLookupByLibrary.simpleMessage("Durata della traccia"),
        "musicTrackName":
            MessageLookupByLibrary.simpleMessage("Nome della traccia"),
        "musicTrackNumber": MessageLookupByLibrary.simpleMessage(
            "Numero della traccia nell\'album"),
        "musicWriter":
            MessageLookupByLibrary.simpleMessage("Scrittore della traccia"),
        "musicYear":
            MessageLookupByLibrary.simpleMessage("Anno di pubblicazione"),
        "newName": MessageLookupByLibrary.simpleMessage("Nuovo nome"),
        "noSysDir": MessageLookupByLibrary.simpleMessage(
            "Non rinominare le directory di sistema riservate."),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "omitDash": MessageLookupByLibrary.simpleMessage("Ometti il trattino"),
        "onlySelected": MessageLookupByLibrary.simpleMessage(
            "Rinomina solo i file selezionati"),
        "osNowTime": MessageLookupByLibrary.simpleMessage("Orario attuale"),
        "osTodayDate": MessageLookupByLibrary.simpleMessage("Data odierna"),
        "permissionContent": MessageLookupByLibrary.simpleMessage(
            "Per fornire il servizio di rinomina dei file, è necessario concedere l\'autorizzazione per la gestione dell\'archiviazione esterna. Ciò ci consente di accedere e rinominare i file archiviati sul dispositivo. Senza questo permesso, l\'app non potrà accedere al percorso completo dei file e non potrà eseguire operazioni di rinomina. Ti assicuriamo che trattiamo la tua privacy e sicurezza con la massima attenzione e accediamo ai file solo per lo scopo di rinominarli."),
        "permissionTitle": MessageLookupByLibrary.simpleMessage(
            "Permesso di archiviazione esterna"),
        "photoAltitude": MessageLookupByLibrary.simpleMessage(
            "Altitudine GPS della foto (da EXIF)"),
        "photoAperture":
            MessageLookupByLibrary.simpleMessage("Diaframma (da EXIF)"),
        "photoCamName":
            MessageLookupByLibrary.simpleMessage("Nome fotocamera (da EXIF)"),
        "photoCopyright": MessageLookupByLibrary.simpleMessage(
            "Nome del proprietario del copyright (da EXIF)"),
        "photoDate":
            MessageLookupByLibrary.simpleMessage("Data scatto foto (da EXIF)"),
        "photoFocalLength":
            MessageLookupByLibrary.simpleMessage("Lunghezza focale (da EXIF)"),
        "photoISO":
            MessageLookupByLibrary.simpleMessage("Valore ISO (da EXIF)"),
        "photoLatitude": MessageLookupByLibrary.simpleMessage(
            "Latitudine GPS della foto (da EXIF)"),
        "photoLensName":
            MessageLookupByLibrary.simpleMessage("Nome obiettivo (da EXIF)"),
        "photoLongitude": MessageLookupByLibrary.simpleMessage(
            "Longitudine GPS della foto (da EXIF)"),
        "photoPhotographer": MessageLookupByLibrary.simpleMessage(
            "Nome del fotografo (da EXIF)"),
        "photoShutter": MessageLookupByLibrary.simpleMessage(
            "Velocità dell\'otturatore (da EXIF)"),
        "photoTime": MessageLookupByLibrary.simpleMessage(
            "Orario scatto foto (da EXIF)"),
        "prefix": MessageLookupByLibrary.simpleMessage("Prefisso"),
        "rating": MessageLookupByLibrary.simpleMessage("Valutazione dell\'app"),
        "ratingContent": MessageLookupByLibrary.simpleMessage(
            "Ti piace la nostra app? Aiutaci a crescere lasciando una valutazione positiva sullo store o mettendo un like su GitHub. Il tuo feedback è estremamente importante per noi! Grazie per il supporto."),
        "ratingGithub":
            MessageLookupByLibrary.simpleMessage("Metti un like su GitHub"),
        "ratingStore": MessageLookupByLibrary.simpleMessage("Valuta su Store"),
        "ratingTitle":
            MessageLookupByLibrary.simpleMessage("Valuta la nostra app"),
        "rearrange": MessageLookupByLibrary.simpleMessage("Riordina"),
        "rearrangeDelimiter":
            MessageLookupByLibrary.simpleMessage("Delimitatore"),
        "rearrangeOrderHint": MessageLookupByLibrary.simpleMessage(
            "Inserisci i numeri corrispondenti separati da virgole"),
        "rearrangeOrderLabel":
            MessageLookupByLibrary.simpleMessage("Ordine del riordinamento"),
        "rearrangeToString": m2,
        "remove": MessageLookupByLibrary.simpleMessage("Rimuovi"),
        "removeAll": MessageLookupByLibrary.simpleMessage("Rimuovi tutto"),
        "removeCharacters": MessageLookupByLibrary.simpleMessage(
            "Rimuovi i caratteri tra i due"),
        "removeRenamed": MessageLookupByLibrary.simpleMessage(
            "Rimuovi i file già rinominati"),
        "removeRule":
            MessageLookupByLibrary.simpleMessage("Rimuovi questa regola"),
        "removeRules": MessageLookupByLibrary.simpleMessage(
            "Rimuovi tutte le regole dopo la rinomina"),
        "removeToString": m3,
        "rename": MessageLookupByLibrary.simpleMessage("Rinomina"),
        "renameFailed":
            MessageLookupByLibrary.simpleMessage("Rinomina non riuscita"),
        "replace": MessageLookupByLibrary.simpleMessage("Sostituisci"),
        "replaceToString": m4,
        "replacement": MessageLookupByLibrary.simpleMessage("Sostituzione"),
        "ru": MessageLookupByLibrary.simpleMessage("Russo"),
        "rulesSequentially": MessageLookupByLibrary.simpleMessage(
            "Le regole vengono eseguite in sequenza. Tieni premuto il pulsante \"=\" sulla sinistra e trascina per ordinare le regole."),
        "save": MessageLookupByLibrary.simpleMessage("Salva"),
        "select": MessageLookupByLibrary.simpleMessage("Seleziona"),
        "selectAll": MessageLookupByLibrary.simpleMessage("Seleziona tutto"),
        "semanticSwitchNumberToStartAndToEnd": m5,
        "semanticsDropdownButton": m6,
        "semanticsFileManagerDirSubtitle": m7,
        "semanticsFileManagerSubtitle": m8,
        "semanticsFileManagerTitle": m9,
        "semanticsFilesDropdownButton": MessageLookupByLibrary.simpleMessage(
            ". Seleziona per limitare la rinomina ai file selezionati"),
        "semanticsMultipleActionsHint": MessageLookupByLibrary.simpleMessage(
            ", scorri su e giù per passare ad altre azioni."),
        "semanticsOpenMetadataDialog": MessageLookupByLibrary.simpleMessage(
            "Tocca due volte per aprire un dialogo e selezionare un tag dei metadati da inserire."),
        "semanticsReorderableList": MessageLookupByLibrary.simpleMessage(
            "La lista delle regole è attualmente vuota. Tocca \"Aggiungi regola\" per aggiungerne una. Le regole vengono eseguite in sequenza. È possibile riordinare la lista trascinando verso l\'alto o il basso e spostando le regole in cima o in fondo. Tocca con due dita su una regola per attivare le azioni e tocca due volte per eseguire l\'azione selezionata."),
        "semanticsRuleDropdownButton": MessageLookupByLibrary.simpleMessage(
            ". Seleziona questa voce e premi il pulsante \"Aggiungi regola\" per aggiungere questa regola"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Codice sorgente"),
        "sr": MessageLookupByLibrary.simpleMessage("Serbo"),
        "startIndex":
            MessageLookupByLibrary.simpleMessage("Indice di partenza"),
        "target": MessageLookupByLibrary.simpleMessage("Obiettivo"),
        "tj": MessageLookupByLibrary.simpleMessage("Tagiko"),
        "toLast": MessageLookupByLibrary.simpleMessage("Alla fine"),
        "transliterate": MessageLookupByLibrary.simpleMessage("Traslittera"),
        "transliterateCyrillic2Latin": MessageLookupByLibrary.simpleMessage(
            "Traslittera caratteri cirillici in latini"),
        "transliterateLatin2Cyrillic": MessageLookupByLibrary.simpleMessage(
            "Traslittera caratteri latini in cirillici"),
        "transliterateLower": MessageLookupByLibrary.simpleMessage(
            "Traslittera in minuscolo caratteri latini"),
        "transliteratePinyin": MessageLookupByLibrary.simpleMessage(
            "Traslittera il cinese in Pinyin"),
        "transliterateSimplified": MessageLookupByLibrary.simpleMessage(
            "Traslittera in cinese semplificato"),
        "transliterateToString": m10,
        "transliterateToStringCyrillic": m11,
        "transliterateTraditional": MessageLookupByLibrary.simpleMessage(
            "Traslittera in cinese tradizionale"),
        "transliterateUpper": MessageLookupByLibrary.simpleMessage(
            "Traslittera in maiuscolo caratteri latini"),
        "truncate": MessageLookupByLibrary.simpleMessage("Tronca"),
        "truncateToString": m12,
        "ua": MessageLookupByLibrary.simpleMessage("Ucraino")
      };
}
