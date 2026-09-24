#include <windows.h>

// Return the error as an ordinary value before crossing the Dart FFI boundary.
// Last-error is thread-local and can be overwritten by the VM's transition.
extern "C" __declspec(dllexport) DWORD RenamerAtomicRenameNoReplace(
    const wchar_t* old_path, const wchar_t* new_path) {
  if (MoveFileExW(old_path, new_path, 0)) {
    return ERROR_SUCCESS;
  }
  return GetLastError();
}
