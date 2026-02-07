import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:audio_metadata_reader/src/metadata/base.dart';

extension UniversalMetadata on ParserTag {
  String? get trackArtist {
    return switch (this) {
      Mp3Metadata m => m.leadPerformer ?? m.originalArtist,
      Mp4Metadata m => m.artist,
      VorbisMetadata m => m.artist.firstOrNull,
      RiffMetadata m => m.artist,
      _ => null,
    };
  }

  String? get title {
    return switch (this) {
      Mp3Metadata m => m.songName,
      Mp4Metadata m => m.title,
      VorbisMetadata m => m.title.firstOrNull,
      RiffMetadata m => m.title,
      _ => null,
    };
  }

  String? get album {
    return switch (this) {
      Mp3Metadata m => m.album,
      Mp4Metadata m => m.album,
      VorbisMetadata m => m.album.firstOrNull,
      RiffMetadata m => m.album,
      _ => null,
    };
  }

  Duration? get duration {
    return switch (this) {
      Mp3Metadata m => m.duration,
      Mp4Metadata m => m.duration,
      VorbisMetadata m => m.duration,
      RiffMetadata m => m.duration,
      _ => null,
    };
  }

  DateTime? get year {
    return switch (this) {
      Mp3Metadata m => m.year != null ? DateTime(m.year!) : null,
      Mp4Metadata m => m.year,
      VorbisMetadata m => m.date.firstOrNull,
      RiffMetadata m => m.year,
      _ => null,
    };
  }

  int? get trackNumber {
    return switch (this) {
      Mp3Metadata m => m.trackNumber,
      Mp4Metadata m => m.trackNumber,
      VorbisMetadata m => m.trackNumber.firstOrNull,
      RiffMetadata m => m.trackNumber,
      _ => null,
    };
  }

  int? get discNumber {
    return switch (this) {
      Mp3Metadata m => m.discNumber,
      Mp4Metadata m => m.discNumber,
      VorbisMetadata m => m.discNumber,
      _ => null,
    };
  }

  List<String> get genres {
    return switch (this) {
      Mp3Metadata m => m.genres,
      Mp4Metadata m => m.genre != null ? [m.genre!] : [],
      VorbisMetadata m => m.genres,
      RiffMetadata m => m.genre != null ? [m.genre!] : [],
      _ => [],
    };
  }

  List<Picture> get pictures {
    return switch (this) {
      Mp3Metadata m => m.pictures,
      Mp4Metadata m => m.picture != null ? [m.picture!] : [],
      VorbisMetadata m => m.pictures,
      RiffMetadata m => m.pictures,
      _ => [],
    };
  }
}