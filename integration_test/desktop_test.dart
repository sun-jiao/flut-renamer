import 'package:flutter_test/flutter_test.dart';

import 'app_test.dart' as app;
import 'platform_test.dart' as platform;

void main() {
  group('app workflow', app.main);
  group('native platform', platform.main);
}
