import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../tools/ex_file.dart';
import '../tools/platform_channel.dart';

/// Created only when previews are enabled, and only for visible list rows.
class FileThumbnail extends StatefulWidget {
  const FileThumbnail({super.key, required this.file});

  final FileEntity file;

  @override
  State<FileThumbnail> createState() => _FileThumbnailState();
}

class _FileThumbnailState extends State<FileThumbnail> {
  static const _imageExtensions = {
    '.jpg',
    '.jpeg',
    '.jfif',
    '.png',
    '.gif',
    '.webp',
    '.bmp',
    '.wbmp',
    '.heic',
    '.heif',
    '.avif',
    '.tif',
    '.tiff',
  };
  Future<Uint8List?>? _thumbnail;

  bool get _isDirectory => widget.file.entity is Directory;
  bool get _isContentUri => widget.file.path.startsWith('content://');

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  @override
  void didUpdateWidget(covariant FileThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.path != widget.file.path) _loadThumbnail();
  }

  void _loadThumbnail() {
    // SAF document IDs often have no extension. Android checks the MIME type.
    _thumbnail = !_isDirectory && _isContentUri
        ? PlatformFilePicker.getThumbnail(widget.file.path)
        : null;
  }

  Widget _placeholder([bool failed = false]) => Icon(
        _isDirectory
            ? Icons.folder_outlined
            : failed
                ? Icons.broken_image_outlined
                : Icons.insert_drive_file_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        size: 24,
      );

  Widget _image(ImageProvider provider) => Image(
        image: provider,
        width: 56,
        height: 56,
        fit: BoxFit.contain,
        excludeFromSemantics: true,
        errorBuilder: (_, error, stackTrace) => _placeholder(true),
      );

  @override
  Widget build(BuildContext context) {
    final Widget preview;
    if (_isDirectory) {
      preview = _placeholder();
    } else if (_isContentUri) {
      preview = FutureBuilder<Uint8List?>(
        future: _thumbnail,
        builder: (context, snapshot) {
          final bytes = snapshot.data;
          return bytes == null ? _placeholder() : _image(MemoryImage(bytes));
        },
      );
    } else if (_imageExtensions.contains(
      p.extension(widget.file.path).toLowerCase(),
    )) {
      preview = _image(
        ResizeImage(
          FileImage(File(widget.file.path)),
          width: 168,
          height: 168,
          policy: ResizeImagePolicy.fit,
        ),
      );
    } else {
      preview = _placeholder();
    }
    return ExcludeSemantics(
      child: SizedBox(width: 56, height: 56, child: preview),
    );
  }
}
