import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

const _atFdcwd = -100;
const _renameNoReplace = 1;
const _renameExcl = 4;

typedef _RenameAt2Native = Int32 Function(
  Int32 oldDirectory,
  Pointer<Utf8> oldPath,
  Int32 newDirectory,
  Pointer<Utf8> newPath,
  Uint32 flags,
);
typedef _RenameAt2 = int Function(
  int oldDirectory,
  Pointer<Utf8> oldPath,
  int newDirectory,
  Pointer<Utf8> newPath,
  int flags,
);
typedef _RenameXNative = Int32 Function(
  Pointer<Utf8> oldPath,
  Pointer<Utf8> newPath,
  Uint32 flags,
);
typedef _RenameX = int Function(
  Pointer<Utf8> oldPath,
  Pointer<Utf8> newPath,
  int flags,
);
typedef _ErrnoLocationNative = Pointer<Int32> Function();
typedef _ErrnoLocation = Pointer<Int32> Function();

/// Atomically renames [entity] without replacing an existing destination on
/// POSIX platforms.
///
/// The ordinary `FileSystemEntity.rename` operation may replace [newPath] on
/// POSIX, leaving a time-of-check/time-of-use window after rename planning.
Future<FileSystemEntity> atomicRenameNoReplace(
  FileSystemEntity entity,
  String newPath,
) async {
  if (!Platform.isLinux &&
      !Platform.isAndroid &&
      !Platform.isMacOS &&
      !Platform.isIOS) {
    return entity.rename(newPath);
  }

  // APFS and the default iOS filesystem are case-insensitive.  A rename that
  // only changes casing therefore resolves [newPath] to [entity] itself, but
  // RENAME_EXCL rejects it as an existing destination.  It is safe to use the
  // platform rename after confirming both paths identify the same entity.
  if ((Platform.isMacOS || Platform.isIOS) &&
      await FileSystemEntity.identical(entity.path, newPath)) {
    return entity.rename(newPath);
  }

  final oldPathPointer = entity.path.toNativeUtf8();
  final newPathPointer = newPath.toNativeUtf8();
  try {
    final library = DynamicLibrary.process();
    late final int result;
    if (Platform.isLinux || Platform.isAndroid) {
      final renameAt2 =
          library.lookupFunction<_RenameAt2Native, _RenameAt2>('renameat2');
      result = renameAt2(
        _atFdcwd,
        oldPathPointer,
        _atFdcwd,
        newPathPointer,
        _renameNoReplace,
      );
    } else {
      final renameX =
          library.lookupFunction<_RenameXNative, _RenameX>('renamex_np');
      result = renameX(oldPathPointer, newPathPointer, _renameExcl);
    }

    if (result != 0) {
      final errno = _readErrno(library);
      throw FileSystemException(
        'Atomic rename without replacement failed',
        newPath,
        OSError('rename failed', errno),
      );
    }

    if (entity is Directory) return Directory(newPath);
    if (entity is Link) return Link(newPath);
    return File(newPath);
  } on ArgumentError catch (error) {
    // Never fall back to a potentially overwriting rename when the required
    // libc operation is unavailable.
    throw FileSystemException(
      'Atomic rename without replacement is unavailable: $error',
      newPath,
    );
  } finally {
    malloc.free(oldPathPointer);
    malloc.free(newPathPointer);
  }
}

int _readErrno(DynamicLibrary library) {
  final symbol =
      Platform.isLinux || Platform.isAndroid ? '__errno_location' : '__error';
  return library
      .lookupFunction<_ErrnoLocationNative, _ErrnoLocation>(symbol)()
      .value;
}
