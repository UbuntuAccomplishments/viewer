import 'package:flutter/widgets.dart';

import 'dbus.dart';
import 'models/accomplishment.dart';

class UAStateManager extends StatefulWidget {
  static UAState? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UAState>();

  const UAStateManager({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _UAStateManagerState createState() => _UAStateManagerState();
}

class _UAStateManagerState extends State<UAStateManager> {
  late Future<List<Accomplishment>> database;

  @override
  void initState() {
    super.initState();
    database = buildViewerDatabase();
    listenForTrophies((_) => refreshViewerDatabase());
    listenForReload((_) => refreshViewerDatabase());
  }

  void refreshViewerDatabase() {
    onDatabaseChange(buildViewerDatabase());
  }

  void onDatabaseChange(Future<List<Accomplishment>> newValue) {
    setState(() {
      database = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UAState(
      child: widget.child,
      database: database,
      onDatabaseChange: onDatabaseChange,
    );
  }
}

class UAState extends InheritedWidget {
  final Future<List<Accomplishment>> database;
  final ValueChanged<Future<List<Accomplishment>>> onDatabaseChange;

  const UAState({
    Key? key,
    required Widget child,
    required this.database,
    required this.onDatabaseChange,
  }) : super(key: key, child: child);

  static UAState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UAState>();
  }

  @override
  bool updateShouldNotify(UAState oldWidget) {
    return oldWidget.database != database ||
        oldWidget.onDatabaseChange != onDatabaseChange;
  }
}
