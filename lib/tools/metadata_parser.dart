import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:exif/exif.dart';
import 'package:intl/intl.dart';
// import 'package:metadata_god/metadata_god.dart';
// import 'package:flutter_media_metadata/flutter_media_metadata.dart';

class MetadataParser {
  MetadataParser(this.file) {
    if (!file.existsSync()) {
      throw PathNotFoundException(file.path, const OSError());
    }
  }

  void init() async {
    _stat = await file.stat();
    // _metadata = await MetadataRetriever.fromFile(file);
    // MetadataGod.initialize();
    // _metadata = await MetadataGod.readMetadata(file: file.path);

    _bytes = await file.readAsBytes();
    _exif = await readExifFromBytes(_bytes);
  }

  final File file;
  late final FileStat _stat;
  // late final Metadata _metadata;
  late final Uint8List _bytes;
  late final Map<String, IfdTag> _exif;

  static final _key = utf8.encode('renamer');
  static final _date = DateFormat.yMMMMd();
  static final _time = DateFormat(DateFormat.HOUR24_MINUTE_SECOND);

  String get today => _date.format(DateTime.now().toLocal());
  String get now => _time.format(DateTime.now().toLocal());
  String get size => _formatFileSize(_stat.size);
  String get createDate => _date.format(_stat.changed.toLocal());
  String get createTime => _time.format(_stat.changed.toLocal());
  String get modifyDate => _date.format(_stat.modified.toLocal());
  String get modifyTime => _time.format(_stat.modified.toLocal());
  Future<String> get hash async => await _getMd5();

  //   flutter_media_metadata:
  //   String? get albumName => _metadata.albumName;
  //   String? get albumArtistName => _metadata.albumArtistName;
  //   int? get albumLength => _metadata.albumLength;
  //   int? get albumYear => _metadata.year;
  //
  //   int? get trackDuration => _metadata.trackDuration;
  //   String? get trackName => _metadata.trackName;
  //   String? get trackArtistNames => _metadata.trackArtistNames?.join(',');
  //   int? get trackNumber => _metadata.trackNumber;
  //
  //   String? get musicAuthor => _metadata.authorName;
  //   String? get musicWriter => _metadata.writerName;

  // metadata_god:
  // String get albumName => (_metadata.album ?? '').toString();
  // String get albumArtist => (_metadata.albumArtist ?? '').toString();
  // String get albumSize => (_metadata.discTotal ?? '').toString();
  // String get albumYear => (_metadata.year ?? '').toString();
  //
  // String get trackName => (_metadata.title ?? '').toString();
  // String get trackArtist => (_metadata.artist ?? '').toString();
  // String get trackNumber => (_metadata.trackNumber ?? '').toString();
  // String get trackTime {
  //   if (_metadata.duration == null) {
  //     return '';
  //   }
  //   final hr = (_metadata.duration!.inHours).toString().padLeft(2, '0');
  //   final min = (_metadata.duration!.inMinutes % 60).toString().padLeft(2, '0');
  //   final sec = (_metadata.duration!.inSeconds % 60).toString().padLeft(2, '0');
  //
  //   return '${hr}hrs-${min}mins-${sec}secs';
  // }

  String get photoDateTime => (_exif['EXIF DateTime'] ??
          _exif['EXIF DateTimeOriginal'] ??
          _exif['EXIF DateTimeDigitized'] ??
          '')
      .toString()
      .replaceAll(':', '-');
  String get cameraModel {
    final oem = (_exif['Image Make'] ?? '').toString();
    final model = (_exif['Image Model'] ?? '').toString();
    if (model.contains(oem)) {
      return model;
    } else {
      return '$oem $model';
    }
  }

  String get lensModel => (_exif['EXIF LensModel'] ?? '').toString();
  String get focalLength => _parseRatioTag(_exif['EXIF FocalLength']);
  String get aperture => 'f/${_parseRatioTag(_exif['EXIF FNumber'])}';
  String get shutterSpeed => (_exif['EXIF ExposureTime'] ?? '').toString();
  String get isoSpeed => (_exif['EXIF ISOSpeedRatings'] ?? '').toString();
  String get gpsLongitude => _getLatLng(_exif['GPS GPSLongitude'], _exif['GPS GPSLongitudeRef']);
  String get gpsLatitude => _getLatLng(_exif['GPS GPSLatitude'], _exif['GPS GPSLatitudeRef']);
  String get gpsAltitude => (_exif['GPS GPSAltitude'] ?? 0).toString();
  String get imageArtist => (_exif['Image Artist'] ?? '').toString();
  String get imageCopyright => (_exif['Image Copyright'] ?? '').toString();

  String _getLatLng(IfdTag? coordTag, IfdTag? refTag) {
    if (coordTag == null) {
      return '';
    }

    String ref = (refTag ?? '').toString();
    String coord = _parseGpsCoordinate(coordTag);
    return coord + ref;
  }

  String _parseGpsCoordinate(IfdTag tag) {
    if (tag.values is IfdRatios) {
      final List<Ratio> coordinate = (tag.values as IfdRatios).ratios;
      if (coordinate.isNotEmpty) {
        int degrees = _parseRatio(coordinate[0]).toInt();
        int minutes = coordinate.length > 1 ? _parseRatio(coordinate[1]).toInt() : 0;
        double seconds = coordinate.length > 2 ? _parseRatio(coordinate[2]) : 0.0;
        return '$degrees°$minutes′$seconds″';
      }
    }
    return '0°0′0″';
  }

  double _parseRatio(Ratio ratio) => ratio.numerator / ratio.denominator;

  String _parseRatioTag(IfdTag? tag) {
    if (tag != null && tag.values is IfdRatios) {
      final List<Ratio> ratios = (tag.values as IfdRatios).ratios;
      if (ratios.isNotEmpty) {
        return _parseRatio(ratios[0]).toString();
      }
    }
    return '';
  }

  Future<String> _getMd5() async {
    var hash = crypto.Hmac(crypto.md5, _key); // HMAC-SHA256
    var digest = hash.convert(_bytes);

    return digest.toString();
  }

  static const List<String> _sizeUnits = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB'];

  String _formatFileSize(int bytes) {
    if (bytes < 0) {
      throw ArgumentError('A file could never have a negative size.');
    }

    double size = bytes.toDouble();
    for (var unit in _sizeUnits) {
      if (size < 1024 || unit == _sizeUnits.last) {
        return size.toStringAsFixed(2) + unit;
      } else {
        size = size / 1024;
      }
    }

    return '';
  }
}
