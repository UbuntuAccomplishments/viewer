import 'package:json_annotation/json_annotation.dart';

import '../utils.dart';

/// This allows the `Trophy` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'accomplishment.g.dart';

List<String> forceList(dynamic item) {
  if (item is String) {
    return item.split(',');
  }
  return List<String>.from(item);
}

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class Accomplishment {
  Accomplishment();

  @JsonKey(defaultValue: "")
  String id = "";
  @JsonKey(fromJson: truthy, defaultValue: false)
  bool accomplished = false;
  @JsonKey(defaultValue: "")
  String author = "";
  @JsonKey(defaultValue: "")
  String category = "";
  @JsonKey(fromJson: forceList, defaultValue: [])
  List<String> categories = [];
  @JsonKey(defaultValue: "")
  String collection = "";
  @JsonKey(defaultValue: "")
  String dateAccomplished = "";
  @JsonKey(defaultValue: "")
  String depends = "";
  @JsonKey(defaultValue: "")
  String description = "";
  @JsonKey(defaultValue: "")
  String help = "";
  @JsonKey(defaultValue: "")
  String icon = "";
  @JsonKey(defaultValue: "")
  String iconPath = "";
  @JsonKey(fromJson: forceList, defaultValue: [])
  List<String> keywords = [];
  @JsonKey(defaultValue: "")
  String links = "";
  @JsonKey(fromJson: truthy, defaultValue: false)
  bool locked = false;
  @JsonKey(defaultValue: "")
  String needsInformation = "";
  @JsonKey(fromJson: truthy, defaultValue: false)
  bool needsSigning = false;
  @JsonKey(defaultValue: "")
  String pitfalls = "";
  @JsonKey(defaultValue: "")
  String steps = "";
  @JsonKey(defaultValue: "")
  String summary = "";
  @JsonKey(defaultValue: "")
  String tips = "";
  @JsonKey(defaultValue: "")
  String title = "";
  @JsonKey(defaultValue: "")
  String basePath = "";
  @JsonKey(defaultValue: "")
  String lang = "";
  @JsonKey(defaultValue: "")
  String scriptPath = "";
  @JsonKey(defaultValue: "")
  String set = "";

  factory Accomplishment.fromJson(Map<String, dynamic> json) =>
      _$AccomplishmentFromJson(json);

  Map<String, dynamic> toJson() => _$AccomplishmentToJson(this);
}
