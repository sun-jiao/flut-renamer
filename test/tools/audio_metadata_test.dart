import 'package:audio_metadata_reader/audio_metadata_reader.dart';
// ignore: implementation_imports
import 'package:audio_metadata_reader/src/metadata/base.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/tools/audio_metadata.dart';

void main() {
  test('maps MP3 fields and prefers the lead performer', () {
    final metadata = Mp3Metadata()
      ..leadPerformer = 'Lead artist'
      ..originalArtist = 'Original artist'
      ..songName = 'Song'
      ..album = 'Album'
      ..duration = const Duration(minutes: 3)
      ..year = 2024
      ..trackNumber = 2
      ..discNumber = 1
      ..genres = ['Rock'];
    final ParserTag tag = metadata;

    expect(tag.trackArtist, 'Lead artist');
    expect(tag.title, 'Song');
    expect(tag.album, 'Album');
    expect(tag.duration, const Duration(minutes: 3));
    expect(tag.year, DateTime(2024));
    expect(tag.trackNumber, 2);
    expect(tag.discNumber, 1);
    expect(tag.genres, ['Rock']);
  });

  test('maps MP4 and RIFF scalar metadata into common fields', () {
    final mp4 = Mp4Metadata(
      title: 'MP4 song',
      artist: 'MP4 artist',
      album: 'MP4 album',
      year: DateTime(2020, 5, 1),
      trackNumber: 7,
      discNumber: 2,
      genre: 'Pop',
    );
    final riff = RiffMetadata(
      title: 'Wave song',
      artist: 'Wave artist',
      album: 'Wave album',
      year: DateTime(2019),
      trackNumber: 3,
      genre: 'Jazz',
    );

    final ParserTag mp4Tag = mp4;
    final ParserTag riffTag = riff;
    expect(mp4Tag.trackArtist, 'MP4 artist');
    expect(mp4Tag.genres, ['Pop']);
    expect(riffTag.title, 'Wave song');
    expect(riffTag.year, DateTime(2019));
    expect(riffTag.genres, ['Jazz']);
  });

  test('maps the first Vorbis value and handles empty optional lists', () {
    final metadata = VorbisMetadata()
      ..title = ['First title', 'Second title']
      ..artist = ['First artist']
      ..album = ['Album']
      ..date = [DateTime(2021)]
      ..trackNumber = [4]
      ..genres = ['Electronic'];
    final ParserTag tag = metadata;

    expect(tag.title, 'First title');
    expect(tag.trackArtist, 'First artist');
    expect(tag.year, DateTime(2021));
    expect(tag.trackNumber, 4);
    expect(tag.discNumber, isNull);
    expect(tag.pictures, isEmpty);
  });
}
