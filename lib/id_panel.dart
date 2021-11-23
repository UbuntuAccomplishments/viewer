import 'package:flutter/material.dart';

import 'i18n_messages.dart';

class IDPanel extends StatelessWidget {
  IDPanel({Key? key, this.onSavedIdentity}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Function? onSavedIdentity;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: getLaunchpadUsernameFieldHint(),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return getLaunchpadUsernameFieldEmptyMessage();
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    onSavedIdentity != null) {
                  onSavedIdentity!();
                }
              },
              child: Text(getSaveText()),
            ),
          ),
        ],
      ),
    );
  }
}
