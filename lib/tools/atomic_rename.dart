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
typedef _SyscallNative = IntPtr Function(
  IntPtr number,
  IntPtr oldDirectory,
  Pointer<Utf8> oldPath,
  IntPtr newDirectory,
  Pointer<Utf8> newPath,
  IntPtr flags,
);
typedef _Syscall = int Function(
  int number,
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
typedef _MoveFileExWNative = Int32 Function(
  Pointer<Utf16> oldPath,
  Pointer<Utf16> newPath,
  Uint32 flags,
);
typedef _MoveFileExW = int Function(
  Pointer<Utf16> oldPath,
  Pointer<Utf16> newPath,
  int flags,
);
typedef _GetLastErrorNative = Uint32 Function();
typedef _GetLastError = int Function();

/// Atomically renames [entity] without replacing an existing destination on
/// supported platforms.
///
/// The ordinary `FileSystemEntity.rename` operation may replace [newPath],
/// leaving a time-of-check/time-of-use window after rename planning.
Future<FileSystemEntity> atomicRenameNoReplace(
  FileSystemEntity entity,
  String newPath,
) async {
  if (Platform.isWindows) {
    return _moveFileExNoReplace(entity, newPath);
  }

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
  // `FileSystemEntity.identical` throws if either path does not exist. Most
  // renames create a new destination, so only compare identities after
  // establishing that the destination is present.
  if ((Platform.isMacOS || Platform.isIOS) &&
      await FileSystemEntity.type(newPath, followLinks: false) !=
          FileSystemEntityType.notFound &&
      await FileSystemEntity.identical(entity.path, newPath)) {
    return entity.rename(newPath);
  }

  final oldPathPointer = entity.path.toNativeUtf8();
  final newPathPointer = newPath.toNativeUtf8();
  try {
    final library = DynamicLibrary.process();
    late final int result;
    if (Platform.isLinux || Platform.isAndroid) {
      result = _renameAt2(
        library,
        oldPathPointer,
        newPathPointer,
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

/// Invokes `renameat2` directly when the libc wrapper is not exported.
///
/// Android's bionic did not export `renameat2` until API 30, and older glibc
/// versions have the same limitation. The syscall itself is available on the
/// kernels supported by those platforms, so using `syscall` preserves the
/// atomic no-replace guarantee instead of falling back to `rename`.
int _renameAt2(
  DynamicLibrary library,
  Pointer<Utf8> oldPath,
  Pointer<Utf8> newPath,
) {
  try {
    final renameAt2 =
        library.lookupFunction<_RenameAt2Native, _RenameAt2>('renameat2');
    return renameAt2(
      _atFdcwd,
      oldPath,
      _atFdcwd,
      newPath,
      _renameNoReplace,
    );
  } on ArgumentError {
    final syscall = library.lookupFunction<_SyscallNative, _Syscall>('syscall');
    return syscall(
      _renameAt2SystemCallNumber(Abi.current()),
      _atFdcwd,
      oldPath,
      _atFdcwd,
      newPath,
      _renameNoReplace,
    );
  }
}

int _renameAt2SystemCallNumber(Abi abi) {
  switch (abi) {
    case Abi.androidArm:
    case Abi.linuxArm:
      return 382;
    case Abi.androidArm64:
    case Abi.androidRiscv64:
    case Abi.linuxArm64:
    case Abi.linuxRiscv32:
    case Abi.linuxRiscv64:
      return 276;
    case Abi.androidIA32:
    case Abi.linuxIA32:
      return 353;
    case Abi.androidX64:
    case Abi.linuxX64:
      return 316;
    default:
      throw UnsupportedError('renameat2 syscall is unavailable for $abi');
  }
}

/// `MoveFileExW` without `MOVEFILE_REPLACE_EXISTING` has the kernel perform
/// the destination-existence check as part of the move.  In contrast,
/// `FileSystemEntity.rename` may replace an existing target on Windows.
Future<FileSystemEntity> _moveFileExNoReplace(
  FileSystemEntity entity,
  String newPath,
) async {
  final oldPathPointer = entity.path.toNativeUtf16();
  final newPathPointer = newPath.toNativeUtf16();
  try {
    final library = DynamicLibrary.open('kernel32.dll');
    final moveFileEx =
        library.lookupFunction<_MoveFileExWNative, _MoveFileExW>('MoveFileExW');
    if (moveFileEx(oldPathPointer, newPathPointer, 0) == 0) {
      final error = library
          .lookupFunction<_GetLastErrorNative, _GetLastError>('GetLastError')();
      throw FileSystemException(
        'Atomic rename without replacement failed',
        newPath,
        OSError('MoveFileExW failed', error),
      );
    }

    if (entity is Directory) return Directory(newPath);
    if (entity is Link) return Link(newPath);
    return File(newPath);
  } on ArgumentError catch (error) {
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
