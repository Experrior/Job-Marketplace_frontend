import 'package:flutter/cupertino.dart';

import 'package:macos_ui/macos_ui.dart';

class Themes {

  static final MacosThemeData macosLight = MacosThemeData.light().copyWith(
    primaryColor: CupertinoColors.systemBlue,
  );
  static final MacosThemeData macosDark = MacosThemeData.dark().copyWith(
    primaryColor: CupertinoColors.systemBlue,
  );
}
