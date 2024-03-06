// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(prefix) => "Incrémentation : ${prefix} - Index";

  static String m1(toEnd, ordinal, insert, insertIndex) =>
      "Insertion : Insérer \"${insert}\" à la position ${insertIndex}, ${Intl.select(toEnd, {
            'true': 'en partant de la fin',
            'false': '',
            'other': 'à partir du début',
          })}.";

  static String m2(delimiter, order) =>
      "Réorganisation : Délimiteur : ${delimiter}, Ordre : ${order}.";

  static String m3(targetString) => "Suppression : \"${targetString}\"";

  static String m4(targetString, replacementString) =>
      "Remplacement : Remplacer \"${targetString}\" par \"${replacementString}\".";

  static String m5(toEnd) =>
      "Changement de direction de comptage entre du début et de la fin, comptant actuellement à partir de ${Intl.select(toEnd, {
            'true': 'la fin',
            'false': 'le début',
            'other': '',
          })}";

  static String m6(value) =>
      "Ceci est un bouton déroulant, la valeur actuelle est \"${value}\", double-cliquez pour ouvrir et sélectionner une autre valeur.";

  static String m7(last) => "Dernière modification : ${last}.";

  static String m8(last, size) =>
      "Dernière modification : ${last}, Taille : ${size}.";

  static String m9(entityType, selectStatus, filename) =>
      "${Intl.select(selectStatus, {
            'true': 'Sélectionné',
            'false': 'Non sélectionné',
            'other': '',
          })}${Intl.select(entityType, {
            'File': 'fichier',
            'Directory': 'répertoire',
            'Link': 'lien',
            'other': 'objet du système de fichiers',
          })} nommé ${filename},";

  static String m10(type) => "Translittération : ${type}.";

  static String m11(langName, type) =>
      "Translittération : De ${langName} à ${type}.";

  static String m12(iTwoToEnd, iOneOrdinal, iOneToEnd, iTwoOrdinal, keepType,
          iOne, iTwo) =>
      "Troncature : ${Intl.select(keepType, {
            'true': 'Conserver uniquement',
            'false': 'Supprimer',
            'other': '',
          })} entre ${Intl.select(iOneToEnd, {
            'true': 'la dernière',
            'false': '',
            'other': 'la première',
          })} position ${iOne} et ${Intl.select(iTwoToEnd, {
            'true': 'la dernière',
            'false': '',
            'other': 'la deuxième',
          })} position ${iTwo}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutContent": MessageLookupByLibrary.simpleMessage(
            "Cette application est conçue pour aider les utilisateurs à renommer leurs fichiers. Elle est développée avec Flutter, un framework d\'application multiplateforme, et est donc également disponible sur d\'autres systèmes d\'exploitation. Elle est totalement open source et peut être examinée ou contribuée."),
        "add": MessageLookupByLibrary.simpleMessage("Ajouter"),
        "addFile": MessageLookupByLibrary.simpleMessage("Ajouter un fichier"),
        "addFiles": MessageLookupByLibrary.simpleMessage(
            "Veuillez ajouter des fichiers."),
        "addRule": MessageLookupByLibrary.simpleMessage("Ajouter une règle"),
        "androidRemindContent": MessageLookupByLibrary.simpleMessage(
            "Avec Renommer, vous pouvez non seulement renommer des fichiers, mais aussi des répertoires. Maintenez enfoncé un répertoire pour le sélectionner, puis sélectionnez \'Fichiers et répertoires\' dans le bouton déroulant en haut à gauche pour activer le renommage de répertoire. Pour des raisons de sécurité, certains répertoires réservés au système ne sont pas sélectionnables."),
        "androidRemindTitle":
            MessageLookupByLibrary.simpleMessage("Renommer un répertoire"),
        "appError":
            MessageLookupByLibrary.simpleMessage("Erreur de l\'application"),
        "appInfo": MessageLookupByLibrary.simpleMessage(
            "Informations sur l\'application"),
        "appName": MessageLookupByLibrary.simpleMessage("Renommer"),
        "bg": MessageLookupByLibrary.simpleMessage("Bulgare"),
        "cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "cancelAll": MessageLookupByLibrary.simpleMessage("Tout annuler"),
        "caseSensitive":
            MessageLookupByLibrary.simpleMessage("Sensible à la casse"),
        "collapseOptions":
            MessageLookupByLibrary.simpleMessage("Réduire les options"),
        "currentName": MessageLookupByLibrary.simpleMessage("Nom actuel"),
        "descriptionIncrement": MessageLookupByLibrary.simpleMessage(
            "Incrémenter le nom de fichier, par exemple, Photo-1, Photo-2, Photo-3."),
        "descriptionInsert": MessageLookupByLibrary.simpleMessage(
            "Insérer le texte spécifié (ou les métadonnées du fichier et les données EXIF) à la position spécifiée dans le nom de fichier."),
        "descriptionRearrange": MessageLookupByLibrary.simpleMessage(
            "Diviser le nom de fichier en segments en fonction du délimiteur spécifié par l\'utilisateur, puis réorganiser ces segments selon l\'ordre fourni."),
        "descriptionRemove": MessageLookupByLibrary.simpleMessage(
            "Supprimer le texte spécifié (ou le texte correspondant à l\'expression régulière fournie) du nom de fichier."),
        "descriptionReplace": MessageLookupByLibrary.simpleMessage(
            "Remplacer le texte spécifié (ou le texte correspondant à l\'expression régulière fournie) par le texte de remplacement donné (ou par les métadonnées du fichier et les données EXIF)."),
        "descriptionTransliterate": MessageLookupByLibrary.simpleMessage(
            "Convertir les caractères selon une norme prédéfinie, notamment en majuscules ou en minuscules, en différentes variantes de texte, ou en différents systèmes d\'écriture."),
        "descriptionTruncate": MessageLookupByLibrary.simpleMessage(
            "Supprimer ou conserver une partie spécifiée du nom de fichier, de la première position spécifiée à la seconde position spécifiée."),
        "directories": MessageLookupByLibrary.simpleMessage("Répertoires"),
        "doNotRemindAgain":
            MessageLookupByLibrary.simpleMessage("OK. Ne plus me rappeler."),
        "dragToAdd": MessageLookupByLibrary.simpleMessage(
            "Glissez et déposez des fichiers pour les ajouter."),
        "dropToAdd":
            MessageLookupByLibrary.simpleMessage("Déposez des fichiers ici."),
        "errorDetails":
            MessageLookupByLibrary.simpleMessage("Détails de l\'erreur"),
        "exit": MessageLookupByLibrary.simpleMessage("Quitter"),
        "exitContent": MessageLookupByLibrary.simpleMessage(
            "L\'autorisation de gestion du stockage externe nous permet d\'accéder et de renommer les fichiers stockés sur votre appareil. Sans cette autorisation, l\'application ne pourra pas accéder aux chemins d\'accès complets des fichiers et donc ne pourra pas les renommer. Veuillez vous rendre dans les paramètres et accorder manuellement l\'autorisation ; sinon, nous ne pourrons fournir aucun service."),
        "exitTitle": MessageLookupByLibrary.simpleMessage(
            "Impossible d\'accéder au stockage externe"),
        "expandOptions":
            MessageLookupByLibrary.simpleMessage("Développer les options"),
        "fileAlreadyExists": MessageLookupByLibrary.simpleMessage(
            "Le nom de fichier est déjà utilisé"),
        "fileCreateDate":
            MessageLookupByLibrary.simpleMessage("Date de création du fichier"),
        "fileCreateTime": MessageLookupByLibrary.simpleMessage(
            "Heure de création du fichier"),
        "fileManagerBackButton": MessageLookupByLibrary.simpleMessage("Retour"),
        "fileManagerSaveButton": MessageLookupByLibrary.simpleMessage(
            "Ajouter les fichiers sélectionnés à la liste"),
        "fileManagerSortButton":
            MessageLookupByLibrary.simpleMessage("Trier les fichiers"),
        "fileManagerStorageButton":
            MessageLookupByLibrary.simpleMessage("Sélectionner le stockage"),
        "fileModifyDate": MessageLookupByLibrary.simpleMessage(
            "Date de modification du fichier"),
        "fileModifyTime": MessageLookupByLibrary.simpleMessage(
            "Heure de modification du fichier"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Taille du fichier"),
        "fileSortDate": MessageLookupByLibrary.simpleMessage("Date"),
        "fileSortName": MessageLookupByLibrary.simpleMessage("Nom"),
        "fileSortSize": MessageLookupByLibrary.simpleMessage("Taille"),
        "fileSortType": MessageLookupByLibrary.simpleMessage("Type"),
        "files": MessageLookupByLibrary.simpleMessage("Fichiers"),
        "filesDirs":
            MessageLookupByLibrary.simpleMessage("Fichiers & Répertoires"),
        "filter": MessageLookupByLibrary.simpleMessage("Filtrer"),
        "fromStart": MessageLookupByLibrary.simpleMessage("À partir du début"),
        "goingForward": MessageLookupByLibrary.simpleMessage("Avancer"),
        "ifFileNotShown": MessageLookupByLibrary.simpleMessage(
            "Si aucun fichier n\'apparaît dans la liste, veuillez tout effacer et recommencer."),
        "ignoreExtension":
            MessageLookupByLibrary.simpleMessage("Ignorer l\'extension"),
        "increment": MessageLookupByLibrary.simpleMessage("Incrémenter"),
        "incrementToString": m0,
        "indexIncrementalStep": MessageLookupByLibrary.simpleMessage(
            "Pas d\'incrémentation d\'index"),
        "indexOne": MessageLookupByLibrary.simpleMessage("Première position"),
        "indexTwo": MessageLookupByLibrary.simpleMessage("Deuxième position"),
        "insert": MessageLookupByLibrary.simpleMessage("Insérer"),
        "insertBeforeIndex":
            MessageLookupByLibrary.simpleMessage("Insérer avant l\'index"),
        "insertIndex":
            MessageLookupByLibrary.simpleMessage("Index d\'insertion"),
        "insertTagInsideAnother": MessageLookupByLibrary.simpleMessage(
            "Ne pas insérer une balise à l\'intérieur d\'une autre."),
        "insertToString": m1,
        "insertedText": MessageLookupByLibrary.simpleMessage("Texte à insérer"),
        "iosRemindContent": MessageLookupByLibrary.simpleMessage(
            "Pour sélectionner des fichiers sur iOS, choisissez d\'abord le répertoire où se trouvent vos fichiers. Ensuite, dans le dossier sélectionné, choisissez les fichiers que vous souhaitez renommer. En raison des restrictions d\'iOS, nous devons procéder en deux étapes, ce qui garantit une gestion sécurisée des fichiers. Commençons !"),
        "iosRemindTitle": MessageLookupByLibrary.simpleMessage(
            "À propos de la sélection des fichiers sur iOS"),
        "isRegex": MessageLookupByLibrary.simpleMessage(
            "Utiliser les expressions régulières"),
        "keepCharacters": MessageLookupByLibrary.simpleMessage(
            "Conserver les caractères entre les deux positions"),
        "language": MessageLookupByLibrary.simpleMessage("Langue :"),
        "limit": MessageLookupByLibrary.simpleMessage("Limite"),
        "lowercaseAppName": MessageLookupByLibrary.simpleMessage("renommer"),
        "me": MessageLookupByLibrary.simpleMessage("Monténégrin"),
        "metadataParserNotProvided": MessageLookupByLibrary.simpleMessage(
            "Les balises de métadonnées sont incluses, mais aucun analyseur de métadonnées n\'a été fourni."),
        "metadataTags":
            MessageLookupByLibrary.simpleMessage("Balises de métadonnées"),
        "mk": MessageLookupByLibrary.simpleMessage("Macédonien"),
        "mn": MessageLookupByLibrary.simpleMessage("Mongol"),
        "musicAlbumArtist":
            MessageLookupByLibrary.simpleMessage("Artiste de l\'album"),
        "musicAlbumLength": MessageLookupByLibrary.simpleMessage(
            "Nombre de pistes dans l\'album"),
        "musicAlbumName":
            MessageLookupByLibrary.simpleMessage("Nom de l\'album"),
        "musicAuthor":
            MessageLookupByLibrary.simpleMessage("Auteur de la piste"),
        "musicDiscNumber":
            MessageLookupByLibrary.simpleMessage("Numéro du disque"),
        "musicGenres": MessageLookupByLibrary.simpleMessage("Genres musicaux"),
        "musicTrackArtist": MessageLookupByLibrary.simpleMessage(
            "Artiste interprète de la piste"),
        "musicTrackDuration":
            MessageLookupByLibrary.simpleMessage("Durée de la piste"),
        "musicTrackName":
            MessageLookupByLibrary.simpleMessage("Nom de la piste"),
        "musicTrackNumber": MessageLookupByLibrary.simpleMessage(
            "Numéro de piste dans l\'album"),
        "musicWriter":
            MessageLookupByLibrary.simpleMessage("Compositeur de la piste"),
        "musicYear": MessageLookupByLibrary.simpleMessage(
            "Année de publication de la piste"),
        "newName": MessageLookupByLibrary.simpleMessage("Nouveau nom"),
        "noSysDir": MessageLookupByLibrary.simpleMessage(
            "Ne pas renommer les répertoires système réservés."),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "omitDash": MessageLookupByLibrary.simpleMessage("Omettre le tiret"),
        "onlySelected": MessageLookupByLibrary.simpleMessage(
            "Uniquement les éléments sélectionnés"),
        "osNowTime": MessageLookupByLibrary.simpleMessage("Heure actuelle"),
        "osTodayDate": MessageLookupByLibrary.simpleMessage("Date actuelle"),
        "permissionContent": MessageLookupByLibrary.simpleMessage(
            "Pour vous fournir notre service de renommage de fichiers, nous avons besoin de votre autorisation pour gérer le stockage externe. Cela nous permet d\'accéder et de renommer les fichiers stockés sur votre appareil. Sans cette autorisation, l\'application ne pourra pas accéder aux chemins d\'accès complets des fichiers et donc ne pourra pas les renommer. Nous vous assurons que votre vie privée et votre sécurité sont nos principales priorités, et nous n\'accédons aux fichiers que dans le but de les renommer."),
        "permissionTitle": MessageLookupByLibrary.simpleMessage(
            "Autorisation pour le stockage externe"),
        "photoAltitude": MessageLookupByLibrary.simpleMessage(
            "Altitude GPS de la photo (EXIF)"),
        "photoAperture":
            MessageLookupByLibrary.simpleMessage("Ouverture (EXIF)"),
        "photoCamName": MessageLookupByLibrary.simpleMessage(
            "Nom de l\'appareil photo (EXIF)"),
        "photoCopyright": MessageLookupByLibrary.simpleMessage(
            "Nom du propriétaire des droits d\'auteur (EXIF)"),
        "photoDate": MessageLookupByLibrary.simpleMessage(
            "Date de prise de vue de la photo (EXIF)"),
        "photoFocalLength":
            MessageLookupByLibrary.simpleMessage("Longueur focale (EXIF)"),
        "photoISO":
            MessageLookupByLibrary.simpleMessage("Sensibilité ISO (EXIF)"),
        "photoLatitude": MessageLookupByLibrary.simpleMessage(
            "Latitude GPS de la photo (EXIF)"),
        "photoLensName":
            MessageLookupByLibrary.simpleMessage("Nom de l\'objectif (EXIF)"),
        "photoLongitude": MessageLookupByLibrary.simpleMessage(
            "Longitude GPS de la photo (EXIF)"),
        "photoPhotographer":
            MessageLookupByLibrary.simpleMessage("Nom du photographe (EXIF)"),
        "photoShutter": MessageLookupByLibrary.simpleMessage(
            "Vitesse d\'obturation (EXIF)"),
        "photoTime": MessageLookupByLibrary.simpleMessage(
            "Heure de prise de vue de la photo (EXIF)"),
        "prefix": MessageLookupByLibrary.simpleMessage("Préfixe"),
        "rating": MessageLookupByLibrary.simpleMessage("Noter l\'application"),
        "ratingContent": MessageLookupByLibrary.simpleMessage(
            "Vous aimez notre application ? Aidez-nous à grandir en lui donnant une note rapide sur le magasin d\'applications ou sur GitHub. Vos commentaires nous sont précieux ! Merci pour votre soutien."),
        "ratingGithub": MessageLookupByLibrary.simpleMessage(
            "Ajouter une étoile sur Github"),
        "ratingStore": MessageLookupByLibrary.simpleMessage(
            "Noter l\'application sur le magasin"),
        "ratingTitle":
            MessageLookupByLibrary.simpleMessage("Notez notre application"),
        "rearrange": MessageLookupByLibrary.simpleMessage("Réorganiser"),
        "rearrangeDelimiter":
            MessageLookupByLibrary.simpleMessage("Délimiteur"),
        "rearrangeOrderHint": MessageLookupByLibrary.simpleMessage(
            "Entrez les chiffres correspondants, séparés par des virgules"),
        "rearrangeOrderLabel":
            MessageLookupByLibrary.simpleMessage("Ordre de réorganisation"),
        "rearrangeToString": m2,
        "remove": MessageLookupByLibrary.simpleMessage("Supprimer"),
        "removeAll": MessageLookupByLibrary.simpleMessage("Tout supprimer"),
        "removeCharacters": MessageLookupByLibrary.simpleMessage(
            "Supprimer les caractères entre les deux positions"),
        "removeRenamed": MessageLookupByLibrary.simpleMessage(
            "Supprimer les éléments renommés"),
        "removeRule":
            MessageLookupByLibrary.simpleMessage("Supprimer cette règle"),
        "removeRules": MessageLookupByLibrary.simpleMessage(
            "Supprimer toutes les règles après le renommage"),
        "removeToString": m3,
        "rename": MessageLookupByLibrary.simpleMessage("Renommer"),
        "renameFailed":
            MessageLookupByLibrary.simpleMessage("Échec du renommage"),
        "replace": MessageLookupByLibrary.simpleMessage("Remplacer"),
        "replaceToString": m4,
        "replacement": MessageLookupByLibrary.simpleMessage("Remplacement"),
        "ru": MessageLookupByLibrary.simpleMessage("Russe"),
        "rulesSequentially": MessageLookupByLibrary.simpleMessage(
            "Les règles sont exécutées séquentiellement. Maintenez le bouton \'=\' à gauche d\'une règle et faites glisser pour les réorganiser."),
        "save": MessageLookupByLibrary.simpleMessage("Enregistrer"),
        "select": MessageLookupByLibrary.simpleMessage("Sélectionner"),
        "selectAll": MessageLookupByLibrary.simpleMessage("Tout sélectionner"),
        "semanticSwitchNumberToStartAndToEnd": m5,
        "semanticsDropdownButton": m6,
        "semanticsFileManagerDirSubtitle": m7,
        "semanticsFileManagerSubtitle": m8,
        "semanticsFileManagerTitle": m9,
        "semanticsFilesDropdownButton": MessageLookupByLibrary.simpleMessage(
            ". Sélectionnez ceci pour limiter les cibles de renommage à cette plage"),
        "semanticsMultipleActionsHint": MessageLookupByLibrary.simpleMessage(
            ", faites défiler vers le haut ou vers le bas pour changer d\'action."),
        "semanticsOpenMetadataDialog": MessageLookupByLibrary.simpleMessage(
            "Double-cliquez pour ouvrir une boîte de dialogue et sélectionner une balise de métadonnées à insérer."),
        "semanticsReorderableList": MessageLookupByLibrary.simpleMessage(
            "La liste des règles est actuellement vide. Appuyez sur le bouton \"Ajouter une règle\" pour en ajouter une. Les règles sont exécutées dans l\'ordre. Vous pouvez réorganiser cette liste en la faisant glisser vers le haut ou vers le bas, ou en la plaçant en haut ou en bas. Lorsque le curseur est sur une règle, faites défiler verticalement pour changer d\'action, et double-cliquez pour sélectionner l\'action."),
        "semanticsRuleDropdownButton": MessageLookupByLibrary.simpleMessage(
            ". Sélectionnez cela et appuyez sur le bouton \"Ajouter une règle\" pour ajouter cette règle"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Code source"),
        "sr": MessageLookupByLibrary.simpleMessage("Serbe"),
        "startIndex": MessageLookupByLibrary.simpleMessage("Index de départ"),
        "target": MessageLookupByLibrary.simpleMessage("Cible"),
        "tj": MessageLookupByLibrary.simpleMessage("Tadjik"),
        "toLast": MessageLookupByLibrary.simpleMessage("À la dernière"),
        "transliterate": MessageLookupByLibrary.simpleMessage("Translittérer"),
        "transliterateCyrillic2Latin": MessageLookupByLibrary.simpleMessage(
            "Convertir en caractères latins depuis le cyrillique"),
        "transliterateLatin2Cyrillic": MessageLookupByLibrary.simpleMessage(
            "Convertir en caractères cyrilliques depuis le latin"),
        "transliterateLower": MessageLookupByLibrary.simpleMessage(
            "Convertir en minuscules latines"),
        "transliteratePinyin": MessageLookupByLibrary.simpleMessage(
            "Transcrire le chinois en pinyin"),
        "transliterateSimplified": MessageLookupByLibrary.simpleMessage(
            "Convertir en chinois simplifié"),
        "transliterateToString": m10,
        "transliterateToStringCyrillic": m11,
        "transliterateTraditional": MessageLookupByLibrary.simpleMessage(
            "Convertir en chinois traditionnel"),
        "transliterateUpper": MessageLookupByLibrary.simpleMessage(
            "Convertir en majuscules latines"),
        "truncate": MessageLookupByLibrary.simpleMessage("Tronquer"),
        "truncateToString": m12,
        "ua": MessageLookupByLibrary.simpleMessage("Ukrainien")
      };
}
