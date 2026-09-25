import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'platform_channel.dart';

typedef CreationTimeReader = Future<DateTime?> Function(
  String path,
  FileStat stat,
);

/// Returns birth time only. Unsupported filesystems/providers have no value;
/// POSIX ctime and modification time are not substitutes for creation time.
Future<DateTime?> readFileCreationTime(String path, FileStat stat) async {
  if (path.startsWith('content://') ||
      stat.type == FileSystemEntityType.notFound) {
    return null;
  }
  // Dart exposes creation time as `changed` only on Windows.
  if (Platform.isWindows) return stat.changed;
  if (Platform.isMacOS || Platform.isIOS) {
    return PlatformFilePicker.getCreationTime(path);
  }
  if (Platform.isLinux || Platform.isAndroid) {
    return Isolate.run(() => _linuxCreationTime(path));
  }
  return null;
}

typedef _StatxNative = Int32 Function(
  Int32,
  Pointer<Utf8>,
  Int32,
  Uint32,
  Pointer<Uint8>,
);
typedef _Statx = int Function(int, Pointer<Utf8>, int, int, Pointer<Uint8>);

DateTime? _linuxCreationTime(String path) {
  // The Linux statx ABI has a fixed 256-byte layout on all architectures.
  // stx_mask is at offset 0; stx_btime is at offset 80 (s64 seconds/u32 ns).
  const statxBirthTime = 0x800;
  const atFdcwd = -100;
  final buffer = calloc<Uint8>(256);
  final nativePath = path.toNativeUtf8();
  try {
    final statx =
        DynamicLibrary.process().lookupFunction<_StatxNative, _Statx>('statx');
    if (statx(atFdcwd, nativePath, 0, statxBirthTime, buffer) != 0) {
      return null;
    }
    final data = ByteData.sublistView(buffer.asTypedList(256));
    // A successful call does not imply that the filesystem supports btime.
    if ((data.getUint32(0, Endian.host) & statxBirthTime) == 0) return null;
    final seconds = data.getInt64(80, Endian.host);
    final nanoseconds = data.getUint32(88, Endian.host);
    if (nanoseconds >= 1000000000) return null;
    return DateTime.fromMicrosecondsSinceEpoch(
      seconds * Duration.microsecondsPerSecond + nanoseconds ~/ 1000,
      isUtc: true,
    );
  } on ArgumentError {
    // Older libc/kernel versions may not expose statx at all.
    return null;
  } finally {
    calloc.free(buffer);
    malloc.free(nativePath);
  }
}
