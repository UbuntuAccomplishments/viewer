import 'package:flutter/material.dart';

import 'i18n_messages.dart';
import 'models/accomplishment.dart';
import 'trophy_details.dart';
import 'ua_state.dart';
import 'trophy.dart';

class TrophiesGrid extends StatelessWidget {
  const TrophiesGrid({Key? key, required this.showOpportunities})
      : super(key: key);

  final bool showOpportunities;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: UAState.of(context)?.database,
          builder: (BuildContext context,
              AsyncSnapshot<List<Accomplishment>> snapshot) {
            if (snapshot.hasData) {
              final trophies = snapshot.data!
                  .where((trophy) => trophy.accomplished || showOpportunities)
                  .toList();
              return GridView.builder(
                primary: false,
                padding: const EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 48,
                  mainAxisSpacing: 16,
                  crossAxisCount:
                      (MediaQuery.of(context).size.width / 256).ceil(),
                  childAspectRatio: 0.6,
                ),
                itemCount: trophies.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrophyDetails(
                            key: Key(trophies[index].id),
                            trophyId: trophies[index].id),
                      ),
                    );
                  },
                  child: Trophy(
                    trophy: trophies[index],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text(getErrorText(snapshot.error.toString()));
            }
            return const CircularProgressIndicator();
          }),
    );
  }
}
