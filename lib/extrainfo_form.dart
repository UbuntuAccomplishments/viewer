import 'package:flutter/material.dart';

import 'dbus.dart';
import 'i18n_messages.dart';
import 'utils.dart';

class ExtraInfoForm extends StatefulWidget {
  const ExtraInfoForm({Key? key, this.onSaved}) : super(key: key);

  final Function? onSaved;

  @override
  ExtraInfoFormState createState() => ExtraInfoFormState();
}

class ExtraInfoFormState extends State<ExtraInfoForm> {
  late Future<List<Map<String, dynamic>>> extraInfo;

  @override
  void initState() {
    super.initState();
    extraInfo = getAllExtraInformation();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: extraInfo,
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          Map<String, List<Map<String, dynamic>>> data = {};
          for (var collection
              in snapshot.data!.map<String>((d) => d['collection']).toSet()) {
            final thisCollection =
                snapshot.data!.where((d) => d['collection'] == collection);
            data[collection] = thisCollection
                .toList()
                .unique((element) => element['needs-information']);
          }
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final collection = data.keys.toList()[index];
                  return ListTile(
                    title: Text(collection),
                    contentPadding: const EdgeInsetsDirectional.only(
                        start: 16.0, top: 16.0),
                    subtitle: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data[collection]!.length,
                        itemBuilder: (context, index) {
                          final infoDesc =
                              data[collection]![index]['label']['en'];
                          return ListTile(
                            title: Text(infoDesc),
                            subtitle: TextFormField(
                              initialValue: data[collection]![index]['value'],
                              decoration: InputDecoration(
                                hintText: data[collection]![index]['example']
                                    ['en'],
                              ),
                              validator: (String? value) {
                                if (value != null && value.isNotEmpty) {
                                  if (data[collection]![index]['regex'] !=
                                          null &&
                                      data[collection]![index]['regex'] != "") {
                                    if (!RegExp(
                                            data[collection]![index]['regex'])
                                        .hasMatch(value)) {
                                      return getInvalidInputNamed(infoDesc);
                                    }
                                  }
                                }
                                return null;
                              },
                              onSaved: (String? value) async {
                                await setExtraInformation(
                                    data[collection]![index]
                                        ['needs-information'],
                                    value);
                              },
                            ),
                          );
                        }),
                  );
                },
              ),
              ListTile(
                minVerticalPadding: 24.0,
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.onSaved != null) {
                        widget.onSaved!();
                      }
                    },
                    child: Text(getSaveText()),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text(getErrorText(snapshot.error.toString()));
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
