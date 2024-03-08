// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ko locale. All the
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
  String get localeName => 'ko';

  static String m0(prefix) => "접두사-인덱스로 증가합니다.";

  static String m1(toEnd, ordinal, insert, insertIndex) =>
      "${Intl.select(toEnd, {
            'true': '마지막부터',
            'false': '',
            'other': '',
          })} ${insertIndex}번째 문자 앞에 \"${insert}\"를 삽입합니다.";

  static String m2(delimiter, order) => "구분 기호: ${delimiter}, 순서: ${order}.";

  static String m3(targetString) => "\"${targetString}\"을(를) 제거합니다.";

  static String m4(targetString, replacementString) =>
      "대상 문자열을 \"${replacementString}\"(으)로 대체합니다.";

  static String m5(toEnd) => "시작과 끝 사이의 계산 방향 전환, 현재 ${Intl.select(toEnd, {
            'true': '끝',
            'false': '시작',
            'other': '',
          })}부터 계산 중";

  static String m6(value) =>
      "현재 선택된 값은 \"${value}\"입니다. 두 번 탭하여 드롭다운을 열고 다른 값을 선택하세요.";

  static String m7(last) => "마지막 수정 시간은 ${last}입니다.";

  static String m8(last, size) => "마지막 수정 시간은 ${last}이고 파일 크기는 ${size}입니다.";

  static String m9(entityType, selectStatus, filename) =>
      "${Intl.select(selectStatus, {
            'true': '선택한',
            'false': '선택하지 않은',
            'other': '',
          })}${Intl.select(entityType, {
            'File': '파일',
            'Directory': '디렉터리',
            'Link': '링크',
            'other': '파일 시스템 항목',
          })} 이름은 ${filename},";

  static String m10(type) => "음역: ${type}.";

  static String m11(langName, type) => "음역: ${langName} ${type}.";

  static String m12(iTwoToEnd, iOneOrdinal, iOneToEnd, iTwoOrdinal, keepType,
          iOne, iTwo) =>
      "${Intl.select(keepType, {
            'true': '처음부터',
            'false': '제거',
            'other': '',
          })} ${Intl.select(iOneToEnd, {
            'true': '마지막부터',
            'false': '',
            'other': '',
          })} ${iOne}번째 문자부터 ${Intl.select(iTwoToEnd, {
            'true': '마지막부터',
            'false': '',
            'other': '',
          })} ${iTwo}번째 문자까지의 내용을 줄입니다.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutContent": MessageLookupByLibrary.simpleMessage(
            "이 애플리케이션은 사용자가 파일 이름을 변경하는 데 도움을 주기 위해 개발되었습니다. Flutter 프레임워크를 사용하여 개발되었으며 다른 운영 체제에도 적용됩니다. 이 애플리케이션은 완전히 오픈 소스이며 검토하고 기여할 수 있습니다."),
        "add": MessageLookupByLibrary.simpleMessage("추가"),
        "addFile": MessageLookupByLibrary.simpleMessage("파일 추가"),
        "addFiles": MessageLookupByLibrary.simpleMessage("파일을 추가하세요."),
        "addRule": MessageLookupByLibrary.simpleMessage("규칙 추가"),
        "androidRemindContent": MessageLookupByLibrary.simpleMessage(
            "Flut Renamer를 사용하면 파일뿐만 아니라 디렉토리 이름도 바꿀 수 있습니다. 디렉토리를 길게 눌러 선택한 다음 왼쪽 상단의 드롭다운 버튼에서 \'파일 및 디렉토리\'를 선택하여 디렉토리 이름을 바꿀 수 있습니다. 보안상의 이유로 일부 시스템 예약 디렉토리는 선택할 수 없습니다."),
        "androidRemindTitle":
            MessageLookupByLibrary.simpleMessage("디렉터리 이름 변경"),
        "appError": MessageLookupByLibrary.simpleMessage("애플리케이션 오류"),
        "appInfo": MessageLookupByLibrary.simpleMessage("애플리케이션 정보"),
        "appName": MessageLookupByLibrary.simpleMessage("Flut Renamer"),
        "bg": MessageLookupByLibrary.simpleMessage("불가리아어"),
        "cancel": MessageLookupByLibrary.simpleMessage("취소"),
        "cancelAll": MessageLookupByLibrary.simpleMessage("모두 취소"),
        "caseSensitive": MessageLookupByLibrary.simpleMessage("대소문자 구분"),
        "collapseOptions": MessageLookupByLibrary.simpleMessage("옵션 축소"),
        "currentName": MessageLookupByLibrary.simpleMessage("현재 파일 이름"),
        "descriptionIncrement": MessageLookupByLibrary.simpleMessage(
            "파일 이름을 증가시킵니다. 예: 사진-1, 사진-2, 사진-3."),
        "descriptionInsert": MessageLookupByLibrary.simpleMessage(
            "지정된 위치에 제공된 텍스트(또는 파일 메타데이터 및 EXIF 데이터)를 삽입합니다."),
        "descriptionRearrange": MessageLookupByLibrary.simpleMessage(
            "파일 이름을 사용자가 지정한 구분 기호로 분할하고 제공된 순서에 따라 다시 정렬합니다."),
        "descriptionRemove": MessageLookupByLibrary.simpleMessage(
            "지정된 텍스트(또는 제공된 정규식과 일치하는 텍스트)를 파일 이름에서 제거합니다."),
        "descriptionReplace": MessageLookupByLibrary.simpleMessage(
            "지정된 텍스트(또는 제공된 정규식과 일치하는 텍스트)를 제공된 대체 텍스트(또는 파일 메타데이터 및 EXIF 데이터)로 바꿉니다."),
        "descriptionTransliterate": MessageLookupByLibrary.simpleMessage(
            "미리 정의된 명세에 따라 문자를 변환합니다. 대문자 또는 소문자로 변환, 다른 문자 변형으로의 변환 또는 다른 문자 체계로의 변환을 포함합니다."),
        "descriptionTruncate": MessageLookupByLibrary.simpleMessage(
            "파일 이름의 지정된 부분을 제거하거나 유지합니다. 시작 위치에서 끝 위치까지입니다."),
        "directories": MessageLookupByLibrary.simpleMessage("디렉터리"),
        "doNotRemindAgain": MessageLookupByLibrary.simpleMessage("다시 알림하지 않음"),
        "dragToAdd":
            MessageLookupByLibrary.simpleMessage("추가하려면 파일을 여기로 끌어다 놓으세요."),
        "dropToAdd": MessageLookupByLibrary.simpleMessage("파일을 여기에 놓아 추가하세요."),
        "errorDetails": MessageLookupByLibrary.simpleMessage("오류 세부 정보"),
        "exit": MessageLookupByLibrary.simpleMessage("나가기"),
        "exitContent": MessageLookupByLibrary.simpleMessage(
            "외부 저장소를 관리하는 권한을 부여하면 장치에 저장된 파일에 액세스하고 이름을 변경할 수 있습니다. 이 권한이 없으면 애플리케이션은 파일의 전체 경로에 액세스할 수 없으므로 이름을 변경할 수 없습니다. 권한을 수동으로 부여하려면 설정 페이지로 이동하십시오. 그렇지 않으면 우리는 어떤 서비스도 제공할 수 없습니다."),
        "exitTitle": MessageLookupByLibrary.simpleMessage("외부 저장소에 액세스할 수 없음"),
        "expandOptions": MessageLookupByLibrary.simpleMessage("옵션 확장"),
        "fileAlreadyExists":
            MessageLookupByLibrary.simpleMessage("파일 이름이 이미 사용 중입니다"),
        "fileCreateDate": MessageLookupByLibrary.simpleMessage("파일 생성 날짜"),
        "fileCreateTime": MessageLookupByLibrary.simpleMessage("파일 생성 시간"),
        "fileManagerBackButton": MessageLookupByLibrary.simpleMessage("뒤로"),
        "fileManagerSaveButton":
            MessageLookupByLibrary.simpleMessage("선택한 파일을 목록에 추가"),
        "fileManagerSortButton": MessageLookupByLibrary.simpleMessage("파일 정렬"),
        "fileManagerStorageButton":
            MessageLookupByLibrary.simpleMessage("저장소 선택"),
        "fileModifyDate": MessageLookupByLibrary.simpleMessage("파일 수정 날짜"),
        "fileModifyTime": MessageLookupByLibrary.simpleMessage("파일 수정 시간"),
        "fileSize": MessageLookupByLibrary.simpleMessage("파일 크기"),
        "fileSortDate": MessageLookupByLibrary.simpleMessage("날짜"),
        "fileSortName": MessageLookupByLibrary.simpleMessage("이름"),
        "fileSortSize": MessageLookupByLibrary.simpleMessage("크기"),
        "fileSortType": MessageLookupByLibrary.simpleMessage("유형"),
        "files": MessageLookupByLibrary.simpleMessage("파일"),
        "filesDirs": MessageLookupByLibrary.simpleMessage("파일 및 디렉터리"),
        "filter": MessageLookupByLibrary.simpleMessage("필터"),
        "fromStart": MessageLookupByLibrary.simpleMessage("처음부터 계산"),
        "goingForward": MessageLookupByLibrary.simpleMessage("앞으로"),
        "ifFileNotShown": MessageLookupByLibrary.simpleMessage(
            "파일 목록에 파일이 표시되지 않으면 모든 내용을 지우고 계속 진행하십시오."),
        "ignoreExtension": MessageLookupByLibrary.simpleMessage("확장자 무시"),
        "increment": MessageLookupByLibrary.simpleMessage("증가"),
        "incrementToString": m0,
        "indexIncrementalStep":
            MessageLookupByLibrary.simpleMessage("인덱스 증가 단계"),
        "indexOne": MessageLookupByLibrary.simpleMessage("첫 번째 위치"),
        "indexTwo": MessageLookupByLibrary.simpleMessage("두 번째 위치"),
        "insert": MessageLookupByLibrary.simpleMessage("삽입"),
        "insertBeforeIndex":
            MessageLookupByLibrary.simpleMessage("삽입 위치 전에 삽입"),
        "insertIndex": MessageLookupByLibrary.simpleMessage("삽입 위치"),
        "insertTagInsideAnother":
            MessageLookupByLibrary.simpleMessage("태그 내에 다른 태그를 삽입하지 마십시오."),
        "insertToString": m1,
        "insertedText": MessageLookupByLibrary.simpleMessage("삽입할 텍스트"),
        "iosRemindContent": MessageLookupByLibrary.simpleMessage(
            "iOS에서 파일을 선택하려면 먼저 파일이 포함된 폴더를 선택하세요. 그런 다음 선택한 폴더에서 이름을 바꿀 파일을 선택하세요. iOS의 제한으로 인해 이 두 단계를 수행해야 합니다. 이렇게 하면 안전한 파일 액세스가 보장됩니다. 시작해 봅시다!"),
        "iosRemindTitle":
            MessageLookupByLibrary.simpleMessage("iOS에서 파일 선택에 대해"),
        "isRegex": MessageLookupByLibrary.simpleMessage("정규 표현식 사용"),
        "keepCharacters":
            MessageLookupByLibrary.simpleMessage("두 문자 사이의 문자 유지"),
        "language": MessageLookupByLibrary.simpleMessage("언어:"),
        "limit": MessageLookupByLibrary.simpleMessage("제한"),
        "lowercaseAppName":
            MessageLookupByLibrary.simpleMessage("flut renamer"),
        "me": MessageLookupByLibrary.simpleMessage("몬테네그로어"),
        "metadataParserNotProvided": MessageLookupByLibrary.simpleMessage(
            "메타데이터 태그가 포함되어 있지만 메타데이터 파서가 제공되지 않았습니다."),
        "metadataTags": MessageLookupByLibrary.simpleMessage("메타 데이터 태그"),
        "mk": MessageLookupByLibrary.simpleMessage("마케도니아어"),
        "mn": MessageLookupByLibrary.simpleMessage("몽골어"),
        "musicAlbumArtist": MessageLookupByLibrary.simpleMessage("앨범 아티스트 이름"),
        "musicAlbumLength": MessageLookupByLibrary.simpleMessage("앨범 내 곡 수"),
        "musicAlbumName": MessageLookupByLibrary.simpleMessage("앨범 이름"),
        "musicAuthor": MessageLookupByLibrary.simpleMessage("곡 작곡가"),
        "musicDiscNumber": MessageLookupByLibrary.simpleMessage("디스크 순서"),
        "musicGenres": MessageLookupByLibrary.simpleMessage("곡 장르"),
        "musicTrackArtist": MessageLookupByLibrary.simpleMessage("곡 아티스트 이름"),
        "musicTrackDuration": MessageLookupByLibrary.simpleMessage("곡 재생 시간"),
        "musicTrackName": MessageLookupByLibrary.simpleMessage("곡 이름"),
        "musicTrackNumber": MessageLookupByLibrary.simpleMessage("앨범 내 곡 순서"),
        "musicWriter": MessageLookupByLibrary.simpleMessage("곡 작사가"),
        "musicYear": MessageLookupByLibrary.simpleMessage("곡 출시 연도"),
        "newName": MessageLookupByLibrary.simpleMessage("새 파일 이름"),
        "noSysDir":
            MessageLookupByLibrary.simpleMessage("시스템 예약 디렉터리를 이름을 변경하지 마십시오."),
        "ok": MessageLookupByLibrary.simpleMessage("확인"),
        "omitDash": MessageLookupByLibrary.simpleMessage("대시 생략"),
        "onlySelected": MessageLookupByLibrary.simpleMessage("선택한 파일만 이름 변경"),
        "osNowTime": MessageLookupByLibrary.simpleMessage("현재 시간"),
        "osTodayDate": MessageLookupByLibrary.simpleMessage("현재 날짜"),
        "permissionContent": MessageLookupByLibrary.simpleMessage(
            "파일 이름을 변경하기 위해 외부 저장소를 관리할 권한이 필요합니다. 따라서 우리는 귀하가 장치에 저장된 파일에 액세스하고 이름을 변경할 수 있도록 권한을 부여해야 합니다. 이 권한이 없으면 애플리케이션은 파일의 전체 경로에 액세스할 수 없으므로 이름을 변경할 수 없습니다. 우리는 귀하의 개인 정보와 안전을 매우 중요하게 생각하며 이름 변경 목적으로만 파일에 액세스할 것임을 보증합니다."),
        "permissionTitle": MessageLookupByLibrary.simpleMessage("외부 저장소 권한"),
        "photoAltitude":
            MessageLookupByLibrary.simpleMessage("사진 GPS 고도 (EXIF에서 가져옴)"),
        "photoAperture":
            MessageLookupByLibrary.simpleMessage("조리개 값 (EXIF에서 가져옴)"),
        "photoCamName":
            MessageLookupByLibrary.simpleMessage("카메라 이름 (EXIF에서 가져옴)"),
        "photoCopyright":
            MessageLookupByLibrary.simpleMessage("저작권 소유자 이름 (EXIF에서 가져옴)"),
        "photoDate":
            MessageLookupByLibrary.simpleMessage("사진 촬영 날짜 (EXIF에서 가져옴)"),
        "photoFocalLength":
            MessageLookupByLibrary.simpleMessage("초점 거리 (EXIF에서 가져옴)"),
        "photoISO": MessageLookupByLibrary.simpleMessage("ISO 값 (EXIF에서 가져옴)"),
        "photoLatitude":
            MessageLookupByLibrary.simpleMessage("사진 GPS 위도 (EXIF에서 가져옴)"),
        "photoLensName":
            MessageLookupByLibrary.simpleMessage("렌즈 이름 (EXIF에서 가져옴)"),
        "photoLongitude":
            MessageLookupByLibrary.simpleMessage("사진 GPS 경도 (EXIF에서 가져옴)"),
        "photoPhotographer":
            MessageLookupByLibrary.simpleMessage("사진작가 이름 (EXIF에서 가져옴)"),
        "photoShutter":
            MessageLookupByLibrary.simpleMessage("셔터 속도 (EXIF에서 가져옴)"),
        "photoTime":
            MessageLookupByLibrary.simpleMessage("사진 촬영 시간 (EXIF에서 가져옴)"),
        "prefix": MessageLookupByLibrary.simpleMessage("접두사"),
        "rating": MessageLookupByLibrary.simpleMessage("애플리케이션 평가"),
        "ratingContent": MessageLookupByLibrary.simpleMessage(
            "우리 애플리케이션을 좋아하시나요? 앱 스토어에서 평가를 하거나 GitHub에서 스타를 눌러 성장하는 데 도움을 주세요. 여러분의 피드백은 우리에게 매우 중요합니다! 지원해 주셔서 감사합니다."),
        "ratingGithub":
            MessageLookupByLibrary.simpleMessage("GitHub 저장소에 스타 누르기"),
        "ratingStore": MessageLookupByLibrary.simpleMessage("스토어에서 평가하기"),
        "ratingTitle": MessageLookupByLibrary.simpleMessage("우리 애플리케이션 평가하기"),
        "rearrange": MessageLookupByLibrary.simpleMessage("재정렬"),
        "rearrangeDelimiter": MessageLookupByLibrary.simpleMessage("구분 기호"),
        "rearrangeOrderHint":
            MessageLookupByLibrary.simpleMessage("숫자를 입력하고 쉼표로 구분하여 순서를 지정하세요"),
        "rearrangeOrderLabel": MessageLookupByLibrary.simpleMessage("재정렬 순서"),
        "rearrangeToString": m2,
        "remove": MessageLookupByLibrary.simpleMessage("제거"),
        "removeAll": MessageLookupByLibrary.simpleMessage("모두 제거"),
        "removeCharacters":
            MessageLookupByLibrary.simpleMessage("두 문자 사이의 문자 제거"),
        "removeRenamed": MessageLookupByLibrary.simpleMessage("이름이 변경된 파일 제거"),
        "removeRule": MessageLookupByLibrary.simpleMessage("이 규칙 제거"),
        "removeRules": MessageLookupByLibrary.simpleMessage("이름 변경 후 모든 규칙 제거"),
        "removeToString": m3,
        "rename": MessageLookupByLibrary.simpleMessage("이름 변경"),
        "renameFailed": MessageLookupByLibrary.simpleMessage("이름 변경 실패"),
        "replace": MessageLookupByLibrary.simpleMessage("교체"),
        "replaceToString": m4,
        "replacement": MessageLookupByLibrary.simpleMessage("대체할 문자"),
        "ru": MessageLookupByLibrary.simpleMessage("러시아어"),
        "rulesSequentially": MessageLookupByLibrary.simpleMessage(
            "규칙은 순차적으로 실행되며 왼쪽의 \'=\' 버튼을 누른 채로 드래그하여 규칙을 정렬할 수 있습니다."),
        "save": MessageLookupByLibrary.simpleMessage("저장"),
        "select": MessageLookupByLibrary.simpleMessage("선택"),
        "selectAll": MessageLookupByLibrary.simpleMessage("모두 선택"),
        "semanticSwitchNumberToStartAndToEnd": m5,
        "semanticsDropdownButton": m6,
        "semanticsFileManagerDirSubtitle": m7,
        "semanticsFileManagerSubtitle": m8,
        "semanticsFileManagerTitle": m9,
        "semanticsFilesDropdownButton": MessageLookupByLibrary.simpleMessage(
            "이 옵션을 선택하여 이름 변경 대상을 해당 범위로 제한합니다."),
        "semanticsMultipleActionsHint": MessageLookupByLibrary.simpleMessage(
            ", 위 아래로 스와이프하여 다른 작업으로 전환할 수 있습니다."),
        "semanticsOpenMetadataDialog": MessageLookupByLibrary.simpleMessage(
            "더블 클릭하여 대화 상자를 열고 삽입할 메타 데이터 태그를 선택하세요."),
        "semanticsReorderableList": MessageLookupByLibrary.simpleMessage(
            "규칙 목록이 비어 있습니다. \"규칙 추가\" 버튼을 클릭하여 추가하세요. 규칙은 순서대로 실행되며이 목록을 재정렬하여 규칙을 위로 끌어 올리거나 아래로 이동하거나 맨 위 또는 맨 아래로 이동할 수 있습니다. 규칙 위에 커서가 있으면 수직 스와이프 제스처를 사용하여 다른 작업으로 전환하고 두 번 탭하여 선택한 작업을 수행하세요."),
        "semanticsRuleDropdownButton": MessageLookupByLibrary.simpleMessage(
            "이 옵션을 선택하고 \"규칙 추가\" 버튼을 클릭하여이 규칙을 추가할 수 있습니다."),
        "sourceCode": MessageLookupByLibrary.simpleMessage("소스 코드"),
        "sr": MessageLookupByLibrary.simpleMessage("세르비아어"),
        "startIndex": MessageLookupByLibrary.simpleMessage("시작 인덱스"),
        "target": MessageLookupByLibrary.simpleMessage("대상"),
        "tj": MessageLookupByLibrary.simpleMessage("타지크어"),
        "toLast": MessageLookupByLibrary.simpleMessage("마지막까지"),
        "transliterate": MessageLookupByLibrary.simpleMessage("음역"),
        "transliterateCyrillic2Latin":
            MessageLookupByLibrary.simpleMessage("키릴 문자를 라틴 문자로 변환"),
        "transliterateLatin2Cyrillic":
            MessageLookupByLibrary.simpleMessage("라틴 문자를 키릴 문자로 변환"),
        "transliterateLower":
            MessageLookupByLibrary.simpleMessage("소문자 라틴 문자로 변환"),
        "transliteratePinyin": MessageLookupByLibrary.simpleMessage("한국어로 번역"),
        "transliterateSimplified":
            MessageLookupByLibrary.simpleMessage("간체 중국어로 변환"),
        "transliterateToString": m10,
        "transliterateToStringCyrillic": m11,
        "transliterateTraditional":
            MessageLookupByLibrary.simpleMessage("번체 중국어로 변환"),
        "transliterateUpper":
            MessageLookupByLibrary.simpleMessage("대문자 라틴 문자로 변환"),
        "truncate": MessageLookupByLibrary.simpleMessage("줄이기"),
        "truncateToString": m12,
        "ua": MessageLookupByLibrary.simpleMessage("우크라이나어")
      };
}
