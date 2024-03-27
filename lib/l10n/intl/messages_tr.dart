// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a tr locale. All the
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
  String get localeName => 'tr';

  static String m0(prefix) => "Artır: ${prefix} - İndeks";

  static String m1(toEnd, ordinal, insert, insertIndex) =>
      "Ekle: \"${insert}\" metnini ${Intl.select(toEnd, {
            'true': 'son',
            'false': '',
          })} ${insertIndex}. konuma ekleyin.";

  static String m2(delimiter, order) =>
      "Yeniden Sırala: Ayraç: ${delimiter}, Sıra: ${order}.";

  static String m3(targetString) => "Kaldır: \"${targetString}\"";

  static String m4(targetString, replacementString) =>
      "Değiştir: \"${targetString}\" hedef metni \"${replacementString}\" ile değiştirin.";

  static String m5(toEnd) =>
      "Başlangıçtan ve sondan sayma yönünü değiştirme, şu anda ${Intl.select(toEnd, {
            'true': 'son',
            'false': 'başlangıç',
            'other': '',
          })} sayımından";

  static String m6(value) =>
      "Bu bir açılır düğmedir, şu anda seçili olan \'${value}\', başka bir değer seçmek için çift tıklayın.";

  static String m8(last, size) =>
      "En son değiştirilme zamanı ${last}, dosya boyutu ${size}";

  static String m9(entityType, selectStatus, filename) =>
      "${Intl.select(selectStatus, {
            'true': 'seçili olan',
            'false': 'seçili olmayan',
            'other': '',
          })}${Intl.select(entityType, {
            'File': 'dosya',
            'Directory': 'dizin',
            'Link': 'bağlantı',
            'other': 'dosya sistem öğesi',
          })}, adı ${filename}.";

  static String m10(type) => "Harf Değiştirme: ${type}.";

  static String m11(langName, type) => "Harf Değiştirme: ${langName} ${type}.";

  static String m12(iTwoToEnd, iOneOrdinal, iOneToEnd, iTwoOrdinal, keepType,
          iOne, iTwo) =>
      "Kırp: ${Intl.select(keepType, {
            'true': 'yalnızca tut',
            'false': 'kaldır',
            'other': '',
          })} ${Intl.select(iOneToEnd, {
            'true': 'sondan başlayarak',
            'false': '',
          })} ${iOne}. konumdan ${Intl.select(iTwoToEnd, {
            'true': 'sondan başlayarak',
            'false': '',
          })} ${iTwo}. konuma kadar içeriği.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutContent": MessageLookupByLibrary.simpleMessage(
            "Bu uygulama, kullanıcıların dosyaları yeniden adlandırmasına yardımcı olmayı amaçlamaktadır. Flutter çerçevesi kullanılarak geliştirilmiştir, bu nedenle diğer işletim sistemlerinde de kullanılabilir. Tamamen açık kaynaklıdır ve inceleme ve katkı sağlanabilir."),
        "add": MessageLookupByLibrary.simpleMessage("Ekle"),
        "addFile": MessageLookupByLibrary.simpleMessage("Dosya Ekle"),
        "addFiles":
            MessageLookupByLibrary.simpleMessage("Lütfen dosyalar ekleyin."),
        "addRule": MessageLookupByLibrary.simpleMessage("Kural Ekle"),
        "androidRemindContent": MessageLookupByLibrary.simpleMessage(
            "Flut Renamer\'ı kullanarak sadece dosyaların değil, dizinlerin de adını değiştirebilirsiniz. Bir dizini seçmek için uzun basın, ardından dizin yeniden adlandırmayı etkinleştirmek için sol üst köşedeki açılır düğmeden \'Dosyalar ve Dizinler\'i seçin. Güvenlik nedeniyle, bazı sistem ayrılmış dizinler seçilemez."),
        "androidRemindTitle":
            MessageLookupByLibrary.simpleMessage("Klasör Yeniden Adlandırma"),
        "appError": MessageLookupByLibrary.simpleMessage("Uygulama Hatası"),
        "appInfo": MessageLookupByLibrary.simpleMessage("Uygulama Bilgileri"),
        "appName": MessageLookupByLibrary.simpleMessage("Flut Renamer"),
        "bg": MessageLookupByLibrary.simpleMessage("Bulgarca"),
        "cancel": MessageLookupByLibrary.simpleMessage("İptal"),
        "cancelAll": MessageLookupByLibrary.simpleMessage("Tümünü İptal Et"),
        "caseSensitive":
            MessageLookupByLibrary.simpleMessage("Büyük Küçük Harfe Duyarlı"),
        "collapseOptions":
            MessageLookupByLibrary.simpleMessage("Seçenekleri Daralt"),
        "currentName": MessageLookupByLibrary.simpleMessage("Mevcut Dosya Adı"),
        "descriptionIncrement": MessageLookupByLibrary.simpleMessage(
            "Dosya adını artırın, örneğin Fotoğraf-1, Fotoğraf-2, Fotoğraf-3."),
        "descriptionInsert": MessageLookupByLibrary.simpleMessage(
            "Belirtilen konuma belirtilen metni (veya dosya meta verisi ve EXIF verileriyle) ekleyin."),
        "descriptionRearrange": MessageLookupByLibrary.simpleMessage(
            "Dosya adını kullanıcı tarafından belirtilen bir ayraçla parçalara bölebilir ve belirtilen sıraya göre yeniden düzenleyebilirsiniz."),
        "descriptionRemove": MessageLookupByLibrary.simpleMessage(
            "Belirtilen metni (veya verilen düzenli ifadeyle eşleşen metni) dosya adından kaldırın."),
        "descriptionReplace": MessageLookupByLibrary.simpleMessage(
            "Belirtilen metni (veya verilen düzenli ifadeyle eşleşen metni) verilen değiştirme metni (veya dosya meta verisi ve EXIF verileriyle) ile değiştirin."),
        "descriptionTransliterate": MessageLookupByLibrary.simpleMessage(
            "Önceden tanımlanmış bir standarta göre karakterleri değiştirin, büyük veya küçük harfleri değiştirin, farklı metin varyantlarına veya farklı yazı sistemlerine dönüştürün."),
        "descriptionTruncate": MessageLookupByLibrary.simpleMessage(
            "Dosya adının belirli bir kısmını silin veya koruyun, belirli bir konumdan başlayarak başka bir konuma kadar."),
        "directories": MessageLookupByLibrary.simpleMessage("Klasörler"),
        "doNotRemindAgain":
            MessageLookupByLibrary.simpleMessage("Tamam, Bir Daha Hatırlatma"),
        "dragToAdd": MessageLookupByLibrary.simpleMessage(
            "Eklemek için dosyaları sürükleyin."),
        "dropToAdd":
            MessageLookupByLibrary.simpleMessage("Dosyaları buraya bırakın."),
        "errorDetails": MessageLookupByLibrary.simpleMessage("Hata Detayları"),
        "exit": MessageLookupByLibrary.simpleMessage("Çıkış"),
        "exitContent": MessageLookupByLibrary.simpleMessage(
            "Dış depolama yönetimi izni, cihazınızdaki dosyalara erişmemizi ve onları yeniden adlandırmamızı sağlar. Bu izin olmadan uygulama dosyaların tam yoluna erişemeyecek ve dolayısıyla yeniden adlandırma işlemi yapılamayacak. Lütfen ayarlara gidip izni manuel olarak verin, aksi takdirde herhangi bir hizmet sağlayamayacağız."),
        "exitTitle":
            MessageLookupByLibrary.simpleMessage("Dış Depolama Erişilemiyor"),
        "expandOptions":
            MessageLookupByLibrary.simpleMessage("Seçenekleri Genişlet"),
        "fileAlreadyExists":
            MessageLookupByLibrary.simpleMessage("Dosya Adı Zaten Kullanımda"),
        "fileCreateDate":
            MessageLookupByLibrary.simpleMessage("Dosya Oluşturma Tarihi"),
        "fileCreateTime":
            MessageLookupByLibrary.simpleMessage("Dosya Oluşturma Saati"),
        "fileManagerBackButton": MessageLookupByLibrary.simpleMessage("Geri"),
        "fileManagerSaveButton": MessageLookupByLibrary.simpleMessage(
            "Seçilen Dosyaları Listeye Ekle"),
        "fileManagerSortButton":
            MessageLookupByLibrary.simpleMessage("Dosyaları Sırala"),
        "fileManagerStorageButton":
            MessageLookupByLibrary.simpleMessage("Depolama Alanını Seç"),
        "fileModifyDate":
            MessageLookupByLibrary.simpleMessage("Dosya Değiştirme Tarihi"),
        "fileModifyTime":
            MessageLookupByLibrary.simpleMessage("Dosya Değiştirme Saati"),
        "fileNotExist":
            MessageLookupByLibrary.simpleMessage("Dosya mevcut değil"),
        "fileSize": MessageLookupByLibrary.simpleMessage("Dosya Boyutu"),
        "fileSortDate": MessageLookupByLibrary.simpleMessage("Tarih"),
        "fileSortName": MessageLookupByLibrary.simpleMessage("Ad"),
        "fileSortSize": MessageLookupByLibrary.simpleMessage("Boyut"),
        "fileSortType": MessageLookupByLibrary.simpleMessage("Tür"),
        "files": MessageLookupByLibrary.simpleMessage("Dosyalar"),
        "filesDirs":
            MessageLookupByLibrary.simpleMessage("Dosyalar ve Klasörler"),
        "filter": MessageLookupByLibrary.simpleMessage("Filtrele"),
        "fromStart": MessageLookupByLibrary.simpleMessage("Baştan Başla"),
        "goingForward": MessageLookupByLibrary.simpleMessage("İleri Gitme"),
        "ifFileNotShown": MessageLookupByLibrary.simpleMessage(
            "Dosya listesinde dosyalar görüntülenmiyorsa, tüm içeriği temizleyin ve devam edin."),
        "ignoreExtension":
            MessageLookupByLibrary.simpleMessage("Uzantıyı Yoksay"),
        "increment": MessageLookupByLibrary.simpleMessage("Artır"),
        "incrementToString": m0,
        "indexIncrementalStep":
            MessageLookupByLibrary.simpleMessage("İndeks Artış Adımı"),
        "indexOne": MessageLookupByLibrary.simpleMessage("Birinci Konum"),
        "indexTwo": MessageLookupByLibrary.simpleMessage("İkinci Konum"),
        "insert": MessageLookupByLibrary.simpleMessage("Ekle"),
        "insertBeforeIndex":
            MessageLookupByLibrary.simpleMessage("İndeks Öncesine Ekle"),
        "insertIndex": MessageLookupByLibrary.simpleMessage("Ekleme İndeksi"),
        "insertTagInsideAnother": MessageLookupByLibrary.simpleMessage(
            "Lütfen bir etiketin içine başka bir etiket eklemeyin."),
        "insertToString": m1,
        "insertedText": MessageLookupByLibrary.simpleMessage("Eklenecek Metin"),
        "iosRemindContent": MessageLookupByLibrary.simpleMessage(
            "iOS\'ta dosya seçmek için öncelikle dosyalarınızı içeren bir klasör seçin. Ardından, seçtiğiniz klasörde yeniden adlandırmak istediğiniz dosyayı seçin. iOS\'un kısıtlamaları nedeniyle bu iki adımı izlememiz gerekiyor, bu da dosyalara güvenli erişimi sağlar. Haydi başlayalım!"),
        "iosRemindTitle": MessageLookupByLibrary.simpleMessage(
            "iOS\'ta Dosya Seçimi Hakkında"),
        "isRegex": MessageLookupByLibrary.simpleMessage("Düzenli İfade Kullan"),
        "keepCharacters": MessageLookupByLibrary.simpleMessage(
            "İki Konum Arasındaki Karakterleri Tut"),
        "language": MessageLookupByLibrary.simpleMessage("Dil:"),
        "limit": MessageLookupByLibrary.simpleMessage("Sınır"),
        "lowercaseAppName":
            MessageLookupByLibrary.simpleMessage("flut renamer"),
        "me": MessageLookupByLibrary.simpleMessage("Karadağca"),
        "metadataParserNotProvided": MessageLookupByLibrary.simpleMessage(
            "Meta veri etiketleri içeriyor ancak meta veri ayrıştırıcısı sağlanmadı."),
        "metadataTags":
            MessageLookupByLibrary.simpleMessage("Meta Veri Etiketleri"),
        "mk": MessageLookupByLibrary.simpleMessage("Makedonca"),
        "mn": MessageLookupByLibrary.simpleMessage("Moğolca"),
        "musicAlbumArtist":
            MessageLookupByLibrary.simpleMessage("Albüm Sanatçısı"),
        "musicAlbumLength":
            MessageLookupByLibrary.simpleMessage("Albümdeki Şarkı Sayısı"),
        "musicAlbumName": MessageLookupByLibrary.simpleMessage("Albüm Adı"),
        "musicAuthor": MessageLookupByLibrary.simpleMessage("Yazar"),
        "musicDiscNumber":
            MessageLookupByLibrary.simpleMessage("Disk Numarası"),
        "musicGenres": MessageLookupByLibrary.simpleMessage("Müzik Türleri"),
        "musicTrackArtist": MessageLookupByLibrary.simpleMessage("Şarkıcı"),
        "musicTrackDuration":
            MessageLookupByLibrary.simpleMessage("Şarkı Süresi"),
        "musicTrackName": MessageLookupByLibrary.simpleMessage("Şarkı Adı"),
        "musicTrackNumber":
            MessageLookupByLibrary.simpleMessage("Şarkı Numarası"),
        "musicWriter": MessageLookupByLibrary.simpleMessage("Yazar"),
        "musicYear":
            MessageLookupByLibrary.simpleMessage("Şarkının Yayın Yılı"),
        "newName": MessageLookupByLibrary.simpleMessage("Yeni Dosya Adı"),
        "noSysDir": MessageLookupByLibrary.simpleMessage(
            "Lütfen sistem korumalı klasörleri yeniden adlandırmayın."),
        "ok": MessageLookupByLibrary.simpleMessage("Tamam"),
        "omitDash": MessageLookupByLibrary.simpleMessage("Tireyi Atla"),
        "onlySelected": MessageLookupByLibrary.simpleMessage(
            "Yalnızca Seçili Dosyaları Yeniden Adlandır"),
        "osNowTime": MessageLookupByLibrary.simpleMessage("Şu Anki Zaman"),
        "osTodayDate": MessageLookupByLibrary.simpleMessage("Bugünün Tarihi"),
        "permissionContent": MessageLookupByLibrary.simpleMessage(
            "Dosya yeniden adlandırma hizmetini sunabilmemiz için dış depolama yönetimi iznine ihtiyacımız var. Böylece cihazınızda depolanan dosyalara erişebilir ve yeniden adlandırabiliriz. Bu izin olmadan uygulama dosyaların tam yoluna erişemeyecek ve dolayısıyla yeniden adlandırma işlemi yapılamayacak. Gizliliğinize ve güvenliğinize büyük önem verdiğimizi temin ederiz, sadece yeniden adlandırma amacıyla dosyalara erişeceğiz."),
        "permissionTitle":
            MessageLookupByLibrary.simpleMessage("Dış Depolama İzni"),
        "photoAltitude": MessageLookupByLibrary.simpleMessage(
            "Fotoğraf GPS Yüksekliği (EXIF\'ten)"),
        "photoAperture":
            MessageLookupByLibrary.simpleMessage("Diyafram Değeri (EXIF\'ten)"),
        "photoCamName":
            MessageLookupByLibrary.simpleMessage("Kamera Adı (EXIF\'ten)"),
        "photoCopyright": MessageLookupByLibrary.simpleMessage(
            "Telif Hakkı Sahibi Adı (EXIF\'ten)"),
        "photoDate": MessageLookupByLibrary.simpleMessage(
            "Fotoğraf Çekim Tarihi (EXIF\'ten)"),
        "photoFocalLength":
            MessageLookupByLibrary.simpleMessage("Odak Uzunluğu (EXIF\'ten)"),
        "photoISO":
            MessageLookupByLibrary.simpleMessage("ISO Değeri (EXIF\'ten)"),
        "photoLatitude": MessageLookupByLibrary.simpleMessage(
            "Fotoğraf GPS Enlemi (EXIF\'ten)"),
        "photoLensName":
            MessageLookupByLibrary.simpleMessage("Lens Adı (EXIF\'ten)"),
        "photoLongitude": MessageLookupByLibrary.simpleMessage(
            "Fotoğraf GPS Boylamı (EXIF\'ten)"),
        "photoPhotographer":
            MessageLookupByLibrary.simpleMessage("Fotoğrafçı Adı (EXIF\'ten)"),
        "photoShutter":
            MessageLookupByLibrary.simpleMessage("Enstantane Hızı (EXIF\'ten)"),
        "photoTime": MessageLookupByLibrary.simpleMessage(
            "Fotoğraf Çekim Saati (EXIF\'ten)"),
        "prefix": MessageLookupByLibrary.simpleMessage("Ön Ek"),
        "rating": MessageLookupByLibrary.simpleMessage("Uygulama Puanı"),
        "ratingContent": MessageLookupByLibrary.simpleMessage(
            "Uygulamamızı beğendiniz mi? Mağazada iyi bir puan vererek veya GitHub\'da beğenerek bize destek olun. Geri bildiriminiz bizim için çok önemlidir! Desteğiniz için teşekkür ederiz."),
        "ratingGithub":
            MessageLookupByLibrary.simpleMessage("GitHub Deposuna Beğeni Ver"),
        "ratingStore":
            MessageLookupByLibrary.simpleMessage("Mağazada Puan Ver"),
        "ratingTitle":
            MessageLookupByLibrary.simpleMessage("Uygulamamızı Değerlendirin"),
        "rearrange": MessageLookupByLibrary.simpleMessage("Yeniden Sırala"),
        "rearrangeDelimiter": MessageLookupByLibrary.simpleMessage("Ayraç"),
        "rearrangeOrderHint": MessageLookupByLibrary.simpleMessage(
            "Sıralamak için ilgili sayıları virgülle ayırarak girin"),
        "rearrangeOrderLabel":
            MessageLookupByLibrary.simpleMessage("Yeniden Sıralama Sırası"),
        "rearrangeToString": m2,
        "remove": MessageLookupByLibrary.simpleMessage("Kaldır"),
        "removeAll": MessageLookupByLibrary.simpleMessage("Tümünü Kaldır"),
        "removeCharacters": MessageLookupByLibrary.simpleMessage(
            "İki Konum Arasındaki Karakterleri Kaldır"),
        "removeRenamed": MessageLookupByLibrary.simpleMessage(
            "Yeniden Adlandırılan Dosyaları Kaldır"),
        "removeRule": MessageLookupByLibrary.simpleMessage("Kuralı Kaldır"),
        "removeRules": MessageLookupByLibrary.simpleMessage(
            "Yeniden Adlandırma Sonrası Tüm Kuralları Kaldır"),
        "removeToString": m3,
        "rename": MessageLookupByLibrary.simpleMessage("Yeniden Adlandır"),
        "renameFailed": MessageLookupByLibrary.simpleMessage(
            "Yeniden Adlandırma Başarısız Oldu"),
        "replace": MessageLookupByLibrary.simpleMessage("Değiştir"),
        "replaceToString": m4,
        "replacement": MessageLookupByLibrary.simpleMessage("Değiştirme"),
        "ru": MessageLookupByLibrary.simpleMessage("Rusça"),
        "rulesSequentially": MessageLookupByLibrary.simpleMessage(
            "Kurallar sırayla uygulanır, kuralları sıralamak için sol taraftaki \'=\' düğmesini basılı tutun ve sürükleyin."),
        "save": MessageLookupByLibrary.simpleMessage("Kaydet"),
        "select": MessageLookupByLibrary.simpleMessage("Seç"),
        "selectAll": MessageLookupByLibrary.simpleMessage("Tümünü Seç"),
        "semanticSwitchNumberToStartAndToEnd": m5,
        "semanticsDropdownButton": m6,
        "semanticsFileManagerSubtitle": m8,
        "semanticsFileManagerTitle": m9,
        "semanticsFilesDropdownButton": MessageLookupByLibrary.simpleMessage(
            ". Yeniden adlandırma hedefini bu kapsamda sınırlamak için bu öğeyi seçin"),
        "semanticsMultipleActionsHint": MessageLookupByLibrary.simpleMessage(
            ", Diğer işlemlere geçmek için yukarı veya aşağı kaydırın."),
        "semanticsOpenMetadataDialog": MessageLookupByLibrary.simpleMessage(
            "Açıklamak için çift tıklayın ve içinden eklemek istediğiniz meta veri etiketini seçin."),
        "semanticsReorderableList": MessageLookupByLibrary.simpleMessage(
            "Kural listesi şu anda boş. Bir tane eklemek için \'Kural Ekle\' düğmesine tıklayın. Kurallar sırayla uygulanır. Bu liste yeniden düzenlenebilir, böylece kuralları yukarı ve aşağı taşıyabilir, onları listenin başına veya sonuna taşıyabilirsiniz. Bir kural üzerindeyken, dikey kaydırma hareketleri arasında geçiş yapmak ve seçilen işlemi çift tıklayarak gerçekleştirmek için kullanın."),
        "semanticsRuleDropdownButton": MessageLookupByLibrary.simpleMessage(
            ". Bu seçeneği seçin ve kural eklemek için \'Kural Ekle\' düğmesine tıklayın"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("Kaynak Kodu"),
        "sr": MessageLookupByLibrary.simpleMessage("Sırpça"),
        "startIndex": MessageLookupByLibrary.simpleMessage("Başlangıç İndeksi"),
        "target": MessageLookupByLibrary.simpleMessage("Hedef"),
        "tj": MessageLookupByLibrary.simpleMessage("Tacikçe"),
        "toLast": MessageLookupByLibrary.simpleMessage("Son\'a Kadar"),
        "transliterate":
            MessageLookupByLibrary.simpleMessage("Harf Değiştirme"),
        "transliterateCyrillic2Latin": MessageLookupByLibrary.simpleMessage(
            "Kiril\'den Latin Harfine Dönüştür"),
        "transliterateLatin2Cyrillic": MessageLookupByLibrary.simpleMessage(
            "Latin Harfinden Kiril\'e Dönüştür"),
        "transliterateLower": MessageLookupByLibrary.simpleMessage(
            "Küçük Latin Harfine Dönüştür"),
        "transliteratePinyin":
            MessageLookupByLibrary.simpleMessage("Çinceden Pinyin\'e Dönüştür"),
        "transliterateSimplified": MessageLookupByLibrary.simpleMessage(
            "Basitleştirilmiş Çince\'ye Dönüştür"),
        "transliterateToString": m10,
        "transliterateToStringCyrillic": m11,
        "transliterateTraditional": MessageLookupByLibrary.simpleMessage(
            "Geleneksel Çince\'ye Dönüştür"),
        "transliterateUpper": MessageLookupByLibrary.simpleMessage(
            "Büyük Latin Harfine Dönüştür"),
        "truncate": MessageLookupByLibrary.simpleMessage("Kırp"),
        "truncateToString": m12,
        "ua": MessageLookupByLibrary.simpleMessage("Ukraynaca")
      };
}
