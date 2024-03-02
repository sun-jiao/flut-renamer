import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:exif/exif.dart';
import 'package:intl/intl.dart';

import '../tools/ex_file.dart';

final metadataTagRegex = RegExp(r'\{([A-Za-z]+:[A-Za-z]+)\}');

class FileMetadata {
  FileMetadata(this.file) {
    if (!file.existsSync()) {
      throw PathNotFoundException(file.path, const OSError());
    }

    while (file is Link) {
      file = (file as Link).toFileSystemEntity();
    }
  }

  Future<void> init() async {
    if (!inited) {
      _stat = await file.stat();

      if (file is Directory) {
        _bytes = Uint8List(0);
        _exif = {};
        _metadata = AudioMetadata();
      } else {
        _bytes = await (file as File).readAsBytes();
        _exif = await readExifFromBytes(_bytes);
        _metadata = await readMetadata(file as File, getImage: false);
      }

      inited = true;
    }
  }

  late final FileSystemEntity file;
  late FileStat _stat;
  late Uint8List _bytes;
  late Map<String, IfdTag> _exif;
  late AudioMetadata _metadata;
  bool inited = false;

  static final _key = utf8.encode('renamer');
  static final _date = DateFormat('y-MM-d');
  static final _time = DateFormat('y-MM-d HH-mm-ss');

  String getByName(String name) {
    switch (name) {
      case 'OS:TodayDate':
        return _date.format(DateTime.now().toLocal());
      case 'OS:NowTime':
        return _time.format(DateTime.now().toLocal());
      case 'File:Size':
        return _formatFileSize(_stat.size);
      case 'File:CreateDate':
        return _date.format(_stat.changed.toLocal());
      case 'File:CreateTime':
        return _time.format(_stat.changed.toLocal());
      case 'File:ModifyDate':
        return _date.format(_stat.modified.toLocal());
      case 'File:ModifyTime':
        return _time.format(_stat.modified.toLocal());
      case 'Photo:Date':
        return (_exif['EXIF DateTime'] ??
                _exif['EXIF DateTimeOriginal'] ??
                _exif['EXIF DateTimeDigitized'] ??
                '')
            .toString()
            .split(' ')
            .first
            .replaceAll(':', '-');
      case 'Photo:Time':
        return (_exif['EXIF DateTime'] ??
                _exif['EXIF DateTimeOriginal'] ??
                _exif['EXIF DateTimeDigitized'] ??
                '')
            .toString()
            .replaceAll(':', '-');
      case 'Photo:CamName':
        final oem = (_exif['Image Make'] ?? '').toString();
        final model = (_exif['Image Model'] ?? '').toString();
        if (model.contains(oem)) {
          return model;
        } else {
          return '$oem $model';
        }
      case 'Photo:LensName':
        return (_exif['EXIF LensModel'] ?? '').toString();
      case 'Photo:FocalLength':
        return _parseRatioTag(_exif['EXIF FocalLength']);
      case 'Photo:Aperture':
        return 'f/${_parseRatioTag(_exif['EXIF FNumber'])}';
      case 'Photo:Shutter':
        return (_exif['EXIF ExposureTime'] ?? '').toString();
      case 'Photo:ISO':
        return (_exif['EXIF ISOSpeedRatings'] ?? '').toString();
      case 'Photo:Longitude':
        return _getLatLng(_exif['GPS GPSLongitude'], _exif['GPS GPSLongitudeRef']);
      case 'Photo:Latitude':
        return _getLatLng(_exif['GPS GPSLatitude'], _exif['GPS GPSLatitudeRef']);
      case 'Photo:Altitude':
        return (_exif['GPS GPSAltitude'] ?? 0).toString();
      case 'Photo:Photographer':
        return (_exif['Image Artist'] ?? '').toString();
      case 'Photo:Copyright':
        return (_exif['Image Copyright'] ?? '').toString();
      case 'Music:AlbumName':
        return (_metadata.album ?? '');
      // case 'Music:AlbumArtist':
      //   return (_metadata?.artist ?? '');
      // case 'Music:AlbumLength':
      //   return (_metadata. ?? '').toString();
      case 'Music:Year':
        return (_metadata.year?.year ?? '').toString();
      case 'Music:TrackDuration':
        return (_formatDuration(_metadata.duration) ?? '').toString();
      case 'Music:TrackName':
        return (_metadata.title ?? '').toString();
      // case 'Music:TrackArtist':
      //   return (_metadata.artist ?? '');
      case 'Music:TrackNumber':
        return (_metadata.trackNumber ?? '').toString();
      case 'Music:DiscNumber':
        return (_metadata.discNumber ?? '').toString();
      case 'Music:Genres':
        return _metadata.genres.join(',').toString();
      case 'Music:Author':
        return (_metadata.artist ?? '');
      // case 'Music:Writer':
      //   return (_metadata?.writerName ?? '');
      default:
        return '';
    }
  }

  String parse(String target) => target.replaceAllMapped(
        metadataTagRegex,
        (match) => getByName(match.group(1).toString()),
      );

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

  Future<String> get md5 async {
    var hash = crypto.Hmac(crypto.md5, _key); // HMAC-SHA256
    var digest = hash.convert(_bytes);

    return digest.toString();
  }

  static const List<String> _sizeUnits = [
    'Bytes',
    'KB',
    'MB',
    'GB',
    'TB',
    'PB',
  ];

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

    throw AssertionError('Unreachable');
  }

  String? _formatDuration(Duration? dur) {
    if (dur == null) {
      return null;
    }

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    int centiseconds = dur.inMilliseconds ~/ 10;
    int seconds = dur.inSeconds;
    int minutes = dur.inMinutes;
    int hours = dur.inHours;

    if (hours > 0){
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}.${twoDigits(centiseconds)}';
    } else if(minutes > 0){
      return '${twoDigits(minutes)}:${twoDigits(seconds)}.${twoDigits(centiseconds)}';
    } else if (seconds > 0){
      return '${twoDigits(seconds)}.${twoDigits(centiseconds)}sec';
    } else {
      return '${dur.inMilliseconds}ms';
    }
  }
}
