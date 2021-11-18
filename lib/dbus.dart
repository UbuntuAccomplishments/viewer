import 'dart:core';
import 'package:dbus/dbus.dart';

import 'dbus_utils.dart';
import 'models/accomplishment.dart';

final dbusClient = DBusClient.session();
const interface = 'org.ubuntu.Accomplishments';
final path = DBusObjectPath('/org/ubuntu/Accomplishments');
late final object = DBusRemoteObject(dbusClient, name: interface, path: path);

Future<List<String>> fetchTrophies() async {
  final response = await object.callMethod(interface, 'list_trophies', [],
      replySignature: DBusSignature('as'));
  return decodeAS(response);
}

Future<List<String>> fetchOpportunities() async {
  final response = await object.callMethod(interface, 'list_opportunities', [],
      replySignature: DBusSignature('as'));
  return decodeAS(response);
}

Future<void> listenForTrophies(Function callback) async {
  final signals = DBusRemoteObjectSignalStream(
      object: object, interface: interface, name: 'trophy_received');
  await for (var signal in signals) {
    callback(signal.values.first.toNative());
  }
}

Future<void> listenForReload(Function callback) async {
  final signals = DBusRemoteObjectSignalStream(
      object: object,
      interface: interface,
      name: 'accoms_collections_reloaded');
  await for (var _ in signals) {
    callback();
  }
}

void runScripts() {
  object.callMethod(interface, 'run_scripts', []);
}

Future<Map<String, dynamic>> getTrophyData(String accomID) async {
  final response = await object.callMethod(
      interface, 'get_trophy_data', [DBusString(accomID)],
      replySignature: DBusSignature('a{sv}'));
  return decodeASV(response);
}

Future<Map<String, dynamic>> getAccomData(String accomID) async {
  final response = await object.callMethod(
      interface, 'get_accom_data', [DBusString(accomID)],
      replySignature: DBusSignature('a{sv}'));
  return decodeASV(response);
}

Future<String> getAccomIcon(String accomID) async {
  final response = await object.callMethod(
      interface, 'get_accom_icon', [DBusString(accomID)],
      replySignature: DBusSignature('s'));
  return decodeS(response);
}

Future<List<Accomplishment>> buildViewerDatabase() async {
  final response = await object.callMethod(
      interface, 'build_viewer_database', [],
      replySignature: DBusSignature('aa{sv}'));
  return decodeAASV(response)
      .map((item) => Accomplishment.fromJson(item))
      .toList();
}

Future<void> reloadAccomDatabase() async {
  await object.callMethod(interface, 'reload_accom_database', []);
}

Future<List<Map<String, dynamic>>> getAllExtraInformation() async {
  final response = await object.callMethod(
      interface, 'get_all_extra_information', [],
      replySignature: DBusSignature('aa{sv}'));
  return decodeAASV(response);
}

Future<String> getExtraInformation() async {
  final response = await object.callMethod(
      interface, 'get_extra_information', [],
      replySignature: DBusSignature('ss'));
  return decodeSS(response);
}

Future<void> setExtraInformation(String item, String? data) async {
  await object.callMethod(interface, 'write_extra_information_file',
      [DBusString(item), DBusString(data ?? "")]);
}
