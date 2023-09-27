import 'package:flutter/material.dart';

void showMetadataDialog(BuildContext context, Function(String tag) onInsert) =>
    showDialog(
      context: context,
      builder: (context) => MetadataDialog(
        onInsert: onInsert,
      ),
    );

class MetadataDialog extends StatelessWidget {
  const MetadataDialog({super.key, required this.onInsert});

  final Function(String tag) onInsert;

  static const List<MapEntry> _list = [
    MapEntry('OS:TodayDate', 'Date of today'),
    MapEntry('OS:NowTime', 'Time of now'),
    MapEntry('File:Size', 'Size of file'),
    MapEntry('File:CreateDate', 'Create date of file'),
    MapEntry('File:CreateTime', 'Create time of file'),
    MapEntry('File:ModifyDate', 'Modify date of file'),
    MapEntry('File:ModifyTime', 'Modify time of file'),
    MapEntry('Photo:Date', 'Photographing date from exif'),
    MapEntry('Photo:Time', 'Photographing time from exif'),
    MapEntry('Photo:CamName', 'Camera name from exif'),
    MapEntry('Photo:LensName', 'Lens name from exif'),
    MapEntry('Photo:FocalLength', 'Focal length from exif'),
    MapEntry('Photo:Aperture', 'Aperture value from exif'),
    MapEntry('Photo:Shutter', 'Shutter speed from exif'),
    MapEntry('Photo:ISO', 'ISO value from exif'),
    MapEntry('Photo:Longitude', 'Longitude of photo GPS from exif'),
    MapEntry('Photo:Latitude', 'Latitude of photo GPS from exif'),
    MapEntry('Photo:Altitude', 'Altitude of photo GPS from exif'),
    MapEntry('Photo:Photographer', 'Photographer name from exif'),
    MapEntry('Photo:Copyright', 'Copyright holder name from exif'),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Metadata tags'),
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
