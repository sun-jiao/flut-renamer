import 'package:flutter/material.dart';
import 'package:renamer/l10n/l10n.dart';

import '../widget/custom_dialog.dart';

void showMetadataDialog(BuildContext context, Function(String tag) onInsert) => showDialog(
      context: context,
      builder: (context) => MetadataDialog(
        onInsert: onInsert,
      ),
    );

class MetadataDialog extends StatelessWidget {
  const MetadataDialog({super.key, required this.onInsert});

  final Function(String tag) onInsert;

  static final List<MapEntry> _list = [
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
  ];

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
                    onPressed: () {
                      onInsert.call('{${e.key}}');
                      Navigator.pop(context);
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
