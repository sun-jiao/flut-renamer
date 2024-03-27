// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  static String m0(prefix) => "Incrementar con \"${prefix}\" e índice";

  static String m1(toEnd, ordinal, insert, insertIndex) =>
      "Insertar \"${insert}\" en la posición ${Intl.select(toEnd, {
            'true': 'final',
            'false': 'inicial',
            'other': '',
          })} en el índice ${insertIndex}.";

  static String m2(delimiter, order) =>
      "Reorganizar con delimitador \"${delimiter}\" y orden \"${order}\".";

  static String m3(targetString) => "Eliminar \"${targetString}\"";

  static String m4(targetString, replacementString) =>
      "Reemplazar \"${targetString}\" con \"${replacementString}\".";

  static String m5(toEnd) =>
      "Cambiar la dirección de conteo entre desde el principio y desde el final, actualmente contando desde ${Intl.select(toEnd, {
            'true': 'el final',
            'false': 'el principio',
            'other': '',
          })}";

  static String m6(value) =>
      "Este es un botón desplegable. La selección actual es \"${value}\". Haz doble clic para abrir el menú desplegable y seleccionar otro valor.";

  static String m7(last) => "Última modificación: ${last}.";

  static String m8(last, size) =>
      "Última modificación: ${last}, Tamaño: ${size}.";

  static String m9(entityType, selectStatus, filename) =>
      "${Intl.select(selectStatus, {
            'true': 'Seleccionado',
            'false': 'No seleccionado',
            'other': '',
          })}${Intl.select(entityType, {
            'File': 'archivo',
            'Directory': 'directorio',
            'Link': 'enlace',
            'other': 'objeto del sistema de archivos',
          })} con nombre ${filename},";

  static String m10(type) => "Transliterar a \"${type}\".";

  static String m11(langName, type) =>
      "Transliterar a \"${type}\" en ${langName}.";

  static String m12(iTwoToEnd, iOneOrdinal, iOneToEnd, iTwoOrdinal, keepType,
          iOne, iTwo) =>
      "Truncar: ${Intl.select(keepType, {
            'true': 'Mantener',
            'false': 'Eliminar',
            'other': '',
          })} entre los caracteres ${iOne} y ${iTwo}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutContent": MessageLookupByLibrary.simpleMessage(
            "Esta aplicación está diseñada para ayudar a los usuarios a renombrar archivos. Está desarrollada con el framework Flutter, por lo que también es compatible con otros sistemas operativos. Es completamente de código abierto y puede ser revisada y contribuida por cualquiera."),
        "add": MessageLookupByLibrary.simpleMessage("Agregar"),
        "addFile": MessageLookupByLibrary.simpleMessage("Agregar archivo"),
        "addFiles":
            MessageLookupByLibrary.simpleMessage("Por favor, agrega archivos."),
        "addRule": MessageLookupByLibrary.simpleMessage("Agregar regla"),
        "androidRemindContent": MessageLookupByLibrary.simpleMessage(
            "Con el Flut Renamer, puede cambiar el nombre no solo de los archivos, sino también de los directorios. Mantenga presionado un directorio para seleccionarlo y luego seleccione \'Archivos y directorios\' en el botón desplegable de la esquina superior izquierda para habilitar el cambio de nombre de directorios. Por razones de seguridad, algunos directorios reservados por el sistema no se pueden seleccionar."),
        "androidRemindTitle":
            MessageLookupByLibrary.simpleMessage("Renombrar directorios"),
        "appError":
            MessageLookupByLibrary.simpleMessage("Error de la aplicación"),
        "appInfo": MessageLookupByLibrary.simpleMessage(
            "Información de la aplicación"),
        "appName": MessageLookupByLibrary.simpleMessage("Flut Renamer"),
        "bg": MessageLookupByLibrary.simpleMessage("Búlgaro"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "cancelAll": MessageLookupByLibrary.simpleMessage("Cancelar todo"),
        "caseSensitive":
            MessageLookupByLibrary.simpleMessage("Sensible a mayúsculas"),
        "collapseOptions":
            MessageLookupByLibrary.simpleMessage("Contraer opciones"),
        "currentName": MessageLookupByLibrary.simpleMessage("Nombre actual"),
        "descriptionIncrement": MessageLookupByLibrary.simpleMessage(
            "Incrementar el nombre del archivo, por ejemplo, Foto-1, Foto-2, Foto-3."),
        "descriptionInsert": MessageLookupByLibrary.simpleMessage(
            "Insertar texto especificado (o datos de metadatos y EXIF) en la posición especificada."),
        "descriptionRearrange": MessageLookupByLibrary.simpleMessage(
            "Dividir el nombre del archivo en segmentos utilizando el delimitador especificado y reorganizarlos según el orden proporcionado por el usuario."),
        "descriptionRemove": MessageLookupByLibrary.simpleMessage(
            "Eliminar texto especificado (o coincidente con la expresión regular proporcionada) del nombre del archivo."),
        "descriptionReplace": MessageLookupByLibrary.simpleMessage(
            "Reemplazar texto especificado (o coincidente con la expresión regular proporcionada) con el texto de reemplazo especificado (o datos de metadatos y EXIF)."),
        "descriptionTransliterate": MessageLookupByLibrary.simpleMessage(
            "Convertir caracteres según las especificaciones predefinidas, incluida la conversión a mayúsculas o minúsculas, a diferentes variantes de texto o a diferentes sistemas de escritura."),
        "descriptionTruncate": MessageLookupByLibrary.simpleMessage(
            "Eliminar o mantener una parte del nombre del archivo, desde un punto de inicio hasta un punto final especificados."),
        "directories": MessageLookupByLibrary.simpleMessage("Directorios"),
        "doNotRemindAgain": MessageLookupByLibrary.simpleMessage(
            "Aceptar, no volver a recordar"),
        "dragToAdd": MessageLookupByLibrary.simpleMessage(
            "Arrastra y suelta archivos para agregarlos."),
        "dropToAdd": MessageLookupByLibrary.simpleMessage(
            "Suelta archivos aquí para agregarlos."),
        "errorDetails":
            MessageLookupByLibrary.simpleMessage("Detalles del error"),
        "exit": MessageLookupByLibrary.simpleMessage("Salir"),
        "exitContent": MessageLookupByLibrary.simpleMessage(
            "El permiso para administrar el almacenamiento externo nos permite acceder y renombrar los archivos almacenados en tu dispositivo. Sin este permiso, la aplicación no podrá acceder a la ruta completa de los archivos, lo que impedirá la operación de renombrar. Por favor, ve a la página de configuración y otorga el permiso manualmente, de lo contrario no podremos ofrecerte ningún servicio."),
        "exitTitle": MessageLookupByLibrary.simpleMessage(
            "No se puede acceder al almacenamiento externo"),
        "expandOptions":
            MessageLookupByLibrary.simpleMessage("Expandir opciones"),
        "fileAlreadyExists": MessageLookupByLibrary.simpleMessage(
            "El nombre de archivo ya está en uso"),
        "fileCreateDate": MessageLookupByLibrary.simpleMessage(
            "Fecha de creación del archivo"),
        "fileCreateTime": MessageLookupByLibrary.simpleMessage(
            "Hora de creación del archivo"),
        "fileManagerBackButton": MessageLookupByLibrary.simpleMessage("Volver"),
        "fileManagerSaveButton": MessageLookupByLibrary.simpleMessage(
            "Agregar archivos seleccionados a la lista"),
        "fileManagerSortButton":
            MessageLookupByLibrary.simpleMessage("Ordenar archivos"),
        "fileManagerStorageButton":
            MessageLookupByLibrary.simpleMessage("Seleccionar almacenamiento"),
        "fileModifyDate": MessageLookupByLibrary.simpleMessage(
            "Fecha de modificación del archivo"),
        "fileModifyTime": MessageLookupByLibrary.simpleMessage(
            "Hora de modificación del archivo"),
        "fileNotExist":
            MessageLookupByLibrary.simpleMessage("El archivo no existe"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Tamaño del archivo"),
        "fileSortDate": MessageLookupByLibrary.simpleMessage("Fecha"),
        "fileSortName": MessageLookupByLibrary.simpleMessage("Nombre"),
        "fileSortSize": MessageLookupByLibrary.simpleMessage("Tamaño"),
        "fileSortType": MessageLookupByLibrary.simpleMessage("Tipo"),
        "files": MessageLookupByLibrary.simpleMessage("Archivos"),
        "filesDirs":
            MessageLookupByLibrary.simpleMessage("Archivos y directorios"),
        "filter": MessageLookupByLibrary.simpleMessage("Filtrar"),
        "fromStart": MessageLookupByLibrary.simpleMessage("Desde el inicio"),
        "goingForward": MessageLookupByLibrary.simpleMessage("Avanzar"),
        "ifFileNotShown": MessageLookupByLibrary.simpleMessage(
            "Si los archivos no se muestran en la lista, borra todo y continua."),
        "ignoreExtension":
            MessageLookupByLibrary.simpleMessage("Ignorar extensión"),
        "increment": MessageLookupByLibrary.simpleMessage("Incrementar"),
        "incrementToString": m0,
        "indexIncrementalStep":
            MessageLookupByLibrary.simpleMessage("Incremento de índice"),
        "indexOne": MessageLookupByLibrary.simpleMessage("Primera posición"),
        "indexTwo": MessageLookupByLibrary.simpleMessage("Segunda posición"),
        "insert": MessageLookupByLibrary.simpleMessage("Insertar"),
        "insertBeforeIndex":
            MessageLookupByLibrary.simpleMessage("Insertar antes del índice"),
        "insertIndex":
            MessageLookupByLibrary.simpleMessage("Índice de inserción"),
        "insertTagInsideAnother": MessageLookupByLibrary.simpleMessage(
            "No insertes una etiqueta dentro de otra."),
        "insertToString": m1,
        "insertedText": MessageLookupByLibrary.simpleMessage("Texto insertado"),
        "iosRemindContent": MessageLookupByLibrary.simpleMessage(
            "Para seleccionar archivos en iOS, primero elige una carpeta que contenga tus archivos. Luego, dentro de la carpeta seleccionada, elige los archivos que deseas renombrar. Debido a las limitaciones de iOS, debemos seguir estos dos pasos para garantizar el acceso seguro a los archivos. ¡Comencemos!"),
        "iosRemindTitle": MessageLookupByLibrary.simpleMessage(
            "Sobre la selección de archivos en iOS"),
        "isRegex":
            MessageLookupByLibrary.simpleMessage("Usar expresión regular"),
        "keepCharacters": MessageLookupByLibrary.simpleMessage(
            "Mantener caracteres entre ambos"),
        "language": MessageLookupByLibrary.simpleMessage("Idioma:"),
        "limit": MessageLookupByLibrary.simpleMessage("Límite"),
        "lowercaseAppName":
            MessageLookupByLibrary.simpleMessage("flut renamer"),
        "me": MessageLookupByLibrary.simpleMessage("Montenegrino"),
        "metadataParserNotProvided": MessageLookupByLibrary.simpleMessage(
            "Se incluyen etiquetas de metadatos pero no se proporciona un analizador de metadatos."),
        "metadataTags":
            MessageLookupByLibrary.simpleMessage("Etiquetas de metadatos"),
        "mk": MessageLookupByLibrary.simpleMessage("Macedonio"),
        "mn": MessageLookupByLibrary.simpleMessage("Mongol"),
        "musicAlbumArtist": MessageLookupByLibrary.simpleMessage(
            "Nombre del artista del álbum"),
        "musicAlbumLength": MessageLookupByLibrary.simpleMessage(
            "Cantidad de canciones en el álbum"),
        "musicAlbumName":
            MessageLookupByLibrary.simpleMessage("Nombre del álbum"),
        "musicAuthor":
            MessageLookupByLibrary.simpleMessage("Autor de la canción"),
        "musicDiscNumber":
            MessageLookupByLibrary.simpleMessage("Número del disco"),
        "musicGenres":
            MessageLookupByLibrary.simpleMessage("Géneros de la canción"),
        "musicTrackArtist": MessageLookupByLibrary.simpleMessage(
            "Nombre del artista de la canción"),
        "musicTrackDuration":
            MessageLookupByLibrary.simpleMessage("Duración de la canción"),
        "musicTrackName":
            MessageLookupByLibrary.simpleMessage("Nombre de la canción"),
        "musicTrackNumber": MessageLookupByLibrary.simpleMessage(
            "Número de la canción en el álbum"),
        "musicWriter":
            MessageLookupByLibrary.simpleMessage("Escritor de la canción"),
        "musicYear": MessageLookupByLibrary.simpleMessage("Año de publicación"),
        "newName": MessageLookupByLibrary.simpleMessage("Nuevo nombre"),
        "noSysDir": MessageLookupByLibrary.simpleMessage(
            "No renombres directorios reservados del sistema."),
        "ok": MessageLookupByLibrary.simpleMessage("Aceptar"),
        "omitDash": MessageLookupByLibrary.simpleMessage("Omitir guión"),
        "onlySelected": MessageLookupByLibrary.simpleMessage(
            "Renombrar solo los archivos seleccionados"),
        "osNowTime": MessageLookupByLibrary.simpleMessage("Hora actual"),
        "osTodayDate": MessageLookupByLibrary.simpleMessage("Fecha actual"),
        "permissionContent": MessageLookupByLibrary.simpleMessage(
            "Para ofrecer el servicio de renombrar archivos, necesitamos que nos autorices a administrar el almacenamiento externo. De esta manera, podremos acceder y renombrar los archivos almacenados en tu dispositivo. Sin este permiso, la aplicación no podrá acceder a la ruta completa de los archivos, lo que impedirá la operación de renombrar. Te aseguramos que valoramos mucho tu privacidad y seguridad, y solo accederemos a los archivos con el propósito de renombrarlos."),
        "permissionTitle": MessageLookupByLibrary.simpleMessage(
            "Permiso de almacenamiento externo"),
        "photoAltitude": MessageLookupByLibrary.simpleMessage(
            "Altitud GPS de la foto (EXIF)"),
        "photoAperture":
            MessageLookupByLibrary.simpleMessage("Apertura (EXIF)"),
        "photoCamName":
            MessageLookupByLibrary.simpleMessage("Nombre de la cámara (EXIF)"),
        "photoCopyright": MessageLookupByLibrary.simpleMessage(
            "Nombre del propietario de los derechos de autor (EXIF)"),
        "photoDate": MessageLookupByLibrary.simpleMessage(
            "Fecha de captura de la foto (EXIF)"),
        "photoFocalLength":
            MessageLookupByLibrary.simpleMessage("Longitud focal (EXIF)"),
        "photoISO": MessageLookupByLibrary.simpleMessage("ISO (EXIF)"),
        "photoLatitude": MessageLookupByLibrary.simpleMessage(
            "Latitud GPS de la foto (EXIF)"),
        "photoLensName":
            MessageLookupByLibrary.simpleMessage("Nombre del objetivo (EXIF)"),
        "photoLongitude": MessageLookupByLibrary.simpleMessage(
            "Longitud GPS de la foto (EXIF)"),
        "photoPhotographer":
            MessageLookupByLibrary.simpleMessage("Nombre del fotógrafo (EXIF)"),
        "photoShutter": MessageLookupByLibrary.simpleMessage(
            "Velocidad de obturación (EXIF)"),
        "photoTime": MessageLookupByLibrary.simpleMessage(
            "Hora de captura de la foto (EXIF)"),
        "prefix": MessageLookupByLibrary.simpleMessage("Prefijo"),
        "rating":
            MessageLookupByLibrary.simpleMessage("Calificar la aplicación"),
        "ratingContent": MessageLookupByLibrary.simpleMessage(
            "¿Te gusta nuestra aplicación? Ayúdanos a crecer calificándonos en la tienda de aplicaciones o dándonos un like en GitHub. ¡Tu feedback es muy importante para nosotros! Gracias por tu apoyo."),
        "ratingGithub":
            MessageLookupByLibrary.simpleMessage("Dar like en GitHub"),
        "ratingStore":
            MessageLookupByLibrary.simpleMessage("Calificar en la tienda"),
        "ratingTitle":
            MessageLookupByLibrary.simpleMessage("Califica nuestra aplicación"),
        "rearrange": MessageLookupByLibrary.simpleMessage("Reorganizar"),
        "rearrangeDelimiter":
            MessageLookupByLibrary.simpleMessage("Delimitador"),
        "rearrangeOrderHint": MessageLookupByLibrary.simpleMessage(
            "Ingrese los números correspondientes, separados por comas"),
        "rearrangeOrderLabel":
            MessageLookupByLibrary.simpleMessage("Orden de reorganización"),
        "rearrangeToString": m2,
        "remove": MessageLookupByLibrary.simpleMessage("Eliminar"),
        "removeAll": MessageLookupByLibrary.simpleMessage("Eliminar todo"),
        "removeCharacters": MessageLookupByLibrary.simpleMessage(
            "Eliminar caracteres entre ambos"),
        "removeRenamed": MessageLookupByLibrary.simpleMessage(
            "Eliminar archivos ya renombrados"),
        "removeRule":
            MessageLookupByLibrary.simpleMessage("Eliminar esta regla"),
        "removeRules": MessageLookupByLibrary.simpleMessage(
            "Eliminar todas las reglas después de renombrar"),
        "removeToString": m3,
        "rename": MessageLookupByLibrary.simpleMessage("Renombrar"),
        "renameFailed":
            MessageLookupByLibrary.simpleMessage("Error al renombrar"),
        "replace": MessageLookupByLibrary.simpleMessage("Reemplazar"),
        "replaceToString": m4,
        "replacement": MessageLookupByLibrary.simpleMessage("Reemplazo"),
        "ru": MessageLookupByLibrary.simpleMessage("Ruso"),
        "rulesSequentially": MessageLookupByLibrary.simpleMessage(
            "Las reglas se ejecutan secuencialmente. Haga clic en una regla para editarla. Mantenga presionado el botón \'=\' a la izquierda y arrástrelo para ordenar las reglas."),
        "save": MessageLookupByLibrary.simpleMessage("Guardar"),
        "select": MessageLookupByLibrary.simpleMessage("Seleccionar"),
        "selectAll": MessageLookupByLibrary.simpleMessage("Seleccionar todo"),
        "semanticSwitchNumberToStartAndToEnd": m5,
        "semanticsDropdownButton": m6,
        "semanticsFileManagerDirSubtitle": m7,
        "semanticsFileManagerSubtitle": m8,
        "semanticsFileManagerTitle": m9,
        "semanticsFilesDropdownButton": MessageLookupByLibrary.simpleMessage(
            ". Selecciona para limitar los objetivos de renombrar a este rango."),
        "semanticsMultipleActionsHint": MessageLookupByLibrary.simpleMessage(
            ", desliza hacia arriba y hacia abajo para cambiar entre otras acciones."),
        "semanticsOpenMetadataDialog": MessageLookupByLibrary.simpleMessage(
            "Haz doble clic para abrir un cuadro de diálogo y seleccionar una etiqueta de metadatos para insertar."),
        "semanticsReorderableList": MessageLookupByLibrary.simpleMessage(
            "La lista de reglas está actualmente vacía. Haz clic en \"Agregar regla\" para agregar una. Las reglas se ejecutan secuencialmente. Esta lista se puede reordenar para mover las reglas hacia arriba, hacia abajo, al principio o al final. Cuando el cursor está sobre una regla, usa un gesto de deslizamiento vertical para alternar entre diferentes acciones y haz doble clic para ejecutar la acción seleccionada."),
        "semanticsRuleDropdownButton": MessageLookupByLibrary.simpleMessage(
            ". Selecciónalo y haz clic en \"Agregar regla\" para agregar esta regla."),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Código fuente"),
        "sr": MessageLookupByLibrary.simpleMessage("Serbio"),
        "startIndex": MessageLookupByLibrary.simpleMessage("Índice inicial"),
        "target": MessageLookupByLibrary.simpleMessage("Objetivo"),
        "tj": MessageLookupByLibrary.simpleMessage("Tayiko"),
        "toLast": MessageLookupByLibrary.simpleMessage("Hasta el final"),
        "transliterate": MessageLookupByLibrary.simpleMessage("Transliterar"),
        "transliterateCyrillic2Latin": MessageLookupByLibrary.simpleMessage(
            "Transliterar de cirílico a caracteres latinos"),
        "transliterateLatin2Cyrillic": MessageLookupByLibrary.simpleMessage(
            "Transliterar de caracteres latinos a cirílico"),
        "transliterateLower": MessageLookupByLibrary.simpleMessage(
            "Transliterar a caracteres latinos en minúsculas"),
        "transliteratePinyin":
            MessageLookupByLibrary.simpleMessage("Transliterar chino a pinyin"),
        "transliterateSimplified": MessageLookupByLibrary.simpleMessage(
            "Transliterar a chino simplificado"),
        "transliterateToString": m10,
        "transliterateToStringCyrillic": m11,
        "transliterateTraditional": MessageLookupByLibrary.simpleMessage(
            "Transliterar a chino tradicional"),
        "transliterateUpper": MessageLookupByLibrary.simpleMessage(
            "Transliterar a caracteres latinos en mayúsculas"),
        "truncate": MessageLookupByLibrary.simpleMessage("Truncar"),
        "truncateToString": m12,
        "ua": MessageLookupByLibrary.simpleMessage("Ucraniano")
      };
}
