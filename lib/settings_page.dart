import 'package:flutter/material.dart';

import 'dbus.dart';
import 'extrainfo_form.dart';
import 'i18n_messages.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key, required this.title}) : super(key: key);

  final String title;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                title: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(getCheckingAccomplishmentsMessage())));
                    runScripts();
                  },
                  child: Text(getCheckAccomplishmentsButton()),
                ),
              ),
              ListTile(
                title: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(getReloadingAccomplishmentsMessage())));
                    reloadAccomDatabase();
                  },
                  child: Text(getReloadAccomplishmentsButton()),
                ),
              ),
              ListTile(
                minVerticalPadding: 24.0,
                title: Text(getExtraInformationText()),
                subtitle: ExtraInfoForm(
                  onSaved: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(getSettingsSavedMessage())));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
