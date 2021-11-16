import 'package:dbus/dbus.dart';

String decodeS(DBusMethodSuccessResponse response) {
  return response.returnValues[0].toNative();
}

String decodeSS(DBusMethodSuccessResponse response) {
  return response.returnValues[0].toNative();
}

List<String> decodeAS(DBusMethodSuccessResponse response) {
  return (response.returnValues[0] as DBusArray)
      .children
      .map<String>((c) => c.toNative())
      .toList();
}

Map<String, dynamic> decodeASV(DBusMethodSuccessResponse response) {
  return (response.returnValues[0] as DBusDict)
      .children
      .map((k, v) => MapEntry(k.toNative(), v.toNative()));
}

List<Map<String, dynamic>> decodeAASV(DBusMethodSuccessResponse response) {
  return ((response.returnValues[0] as DBusArray)
      .children
      .map<Map<String, dynamic>>((c) => (c as DBusDict)
          .children
          .map((k, v) => MapEntry(k.toNative(), v.toNative())))).toList();
}
