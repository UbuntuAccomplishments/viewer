import 'package:flutter/material.dart';

import 'extrainfo_form.dart';

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
                title: const Text('Check accomplishments'),
                onTap: () {
                  // TODO: receck accomplishments
                },
              ),
              ListTile(
                title: const Text('Reload accomplishments collections...'),
                onTap: () {
                  // TODO: reload collections
                },
              ),
              ListTile(
                minVerticalPadding: 24.0,
                title: const Text('Extra information...'),
                subtitle: ExtraInfoForm(
                  onSaved: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Settings saved.')));
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
