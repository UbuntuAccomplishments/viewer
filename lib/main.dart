import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

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
      child: MaterialApp(
        title: 'Ubuntu Accomplishments',
        theme: yaruLight,
        darkTheme: yaruDark,
        home: const MyHomePage(title: 'Ubuntu Accomplishments'),
        routes: <String, WidgetBuilder>{
          '/settings': (BuildContext context) =>
              SettingsPage(title: 'Settings'),
        },
      ),
    );
  }
}
