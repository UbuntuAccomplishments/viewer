import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'i18n_messages.dart';
import 'ua_state.dart';
import 'home_page.dart';
import 'settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return UAStateManager(
      child: YaruTheme(builder: (context, yaru, child) {
        return MaterialApp(
          title: getAppTitle(),
          theme: yaru.theme,
          darkTheme: yaru.darkTheme,
          home: MyHomePage(title: getAppTitle()),
          routes: <String, WidgetBuilder>{
            '/settings': (BuildContext context) =>
                SettingsPage(title: getSettingsTitle()),
          },
        );
      }),
    );
  }
}
