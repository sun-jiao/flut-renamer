import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Mobile processes do not inherit host environment variables. The explicit
/// build flag is only passed by jobs on disposable hosted runners/simulators.
Future<void> requireTestEnvironment() async {
  if (const bool.fromEnvironment('RENAMER_CI_TESTS')) {
    if (!Platform.isAndroid &&
        !Platform.isIOS &&
        Platform.environment['GITHUB_ACTIONS'] != 'true') {
      throw StateError('CI tests require a disposable GitHub-hosted runner.');
    }
    return;
  }
  final sandbox = Platform.environment['RENAMER_INTEGRATION_SANDBOX'];
  if (!Platform.isLinux || sandbox == null) {
    throw StateError('Use the isolated Linux runner or disposable CI jobs.');
  }
  for (final directory in [
    await getTemporaryDirectory(),
    await getApplicationCacheDirectory(),
    await getApplicationSupportDirectory(),
  ]) {
    expect(p.isWithin(sandbox, directory.path), isTrue,
        reason: 'Native storage must stay in the disposable test sandbox.',);
  }
}
