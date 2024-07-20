// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt locale. All the
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
  String get localeName => 'pt';

  static String m0(prefix) => "Incrementar: ${prefix} - índice";

  static String m1(toEnd, ordinal, insert, insertIndex) =>
      "Inserir: inserir \"${insert}\" na ${Intl.select(toEnd, {
            'true': 'última',
            'false': '',
            'other': '',
          })} posição ${insertIndex}.";

  static String m2(delimiter, order) =>
      "Rearranjar: delimitador: ${delimiter}, ordem: ${order}.";

  static String m3(targetString) => "Remover: \"${targetString}\"";

  static String m4(targetString, replacementString) =>
      "Substituir: substituir \"${targetString}\" por \"${replacementString}\".";

  static String m5(toEnd) =>
      "Alternar direção de contagem entre do início e do fim, atualmente contando a partir de ${Intl.select(toEnd, {
            'true': 'o final',
            'false': 'o início',
            'other': '',
          })}";

  static String m6(value) =>
      "Este é um botão suspenso. O valor selecionado atualmente é \"${value}\". Dê um duplo clique para abrir o menu suspenso e selecionar outro valor.";

  static String m7(last) => "Última modificação em ${last}.";

  static String m8(last, size) =>
      "Última modificação em ${last}, tamanho do arquivo ${size}.";

  static String m9(entityType, selectStatus, filename) =>
      "${Intl.select(selectStatus, {
            'true': 'Selecionado',
            'false': 'Não selecionado',
            'other': '',
          })}${Intl.select(entityType, {
            'File': 'arquivo',
            'Directory': 'diretório',
            'Link': 'link',
            'other': 'objeto do sistema de arquivos',
          })} chamado ${filename},";

  static String m10(type) => "Transliterar: ${type}.";

  static String m11(langName, type) =>
      "Transliterar: de ${langName} para ${type}.";

  static String m12(iTwoToEnd, iOneOrdinal, iOneToEnd, iTwoOrdinal, keepType,
          iOne, iTwo) =>
      "Truncar: ${Intl.select(keepType, {
            'true': 'manter apenas',
            'false': 'remover',
            'other': '',
          })} do ${Intl.select(iOneToEnd, {
            'true': 'último',
            'false': '',
            'other': '',
          })} ${iOne}º ao ${Intl.select(iTwoToEnd, {
            'true': 'último',
            'false': '',
            'other': '',
          })} ${iTwo}º caractere.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutContent": MessageLookupByLibrary.simpleMessage(
            "Este aplicativo destina-se a ajudar os usuários a renomear arquivos. Ele é desenvolvido com o framework Flutter, portanto, é compatível com outros sistemas operacionais. É totalmente open source, permitindo revisão e contribuição."),
        "add": MessageLookupByLibrary.simpleMessage("Adicionar"),
        "addFile": MessageLookupByLibrary.simpleMessage("Adicionar arquivo"),
        "addFiles": MessageLookupByLibrary.simpleMessage(
            "Por favor, adicione arquivos."),
        "addRule": MessageLookupByLibrary.simpleMessage("Adicionar regra"),
        "androidRemindContent": MessageLookupByLibrary.simpleMessage(
            "Usando o Flut Renamer, você pode renomear não apenas arquivos, mas também diretórios. Pressione e segure um diretório para selecioná-lo e, em seguida, selecione \'Arquivos e diretórios\' no botão suspenso no canto superior esquerdo para habilitar a renomeação de diretórios. Por motivos de segurança, alguns diretórios reservados pelo sistema não são selecionáveis."),
        "androidRemindTitle":
            MessageLookupByLibrary.simpleMessage("Renomear diretórios"),
        "appError": MessageLookupByLibrary.simpleMessage("Erro do aplicativo"),
        "appInfo":
            MessageLookupByLibrary.simpleMessage("Informações do aplicativo"),
        "appName": MessageLookupByLibrary.simpleMessage("Flut Renamer"),
        "bg": MessageLookupByLibrary.simpleMessage("Búlgaro"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "cancelAll": MessageLookupByLibrary.simpleMessage("Cancelar tudo"),
        "caseSensitive": MessageLookupByLibrary.simpleMessage(
            "Diferenciar maiúsculas de minúsculas"),
        "collapseOptions":
            MessageLookupByLibrary.simpleMessage("Recolher opções"),
        "currentName": MessageLookupByLibrary.simpleMessage("Nome atual"),
        "descriptionIncrement": MessageLookupByLibrary.simpleMessage(
            "Incrementar o nome do arquivo, por exemplo, Foto-1, Foto-2, Foto-3."),
        "descriptionInsert": MessageLookupByLibrary.simpleMessage(
            "Inserir o texto especificado (ou metadados de arquivo e dados EXIF) em uma posição específica."),
        "descriptionRearrange": MessageLookupByLibrary.simpleMessage(
            "Dividir o nome do arquivo em segmentos usando um delimitador especificado pelo usuário e rearranjá-los na ordem especificada."),
        "descriptionRemove": MessageLookupByLibrary.simpleMessage(
            "Remover o texto especificado (ou texto correspondente a uma expressão regular fornecida) do nome do arquivo."),
        "descriptionReplace": MessageLookupByLibrary.simpleMessage(
            "Substituir o texto especificado (ou texto correspondente a uma expressão regular fornecida) pelo texto de substituição fornecido (ou metadados de arquivo e dados EXIF)."),
        "descriptionTransliterate": MessageLookupByLibrary.simpleMessage(
            "Converter caracteres de acordo com uma especificação predefinida, incluindo converter para maiúsculas ou minúsculas, converter para diferentes variantes de texto ou converter para diferentes sistemas de escrita."),
        "descriptionTruncate": MessageLookupByLibrary.simpleMessage(
            "Remover ou manter uma parte especificada do nome do arquivo, de uma posição especificada a outra."),
        "directories": MessageLookupByLibrary.simpleMessage("Diretórios"),
        "doNotRemindAgain":
            MessageLookupByLibrary.simpleMessage("Não mostrar novamente"),
        "dragNotSupported": MessageLookupByLibrary.simpleMessage(
            "Devido a restrições de segurança do sistema, não é suportado arrastar e soltar arquivos desta aplicação."),
        "dragToAdd": MessageLookupByLibrary.simpleMessage(
            "Arraste e solte arquivos para adicionar."),
        "dropToAdd": MessageLookupByLibrary.simpleMessage(
            "Solte os arquivos aqui para adicionar."),
        "errorDetails":
            MessageLookupByLibrary.simpleMessage("Detalhes do erro"),
        "exit": MessageLookupByLibrary.simpleMessage("Sair"),
        "exitContent": MessageLookupByLibrary.simpleMessage(
            "A permissão para gerenciar o armazenamento externo permite que acessemos e renomeemos os arquivos armazenados no seu dispositivo. Sem essa permissão, o aplicativo não poderá acessar o caminho completo do arquivo e, portanto, não poderá renomeá-lo. Por favor, vá para as configurações e conceda a permissão manualmente, caso contrário, não seremos capazes de fornecer nenhum serviço."),
        "exitTitle": MessageLookupByLibrary.simpleMessage(
            "Impossível acessar o armazenamento externo"),
        "expandOptions":
            MessageLookupByLibrary.simpleMessage("Expandir opções"),
        "fileAlreadyExists": MessageLookupByLibrary.simpleMessage(
            "O nome do arquivo já está em uso"),
        "fileCreateDate":
            MessageLookupByLibrary.simpleMessage("Data de criação do arquivo"),
        "fileCreateTime":
            MessageLookupByLibrary.simpleMessage("Hora de criação do arquivo"),
        "fileManagerBackButton": MessageLookupByLibrary.simpleMessage("Voltar"),
        "fileManagerSaveButton": MessageLookupByLibrary.simpleMessage(
            "Adicionar arquivos selecionados à lista"),
        "fileManagerSortButton":
            MessageLookupByLibrary.simpleMessage("Ordenar arquivos"),
        "fileManagerStorageButton":
            MessageLookupByLibrary.simpleMessage("Selecionar armazenamento"),
        "fileModifyDate": MessageLookupByLibrary.simpleMessage(
            "Data de modificação do arquivo"),
        "fileModifyTime": MessageLookupByLibrary.simpleMessage(
            "Hora de modificação do arquivo"),
        "fileNotExist":
            MessageLookupByLibrary.simpleMessage("Arquivo não existe"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Tamanho do arquivo"),
        "fileSortDate": MessageLookupByLibrary.simpleMessage("Data"),
        "fileSortName": MessageLookupByLibrary.simpleMessage("Nome"),
        "fileSortSize": MessageLookupByLibrary.simpleMessage("Tamanho"),
        "fileSortType": MessageLookupByLibrary.simpleMessage("Tipo"),
        "files": MessageLookupByLibrary.simpleMessage("Arquivos"),
        "filesDirs":
            MessageLookupByLibrary.simpleMessage("Arquivos e diretórios"),
        "filter": MessageLookupByLibrary.simpleMessage("Filtrar"),
        "fromStart": MessageLookupByLibrary.simpleMessage("Do início"),
        "goingForward":
            MessageLookupByLibrary.simpleMessage("Indo para frente"),
        "hideHiddenFiles":
            MessageLookupByLibrary.simpleMessage("Ocultar arquivos ocultos"),
        "ifFileNotShown": MessageLookupByLibrary.simpleMessage(
            "Se os arquivos não estiverem listados, limpe tudo e continue."),
        "ignoreExtension":
            MessageLookupByLibrary.simpleMessage("Ignorar extensão"),
        "increment": MessageLookupByLibrary.simpleMessage("Incrementar"),
        "incrementToString": m0,
        "indexIncrementalStep":
            MessageLookupByLibrary.simpleMessage("Incremento do índice"),
        "indexOne": MessageLookupByLibrary.simpleMessage("Primeira posição"),
        "indexTwo": MessageLookupByLibrary.simpleMessage("Segunda posição"),
        "insert": MessageLookupByLibrary.simpleMessage("Inserir"),
        "insertBeforeIndex":
            MessageLookupByLibrary.simpleMessage("Inserir antes do índice"),
        "insertIndex":
            MessageLookupByLibrary.simpleMessage("Índice de inserção"),
        "insertTagInsideAnother": MessageLookupByLibrary.simpleMessage(
            "Não insira uma tag dentro de outra."),
        "insertToString": m1,
        "insertedText":
            MessageLookupByLibrary.simpleMessage("Texto a ser inserido"),
        "iosRemindContent": MessageLookupByLibrary.simpleMessage(
            "Para selecionar arquivos no iOS, primeiro selecione uma pasta que contenha seus arquivos. Em seguida, dentro da pasta selecionada, escolha os arquivos que deseja renomear. Devido às limitações do iOS, precisamos seguir essas duas etapas para garantir o acesso seguro aos arquivos. Vamos começar!"),
        "iosRemindTitle": MessageLookupByLibrary.simpleMessage(
            "Sobre a seleção de arquivos no iOS"),
        "isRegex":
            MessageLookupByLibrary.simpleMessage("Usar expressão regular"),
        "keepCharacters": MessageLookupByLibrary.simpleMessage(
            "Manter caracteres entre os dois"),
        "language": MessageLookupByLibrary.simpleMessage("Idioma:"),
        "limit": MessageLookupByLibrary.simpleMessage("Limite"),
        "lowercaseAppName":
            MessageLookupByLibrary.simpleMessage("flut renamer"),
        "me": MessageLookupByLibrary.simpleMessage("Montenegrino"),
        "metadataParserNotProvided": MessageLookupByLibrary.simpleMessage(
            "Tags de metadados estão presentes, mas nenhum analisador de metadados foi fornecido."),
        "metadataTags":
            MessageLookupByLibrary.simpleMessage("Tags de metadados"),
        "mk": MessageLookupByLibrary.simpleMessage("Macedônio"),
        "mn": MessageLookupByLibrary.simpleMessage("Mongol"),
        "musicAlbumArtist":
            MessageLookupByLibrary.simpleMessage("Nome do artista do álbum"),
        "musicAlbumLength":
            MessageLookupByLibrary.simpleMessage("Número de faixas no álbum"),
        "musicAlbumName": MessageLookupByLibrary.simpleMessage("Nome do álbum"),
        "musicAuthor": MessageLookupByLibrary.simpleMessage("Autor da faixa"),
        "musicDiscNumber":
            MessageLookupByLibrary.simpleMessage("Número do disco"),
        "musicGenres": MessageLookupByLibrary.simpleMessage("Gêneros da faixa"),
        "musicTrackArtist":
            MessageLookupByLibrary.simpleMessage("Nome do artista da faixa"),
        "musicTrackDuration":
            MessageLookupByLibrary.simpleMessage("Duração da faixa"),
        "musicTrackName": MessageLookupByLibrary.simpleMessage("Nome da faixa"),
        "musicTrackNumber":
            MessageLookupByLibrary.simpleMessage("Número da faixa no álbum"),
        "musicWriter":
            MessageLookupByLibrary.simpleMessage("Escritor da faixa"),
        "musicYear":
            MessageLookupByLibrary.simpleMessage("Ano de lançamento da faixa"),
        "newName": MessageLookupByLibrary.simpleMessage("Novo nome"),
        "noSysDir": MessageLookupByLibrary.simpleMessage(
            "Não renomeie diretórios protegidos pelo sistema."),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "omitDash": MessageLookupByLibrary.simpleMessage("Omitir hífen"),
        "onlySelected": MessageLookupByLibrary.simpleMessage(
            "Renomear apenas os arquivos selecionados"),
        "osNowTime": MessageLookupByLibrary.simpleMessage("Hora atual"),
        "osTodayDate": MessageLookupByLibrary.simpleMessage("Data atual"),
        "permissionContent": MessageLookupByLibrary.simpleMessage(
            "Para fornecer o serviço de renomeação de arquivos, precisamos da sua autorização para gerenciar o armazenamento externo. Isso nos permitirá acessar e renomear os arquivos armazenados no seu dispositivo. Sem essa permissão, o aplicativo não poderá acessar o caminho completo do arquivo e, portanto, não poderá renomeá-lo. Garantimos que valorizamos muito sua privacidade e segurança e só acessaremos os arquivos com o propósito de renomeação."),
        "permissionTitle": MessageLookupByLibrary.simpleMessage(
            "Permissão de armazenamento externo"),
        "photoAltitude": MessageLookupByLibrary.simpleMessage(
            "Altitude GPS da foto (do EXIF)"),
        "photoAperture": MessageLookupByLibrary.simpleMessage(
            "Valor do diafragma (do EXIF)"),
        "photoCamName":
            MessageLookupByLibrary.simpleMessage("Nome da câmera (do EXIF)"),
        "photoCopyright": MessageLookupByLibrary.simpleMessage(
            "Nome do detentor dos direitos autorais (do EXIF)"),
        "photoDate": MessageLookupByLibrary.simpleMessage(
            "Data de captura da foto (do EXIF)"),
        "photoFocalLength":
            MessageLookupByLibrary.simpleMessage("Distância focal (do EXIF)"),
        "photoISO": MessageLookupByLibrary.simpleMessage("Valor ISO (do EXIF)"),
        "photoLatitude": MessageLookupByLibrary.simpleMessage(
            "Latitude GPS da foto (do EXIF)"),
        "photoLensName":
            MessageLookupByLibrary.simpleMessage("Nome da lente (do EXIF)"),
        "photoLongitude": MessageLookupByLibrary.simpleMessage(
            "Longitude GPS da foto (do EXIF)"),
        "photoPhotographer":
            MessageLookupByLibrary.simpleMessage("Nome do fotógrafo (do EXIF)"),
        "photoShutter": MessageLookupByLibrary.simpleMessage(
            "Velocidade do obturador (do EXIF)"),
        "photoTime": MessageLookupByLibrary.simpleMessage(
            "Hora de captura da foto (do EXIF)"),
        "prefix": MessageLookupByLibrary.simpleMessage("Prefixo"),
        "rating": MessageLookupByLibrary.simpleMessage("Avalie o aplicativo"),
        "ratingContent": MessageLookupByLibrary.simpleMessage(
            "Está gostando do nosso aplicativo? Deixe uma avaliação na loja de aplicativos ou dê um like no GitHub para nos ajudar a crescer. Seu feedback é muito importante para nós! Obrigado pelo apoio."),
        "ratingGithub": MessageLookupByLibrary.simpleMessage(
            "Curtir o repositório no GitHub"),
        "ratingStore": MessageLookupByLibrary.simpleMessage("Avaliar na loja"),
        "ratingTitle":
            MessageLookupByLibrary.simpleMessage("Avalie nosso aplicativo"),
        "rearrange": MessageLookupByLibrary.simpleMessage("Rearranjar"),
        "rearrangeDelimiter":
            MessageLookupByLibrary.simpleMessage("Delimitador"),
        "rearrangeOrderHint": MessageLookupByLibrary.simpleMessage(
            "Insira os números correspondentes, separados por vírgula"),
        "rearrangeOrderLabel":
            MessageLookupByLibrary.simpleMessage("Ordem de rearranjo"),
        "rearrangeToString": m2,
        "remove": MessageLookupByLibrary.simpleMessage("Remover"),
        "removeAll": MessageLookupByLibrary.simpleMessage("Remover tudo"),
        "removeCharacters": MessageLookupByLibrary.simpleMessage(
            "Remover caracteres entre os dois"),
        "removeRenamed":
            MessageLookupByLibrary.simpleMessage("Remover arquivos renomeados"),
        "removeRule":
            MessageLookupByLibrary.simpleMessage("Remover esta regra"),
        "removeRules": MessageLookupByLibrary.simpleMessage(
            "Remover todas as regras após renomear"),
        "removeToString": m3,
        "rename": MessageLookupByLibrary.simpleMessage("Renomear"),
        "renameFailed":
            MessageLookupByLibrary.simpleMessage("Falha ao renomear"),
        "replace": MessageLookupByLibrary.simpleMessage("Substituir"),
        "replaceToString": m4,
        "replacement": MessageLookupByLibrary.simpleMessage("Substituição"),
        "ru": MessageLookupByLibrary.simpleMessage("Russo"),
        "rulesSequentially": MessageLookupByLibrary.simpleMessage(
            " As regras são executadas sequencialmente. Clique em uma regra para editá-la. Mantenha pressionado o botão \'=\' à esquerda e arraste-o para classificar as regras."),
        "save": MessageLookupByLibrary.simpleMessage("Salvar"),
        "select": MessageLookupByLibrary.simpleMessage("Selecionar"),
        "selectAll": MessageLookupByLibrary.simpleMessage("Selecionar tudo"),
        "semanticSwitchNumberToStartAndToEnd": m5,
        "semanticsDropdownButton": m6,
        "semanticsFileManagerDirSubtitle": m7,
        "semanticsFileManagerSubtitle": m8,
        "semanticsFileManagerTitle": m9,
        "semanticsFilesDropdownButton": MessageLookupByLibrary.simpleMessage(
            ". Selecione isso para limitar os arquivos renomeados a este escopo"),
        "semanticsMultipleActionsHint": MessageLookupByLibrary.simpleMessage(
            ", role para cima ou para baixo para alternar entre outras ações."),
        "semanticsOpenMetadataDialog": MessageLookupByLibrary.simpleMessage(
            "Clique duplo para abrir um diálogo e selecionar as tags de metadados a serem inseridas."),
        "semanticsReorderableList": MessageLookupByLibrary.simpleMessage(
            "A lista de regras está vazia agora. Clique em \"Adicionar regra\" para adicionar uma. As regras são executadas em ordem. Esta lista pode ser reordenada, permitindo mover as regras para cima ou para baixo, bem como movê-las para o topo ou para o final. Com o cursor sobre uma regra, use o gesto de rolagem vertical para alternar entre diferentes ações e clique duplo para executar a ação selecionada."),
        "semanticsRuleDropdownButton": MessageLookupByLibrary.simpleMessage(
            ". Selecione isto e clique em \"Adicionar regra\" para adicionar esta regra"),
        "showHiddenFiles":
            MessageLookupByLibrary.simpleMessage("Mostrar arquivos ocultos"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Código-fonte"),
        "sr": MessageLookupByLibrary.simpleMessage("Sérvio"),
        "startIndex": MessageLookupByLibrary.simpleMessage("Índice inicial"),
        "target": MessageLookupByLibrary.simpleMessage("Alvo"),
        "tj": MessageLookupByLibrary.simpleMessage("Tadjique"),
        "toLast": MessageLookupByLibrary.simpleMessage("Para o último"),
        "transliterate": MessageLookupByLibrary.simpleMessage("Transliterar"),
        "transliterateCyrillic2Latin": MessageLookupByLibrary.simpleMessage(
            "Transliterar caracteres cirílicos para latinos"),
        "transliterateLatin2Cyrillic": MessageLookupByLibrary.simpleMessage(
            "Transliterar caracteres latinos para cirílicos"),
        "transliterateLower": MessageLookupByLibrary.simpleMessage(
            "Transliterar para caracteres latinos minúsculos"),
        "transliteratePinyin": MessageLookupByLibrary.simpleMessage(
            "Transliterar chinês para pinyin"),
        "transliterateSimplified": MessageLookupByLibrary.simpleMessage(
            "Transliterar para chinês simplificado"),
        "transliterateToString": m10,
        "transliterateToStringCyrillic": m11,
        "transliterateTraditional": MessageLookupByLibrary.simpleMessage(
            "Transliterar para chinês tradicional"),
        "transliterateUpper": MessageLookupByLibrary.simpleMessage(
            "Transliterar para caracteres latinos maiúsculos"),
        "truncate": MessageLookupByLibrary.simpleMessage("Truncar"),
        "truncateToString": m12,
        "ua": MessageLookupByLibrary.simpleMessage("Ucraniano")
      };
}
