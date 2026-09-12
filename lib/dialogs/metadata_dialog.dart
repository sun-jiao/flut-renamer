import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../widget/custom_dialog.dart';

void showMetadataDialog(
  BuildContext context,
  Function(String tag) onInsert,
) =>
    showDialog(
      context: context,
      builder: (context) => MetadataDialog(
        onInsert: onInsert,
      ),
    );

class MetadataDialog extends StatelessWidget {
  const MetadataDialog({
    super.key,
    required this.onInsert,
  });

  final Function(String tag) onInsert;

  static final List<MapEntry<String, String>> _list = [
    MapEntry('RandomString', L10n.current.insertRandomString),
    MapEntry('OS:TodayDate', L10n.current.osTodayDate),
    MapEntry('OS:NowTime', L10n.current.osNowTime),
    MapEntry('File:Size', L10n.current.fileSize),
    MapEntry('File:CreateDate', L10n.current.fileCreateDate),
    MapEntry('File:CreateTime', L10n.current.fileCreateTime),
    MapEntry('File:ModifyDate', L10n.current.fileModifyDate),
    MapEntry('File:ModifyTime', L10n.current.fileModifyTime),
    MapEntry('Photo:Date', L10n.current.photoDate),
    MapEntry('Photo:Time', L10n.current.photoTime),
    MapEntry('Photo:CamName', L10n.current.photoCamName),
    MapEntry('Photo:LensName', L10n.current.photoLensName),
    MapEntry('Photo:FocalLength', L10n.current.photoFocalLength),
    MapEntry('Photo:Aperture', L10n.current.photoAperture),
    MapEntry('Photo:Shutter', L10n.current.photoShutter),
    MapEntry('Photo:ISO', L10n.current.photoISO),
    MapEntry('Photo:Longitude', L10n.current.photoLongitude),
    MapEntry('Photo:Latitude', L10n.current.photoLatitude),
    MapEntry('Photo:Altitude', L10n.current.photoAltitude),
    MapEntry('Photo:Photographer', L10n.current.photoPhotographer),
    MapEntry('Photo:Copyright', L10n.current.photoCopyright),
    MapEntry('Music:AlbumName', L10n.current.musicAlbumName),
    // MapEntry('Music:AlbumArtist', L10n.current.musicAlbumArtist),
    // MapEntry('Music:AlbumLength', L10n.current.musicAlbumLength),
    MapEntry('Music:Year', L10n.current.musicYear),
    MapEntry('Music:TrackDuration', L10n.current.musicTrackDuration),
    MapEntry('Music:TrackName', L10n.current.musicTrackName),
    // MapEntry('Music:TrackArtist', L10n.current.musicTrackArtist),
    MapEntry('Music:TrackNumber', L10n.current.musicTrackNumber),
    MapEntry('Music:DiscNumber', L10n.current.musicDiscNumber),
    MapEntry('Music:Genres', L10n.current.musicGenres),
    MapEntry('Music:Author', L10n.current.musicAuthor),
    // MapEntry('Music:Writer', L10n.current.musicWriter),
  ];

  Future<int?> _selectRandomStringLength(BuildContext context) async {
    return showDialog<int>(
      context: context,
      builder: (_) => const _RandomStringLengthDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: Text(L10n.current.metadataTags),
      content: SingleChildScrollView(
        child: Column(
          children: _list
              .map(
                (e) => ListTile(
                  title: Text(e.key),
                  subtitle: Text(e.value),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      if (e.key == 'RandomString') {
                        final length = await _selectRandomStringLength(context);
                        if (length == null || !context.mounted) return;
                        onInsert.call('{RandomString:$length}');
                      } else {
                        onInsert.call('{${e.key}}');
                      }
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _RandomStringLengthDialog extends StatefulWidget {
  const _RandomStringLengthDialog();

  @override
  State<_RandomStringLengthDialog> createState() =>
      _RandomStringLengthDialogState();
}

class _RandomStringLengthDialogState extends State<_RandomStringLengthDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController(text: '8');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomDialog(
        title: Text(L10n.current.insertRandomString),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: L10n.current.randomStringLength,
              hintText: L10n.current.randomStringLengthHint,
            ),
            validator: (value) {
              final parsedLength = int.tryParse(value ?? '');
              return parsedLength == null ||
                      parsedLength < 1 ||
                      parsedLength > 32
                  ? L10n.current.randomStringLengthError
                  : null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(L10n.current.cancel),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context, int.parse(_controller.text));
              }
            },
            child: Text(L10n.current.add),
          ),
        ],
      );
}
