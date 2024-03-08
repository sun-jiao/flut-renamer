// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a th locale. All the
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
  String get localeName => 'th';

  static String m0(prefix) => "เพิ่ม: ${prefix}-เลขดัชนี";

  static String m1(toEnd, ordinal, insert, insertIndex) =>
      "แทรก: แทรก \"${insert}\" ที่ตำแหน่งที่ ${Intl.select(toEnd, {
            'true': 'สุดท้าย',
            'false': '',
            'other': '',
          })} ${insertIndex}";

  static String m2(delimiter, order) =>
      "จัดเรียงใหม่: ตัวคั่น: \"${delimiter}\", ลำดับ: ${order}";

  static String m3(targetString) => "ลบ: \"${targetString}\"";

  static String m4(targetString, replacementString) =>
      "แทนที่: แทนที่ \"${targetString}\" ด้วย \"${replacementString}\"";

  static String m5(toEnd) =>
      "สลับทิศทางการนับระหว่างจากจุดเริ่มต้นและจากจุดสิ้นสุด ณ ปัจจุบันกำลังนับจาก ${Intl.select(toEnd, {
            'true': 'จุดสิ้นสุด',
            'false': 'จุดเริ่มต้น',
            'other': '',
          })}";

  static String m6(value) =>
      "นี่คือปุ่มลดลง ที่ตอนนี้เลือกคือ \"${value}\" กดสองครั้งเพื่อเปิดปุ่มลดลงและเลือกค่าอื่น";

  static String m7(last) => "แก้ไขล่าสุดเมื่อ ${last}";

  static String m8(last, size) => "แก้ไขล่าสุดเมื่อ ${last} ขนาดไฟล์ ${size}";

  static String m9(entityType, selectStatus, filename) =>
      "${Intl.select(selectStatus, {
            'true': 'ไฟล์ที่เลือก',
            'false': 'ไฟล์ที่ไม่ได้เลือก',
            'other': 'อ็อบเจ็กต์ในระบบไฟล์',
          })} ชื่อไฟล์คือ ${filename} และ";

  static String m10(type) => "การเปลี่ยนตัวอักษร: ${type}";

  static String m11(langName, type) =>
      "การเปลี่ยนตัวอักษร: แปลงจาก ${langName} ${type}";

  static String m12(iTwoToEnd, iOneOrdinal, iOneToEnd, iTwoOrdinal, keepType,
          iOne, iTwo) =>
      "ตัด: ${Intl.select(keepType, {
            'true': 'เก็บเฉพาะ',
            'false': 'ลบ',
            'other': '',
          })} ตั้งแต่ตำแหน่งที่ ${Intl.select(iOneToEnd, {
            'true': 'สุดท้าย',
            'false': '',
            'other': '',
          })} ${iOne} ไปยังตำแหน่งที่ ${Intl.select(iTwoToEnd, {
            'true': 'สุดท้าย',
            'false': '',
            'other': '',
          })} ${iTwo}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutContent": MessageLookupByLibrary.simpleMessage(
            "แอปนี้ถูกพัฒนาขึ้นเพื่อช่วยให้ผู้ใช้สามารถเปลี่ยนชื่อไฟล์ได้ มันถูกพัฒนาด้วย Flutter framework ซึ่งทำให้มันเหมาะสำหรับระบบปฏิบัติการอื่น ๆ ด้วย มันเป็นโปรเจ็กต์โอเพนซอร์สอย่างเต็มที่และสามารถตรวจสอบและมีส่วนร่วมได้"),
        "add": MessageLookupByLibrary.simpleMessage("เพิ่ม"),
        "addFile": MessageLookupByLibrary.simpleMessage("เพิ่มไฟล์"),
        "addFiles": MessageLookupByLibrary.simpleMessage("โปรดเพิ่มไฟล์"),
        "addRule": MessageLookupByLibrary.simpleMessage("เพิ่มกฏ"),
        "androidRemindContent": MessageLookupByLibrary.simpleMessage(
            "การใช้ Flut Renamer คุณสามารถเปลี่ยนชื่อไฟล์และไดเรกทอรีได้ กดค้างไดเรกทอรีเพื่อเลือก จากนั้นเลือก \'ไฟล์และไดเรกทอรี\' จากปุ่มแบบเลื่อนลงที่มุมบนซ้ายเพื่อเปิดใช้งานการเปลี่ยนชื่อไดเรกทอรี เนื่องจากเหตุผลด้านความปลอดภัย บางไดเรกทอรีที่สงวนไว้สำหรับระบบจะไม่สามารถเลือกได้"),
        "androidRemindTitle":
            MessageLookupByLibrary.simpleMessage("เปลี่ยนชื่อโฟลเดอร์"),
        "appError": MessageLookupByLibrary.simpleMessage("ข้อผิดพลาดของแอป"),
        "appInfo": MessageLookupByLibrary.simpleMessage("ข้อมูลแอป"),
        "appName": MessageLookupByLibrary.simpleMessage("Flut Renamer"),
        "bg": MessageLookupByLibrary.simpleMessage("ภาษาบัลแกเรีย"),
        "cancel": MessageLookupByLibrary.simpleMessage("ยกเลิก"),
        "cancelAll": MessageLookupByLibrary.simpleMessage("ยกเลิกทั้งหมด"),
        "caseSensitive":
            MessageLookupByLibrary.simpleMessage("ตรวจสอบตัวพิมพ์ใหญ่เล็ก"),
        "collapseOptions": MessageLookupByLibrary.simpleMessage("ยุบตัวเลือก"),
        "currentName": MessageLookupByLibrary.simpleMessage("ชื่อไฟล์ปัจจุบัน"),
        "descriptionIncrement": MessageLookupByLibrary.simpleMessage(
            "เพิ่มเลขดัชนีในชื่อไฟล์ (เช่น รูปภาพ-1, รูปภาพ-2, รูปภาพ-3)"),
        "descriptionInsert": MessageLookupByLibrary.simpleMessage(
            "แทรกข้อความที่ระบุ (หรือข้อมูลเมตาดาต้าและ EXIF) ที่ตำแหน่งที่ระบุ"),
        "descriptionRearrange": MessageLookupByLibrary.simpleMessage(
            "แยกชื่อไฟล์เป็นส่วนๆ ด้วยตัวคั่นที่ระบุ และจัดเรียงตามลำดับที่กำหนด"),
        "descriptionRemove": MessageLookupByLibrary.simpleMessage(
            "ลบข้อความที่ระบุ (หรือข้อมูลเมตาดาต้าและ EXIF) ออกจากชื่อไฟล์"),
        "descriptionReplace": MessageLookupByLibrary.simpleMessage(
            "แทนที่ข้อความที่ระบุ (หรือข้อมูลเมตาดาต้าและ EXIF) ด้วยข้อความที่ระบุ (หรือข้อมูลเมตาดาต้าและ EXIF) ที่กำหนด"),
        "descriptionTransliterate": MessageLookupByLibrary.simpleMessage(
            "แปลงตัวอักษรตามรูปแบบที่กำหนด เช่น เปลี่ยนเป็นตัวพิมพ์ใหญ่หรือตัวพิมพ์เล็ก"),
        "descriptionTruncate": MessageLookupByLibrary.simpleMessage(
            "ตัดหรือเก็บเฉพาะส่วนที่กำหนดของชื่อไฟล์"),
        "directories": MessageLookupByLibrary.simpleMessage("โฟลเดอร์"),
        "doNotRemindAgain":
            MessageLookupByLibrary.simpleMessage("ตกลง ไม่ต้องเตือนอีก"),
        "dragToAdd":
            MessageLookupByLibrary.simpleMessage("ลากและวางไฟล์เพื่อเพิ่ม"),
        "dropToAdd":
            MessageLookupByLibrary.simpleMessage("วางไฟล์ที่นี่เพื่อเพิ่ม"),
        "errorDetails":
            MessageLookupByLibrary.simpleMessage("รายละเอียดข้อผิดพลาด"),
        "exit": MessageLookupByLibrary.simpleMessage("ออก"),
        "exitContent": MessageLookupByLibrary.simpleMessage(
            "การอนุญาตให้เข้าถึงพื้นที่จัดเก็บภายนอกช่วยให้เราเข้าถึงและเปลี่ยนชื่อไฟล์ที่เก็บบนอุปกรณ์ของคุณ หากไม่มีการอนุญาตนี้แอปจะไม่สามารถเข้าถึงเส้นทางของไฟล์ได้อย่างสมบูรณ์ซึ่งทำให้ไม่สามารถดำเนินการเปลี่ยนชื่อได้ กรุณาไปที่หน้าการตั้งค่าเพื่อให้สิทธิ์ด้วยตนเอง มิฉะนั้นเราจะไม่สามารถให้บริการใด ๆ"),
        "exitTitle": MessageLookupByLibrary.simpleMessage(
            "ไม่สามารถเข้าถึงพื้นที่จัดเก็บภายนอกได้"),
        "expandOptions": MessageLookupByLibrary.simpleMessage("ขยายตัวเลือก"),
        "fileAlreadyExists":
            MessageLookupByLibrary.simpleMessage("ชื่อไฟล์ถูกใช้แล้ว"),
        "fileCreateDate":
            MessageLookupByLibrary.simpleMessage("วันที่สร้างไฟล์"),
        "fileCreateTime": MessageLookupByLibrary.simpleMessage("เวลาสร้างไฟล์"),
        "fileManagerBackButton":
            MessageLookupByLibrary.simpleMessage("ย้อนกลับ"),
        "fileManagerSaveButton": MessageLookupByLibrary.simpleMessage(
            "เพิ่มไฟล์ที่เลือกเข้าสู่รายการ"),
        "fileManagerSortButton":
            MessageLookupByLibrary.simpleMessage("เรียงลำดับไฟล์"),
        "fileManagerStorageButton":
            MessageLookupByLibrary.simpleMessage("เลือกพื้นที่จัดเก็บ"),
        "fileModifyDate":
            MessageLookupByLibrary.simpleMessage("วันที่แก้ไขไฟล์"),
        "fileModifyTime": MessageLookupByLibrary.simpleMessage("เวลาแก้ไขไฟล์"),
        "fileSize": MessageLookupByLibrary.simpleMessage("ขนาดไฟล์"),
        "fileSortDate": MessageLookupByLibrary.simpleMessage("วันที่"),
        "fileSortName": MessageLookupByLibrary.simpleMessage("ชื่อ"),
        "fileSortSize": MessageLookupByLibrary.simpleMessage("ขนาด"),
        "fileSortType": MessageLookupByLibrary.simpleMessage("ประเภท"),
        "files": MessageLookupByLibrary.simpleMessage("ไฟล์"),
        "filesDirs": MessageLookupByLibrary.simpleMessage("ไฟล์และโฟลเดอร์"),
        "filter": MessageLookupByLibrary.simpleMessage("กรอง"),
        "fromStart": MessageLookupByLibrary.simpleMessage("จากจุดเริ่มต้น"),
        "goingForward": MessageLookupByLibrary.simpleMessage("ไปข้างหน้า"),
        "ifFileNotShown": MessageLookupByLibrary.simpleMessage(
            "หากไม่มีไฟล์แสดงในรายการโปรดล้างข้อมูลทั้งหมดและลองอีกครั้ง"),
        "ignoreExtension":
            MessageLookupByLibrary.simpleMessage("ละเว้นนามสกุล"),
        "increment": MessageLookupByLibrary.simpleMessage("เพิ่ม"),
        "incrementToString": m0,
        "indexIncrementalStep":
            MessageLookupByLibrary.simpleMessage("ขั้นตอนการเพิ่มดัชนี"),
        "indexOne": MessageLookupByLibrary.simpleMessage("ตำแหน่งแรก"),
        "indexTwo": MessageLookupByLibrary.simpleMessage("ตำแหน่งที่สอง"),
        "insert": MessageLookupByLibrary.simpleMessage("แทรก"),
        "insertBeforeIndex":
            MessageLookupByLibrary.simpleMessage("แทรกก่อนดัชนี"),
        "insertIndex": MessageLookupByLibrary.simpleMessage("แทรกดัชนี"),
        "insertTagInsideAnother":
            MessageLookupByLibrary.simpleMessage("อย่าแทรกแท็กในแท็กอื่น"),
        "insertToString": m1,
        "insertedText": MessageLookupByLibrary.simpleMessage("ข้อความที่แทรก"),
        "iosRemindContent": MessageLookupByLibrary.simpleMessage(
            "เพื่อเลือกไฟล์บน iOS โปรดเลือกโฟลเดอร์ที่มีไฟล์ของคุณก่อน จากนั้นในโฟลเดอร์ที่เลือก เลือกไฟล์ที่ต้องการเปลี่ยนชื่อ จากข้อจำกัดของ iOS เราต้องทำขั้นตอนเหล่านี้เพื่อให้มั่นใจว่ามีการเข้าถึงไฟล์อย่างปลอดภัย มาเริ่มต้นเลย!"),
        "iosRemindTitle":
            MessageLookupByLibrary.simpleMessage("เกี่ยวกับการเลือกไฟล์บน iOS"),
        "isRegex":
            MessageLookupByLibrary.simpleMessage("ใช้เป็น Regular Expression"),
        "keepCharacters":
            MessageLookupByLibrary.simpleMessage("เก็บอักขระทั้งสองข้าง"),
        "language": MessageLookupByLibrary.simpleMessage("ภาษา:"),
        "limit": MessageLookupByLibrary.simpleMessage("จำกัด"),
        "lowercaseAppName":
            MessageLookupByLibrary.simpleMessage("flut renamer"),
        "me": MessageLookupByLibrary.simpleMessage("เมอร์เซเดีย"),
        "metadataParserNotProvided": MessageLookupByLibrary.simpleMessage(
            "มีแท็กข้อมูลแต่ไม่มีตัวแยก ไม่สามารถแยกและดึงข้อมูลได้"),
        "metadataTags": MessageLookupByLibrary.simpleMessage("แท็กข้อมูลเมตา"),
        "mk": MessageLookupByLibrary.simpleMessage("มาซีโดเนีย"),
        "mn": MessageLookupByLibrary.simpleMessage("มองโกเลีย"),
        "musicAlbumArtist":
            MessageLookupByLibrary.simpleMessage("ชื่อศิลปินอัลบั้ม"),
        "musicAlbumLength":
            MessageLookupByLibrary.simpleMessage("จำนวนเพลงในอัลบั้ม"),
        "musicAlbumName": MessageLookupByLibrary.simpleMessage("ชื่ออัลบั้ม"),
        "musicAuthor": MessageLookupByLibrary.simpleMessage("ผู้เขียนเพลง"),
        "musicDiscNumber":
            MessageLookupByLibrary.simpleMessage("ลำดับของดิสก์"),
        "musicGenres": MessageLookupByLibrary.simpleMessage("แนวเพลง"),
        "musicTrackArtist": MessageLookupByLibrary.simpleMessage("ศิลปินเพลง"),
        "musicTrackDuration":
            MessageLookupByLibrary.simpleMessage("ระยะเวลาเพลง"),
        "musicTrackName": MessageLookupByLibrary.simpleMessage("ชื่อเพลง"),
        "musicTrackNumber":
            MessageLookupByLibrary.simpleMessage("ลำดับของเพลงในอัลบั้ม"),
        "musicWriter": MessageLookupByLibrary.simpleMessage("ผู้แต่งเนื้อเพลง"),
        "musicYear": MessageLookupByLibrary.simpleMessage("ปีที่เพลงออก"),
        "newName": MessageLookupByLibrary.simpleMessage("ชื่อใหม่"),
        "noSysDir": MessageLookupByLibrary.simpleMessage(
            "อย่าเปลี่ยนชื่อโฟลเดอร์ที่ระบบสงวนไว้"),
        "ok": MessageLookupByLibrary.simpleMessage("ตกลง"),
        "omitDash": MessageLookupByLibrary.simpleMessage("ละเว้นขีด"),
        "onlySelected": MessageLookupByLibrary.simpleMessage(
            "เปลี่ยนชื่อเฉพาะไฟล์ที่เลือก"),
        "osNowTime": MessageLookupByLibrary.simpleMessage("เวลาปัจจุบัน"),
        "osTodayDate": MessageLookupByLibrary.simpleMessage("วันที่ปัจจุบัน"),
        "permissionContent": MessageLookupByLibrary.simpleMessage(
            "เพื่อให้บริการการเปลี่ยนชื่อไฟล์ เราต้องขออนุญาตให้เข้าถึงพื้นที่จัดเก็บภายนอกของคุณ นี้จะช่วยให้เราเข้าถึงและเปลี่ยนชื่อไฟล์ที่เก็บบนอุปกรณ์ของคุณ หากไม่มีการอนุญาตนี้แอปจะไม่สามารถเข้าถึงเส้นทางของไฟล์ได้อย่างสมบูรณ์ซึ่งทำให้ไม่สามารถดำเนินการเปลี่ยนชื่อได้ พวกเราขอรับประกันว่าเราใส่ใจความเป็นส่วนตัวและความปลอดภัยของคุณอย่างสูงและเราจะเข้าถึงไฟล์เพียงเท่าที่จำเป็นเพื่อการเปลี่ยนชื่อ"),
        "permissionTitle": MessageLookupByLibrary.simpleMessage(
            "การอนุญาตให้เข้าถึงพื้นที่จัดเก็บภายนอก"),
        "photoAltitude": MessageLookupByLibrary.simpleMessage(
            "ความสูงจากระดับน้ำทะเลของรูปภาพ (จาก exif)"),
        "photoAperture":
            MessageLookupByLibrary.simpleMessage("ค่ารูรับแสง (จาก exif)"),
        "photoCamName":
            MessageLookupByLibrary.simpleMessage("ชื่อกล้อง (จาก exif)"),
        "photoCopyright": MessageLookupByLibrary.simpleMessage(
            "ชื่อเจ้าของลิขสิทธิ์ (จาก exif)"),
        "photoDate":
            MessageLookupByLibrary.simpleMessage("วันที่ถ่ายภาพ (จาก exif)"),
        "photoFocalLength":
            MessageLookupByLibrary.simpleMessage("ระยะโฟกัส (จาก exif)"),
        "photoISO": MessageLookupByLibrary.simpleMessage("ค่า ISO (จาก exif)"),
        "photoLatitude":
            MessageLookupByLibrary.simpleMessage("ละติจูดของรูปภาพ (จาก exif)"),
        "photoLensName":
            MessageLookupByLibrary.simpleMessage("ชื่อเลนส์ (จาก exif)"),
        "photoLongitude": MessageLookupByLibrary.simpleMessage(
            "ลองจิจูดของรูปภาพ (จาก exif)"),
        "photoPhotographer":
            MessageLookupByLibrary.simpleMessage("ชื่อช่างภาพ (จาก exif)"),
        "photoShutter":
            MessageLookupByLibrary.simpleMessage("ความเร็วชัตเตอร์ (จาก exif)"),
        "photoTime":
            MessageLookupByLibrary.simpleMessage("เวลาถ่ายภาพ (จาก exif)"),
        "prefix": MessageLookupByLibrary.simpleMessage("คำนำหน้า"),
        "rating": MessageLookupByLibrary.simpleMessage("การให้คะแนนแอป"),
        "ratingContent": MessageLookupByLibrary.simpleMessage(
            "ชอบแอปของเราหรือไม่? โปรดให้คะแนนดี ๆ ใน App Store หรือกดไลค์ใน GitHub เพื่อช่วยเราในการ成⻑ ความคิดเห็นของคุณมีความสำคัญอย่างยิ่งสำหรับเรา! ขอบคุณสำหรับการสนับสนุนของคุณ"),
        "ratingGithub": MessageLookupByLibrary.simpleMessage("กดไลค์บน GitHub"),
        "ratingStore": MessageLookupByLibrary.simpleMessage("ให้คะแนนใน Store"),
        "ratingTitle":
            MessageLookupByLibrary.simpleMessage("ให้คะแนนแอปของเรา"),
        "rearrange": MessageLookupByLibrary.simpleMessage("จัดเรียงใหม่"),
        "rearrangeDelimiter":
            MessageLookupByLibrary.simpleMessage("ตัวคั่นในการจัดเรียงใหม่"),
        "rearrangeOrderHint": MessageLookupByLibrary.simpleMessage(
            "โปรดป้อนตัวเลขที่เกี่ยวข้องโดยใช้เครื่องหมายจุลภาคในการแยก"),
        "rearrangeOrderLabel":
            MessageLookupByLibrary.simpleMessage("ลำดับการจัดเรียงใหม่"),
        "rearrangeToString": m2,
        "remove": MessageLookupByLibrary.simpleMessage("ลบ"),
        "removeAll": MessageLookupByLibrary.simpleMessage("ลบทั้งหมด"),
        "removeCharacters":
            MessageLookupByLibrary.simpleMessage("ลบอักขระที่อยู่ระหว่าง"),
        "removeRenamed":
            MessageLookupByLibrary.simpleMessage("ลบไฟล์ที่เปลี่ยนชื่อแล้ว"),
        "removeRule": MessageLookupByLibrary.simpleMessage("ลบกฏนี้"),
        "removeRules": MessageLookupByLibrary.simpleMessage(
            "ลบกฏทั้งหมดหลังจากเปลี่ยนชื่อ"),
        "removeToString": m3,
        "rename": MessageLookupByLibrary.simpleMessage("เปลี่ยนชื่อ"),
        "renameFailed":
            MessageLookupByLibrary.simpleMessage("เปลี่ยนชื่อล้มเหลว"),
        "replace": MessageLookupByLibrary.simpleMessage("แทนที่"),
        "replaceToString": m4,
        "replacement": MessageLookupByLibrary.simpleMessage("การแทนที่ด้วย"),
        "ru": MessageLookupByLibrary.simpleMessage("รัสเซีย"),
        "rulesSequentially": MessageLookupByLibrary.simpleMessage(
            "กฏถูกประมวลผลตามลำดับ กดค้างที่ปุ่ม \"=\" ทางด้านซ้ายและลากรายการเพื่อเรียงลำดับกฏ"),
        "save": MessageLookupByLibrary.simpleMessage("บันทึก"),
        "select": MessageLookupByLibrary.simpleMessage("เลือก"),
        "selectAll": MessageLookupByLibrary.simpleMessage("เลือกทั้งหมด"),
        "semanticSwitchNumberToStartAndToEnd": m5,
        "semanticsDropdownButton": m6,
        "semanticsFileManagerDirSubtitle": m7,
        "semanticsFileManagerSubtitle": m8,
        "semanticsFileManagerTitle": m9,
        "semanticsFilesDropdownButton": MessageLookupByLibrary.simpleMessage(
            "เลือกเพื่อจำกัดเป้าหมายการเปลี่ยนชื่อให้เฉพาะของส่วนนี้"),
        "semanticsMultipleActionsHint": MessageLookupByLibrary.simpleMessage(
            "เลื่อนขึ้นลงเพื่อเปลี่ยนการดำเนินการ"),
        "semanticsOpenMetadataDialog": MessageLookupByLibrary.simpleMessage(
            "คลิกสองครั้งเพื่อเปิดหน้าต่างและเลือกแท็กเมตาดาต้าที่จะแทรก"),
        "semanticsReorderableList": MessageLookupByLibrary.simpleMessage(
            "ลิสต์กฎว่างอยู่ คลิกปุ่ม \"เพิ่มกฎ\" เพื่อเพิ่ม กฎจะถูกปฏิบัติตามลำดับ ลิสต์นี้สามารถเรียงลำดับได้ใหม่ อนุญาตให้คุณย้ายกฎขึ้นหรือลง และเลื่อนมันไปที่ด้านบนหรือด้านล่าง เมื่อเอาเมาส์มาวางบนกฎ ใช้การเลื่อนแนวตั้งเพื่อสลับไปมาระหว่างการดำเนินการแต่ละอย่าง และใช้การคลิกสองครั้งเพื่อดำเนินการที่เลือก"),
        "semanticsRuleDropdownButton": MessageLookupByLibrary.simpleMessage(
            "เลือกแล้วคลิกปุ่ม \"เพิ่มกฎ\" เพื่อเพิ่มกฎ"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("โค้ดต้นฉบับ"),
        "sr": MessageLookupByLibrary.simpleMessage("เซอร์เบีย"),
        "startIndex": MessageLookupByLibrary.simpleMessage("ดัชนีเริ่มต้น"),
        "target": MessageLookupByLibrary.simpleMessage("เป้าหมาย"),
        "tj": MessageLookupByLibrary.simpleMessage("ทาจิกิสถาน"),
        "toLast": MessageLookupByLibrary.simpleMessage("สุดท้าย"),
        "transliterate": MessageLookupByLibrary.simpleMessage("การถอดอักษร"),
        "transliterateCyrillic2Latin": MessageLookupByLibrary.simpleMessage(
            "แปลงจากอักษรซีริลลิกเป็นอักษรละติน"),
        "transliterateLatin2Cyrillic": MessageLookupByLibrary.simpleMessage(
            "แปลงจากอักษรละตินเป็นอักษรซีริลลิก"),
        "transliterateLower":
            MessageLookupByLibrary.simpleMessage("แปลงเป็นอักษรละตินตัวเล็ก"),
        "transliteratePinyin":
            MessageLookupByLibrary.simpleMessage("แปลงอักษรจีนเป็นพินอิน"),
        "transliterateSimplified":
            MessageLookupByLibrary.simpleMessage("แปลงเป็นอักษรจีนตัวย่อ"),
        "transliterateToString": m10,
        "transliterateToStringCyrillic": m11,
        "transliterateTraditional":
            MessageLookupByLibrary.simpleMessage("แปลงเป็นอักษรจีนตัวดั้งเดิม"),
        "transliterateUpper":
            MessageLookupByLibrary.simpleMessage("แปลงเป็นอักษรละตินตัวใหญ่"),
        "truncate": MessageLookupByLibrary.simpleMessage("ตัด"),
        "truncateToString": m12,
        "ua": MessageLookupByLibrary.simpleMessage("ยูเครน")
      };
}
