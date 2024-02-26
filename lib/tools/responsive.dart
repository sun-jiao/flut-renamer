import 'package:flutter/widgets.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 750;

  static bool isDesktop(BuildContext context) => !isMobile(context);

  @override
  Widget build(BuildContext context) {
    if (isDesktop(context)) {
      return desktop;
    } else {
      return mobile;
    }
  }
}
