import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ubuntuaccomplishments/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dbus.dart';
import 'models/accomplishment.dart';

const htmlContent = r"""
<p style="text-align: center"><img src="file://::image::"></p>
<table>
  <tr><th>Description:</th><td>::description::</td></tr>
  <tr><th>About the trophy:</th><td>::summary::</td></tr>
  <tr><th>Steps to complete for this trophy:</th><td>::steps::</td></tr>
  <tr><th>Tips:</th><td>::tips::</td></tr>
  <tr><th>Pitfalls:</th><td>::pitfalls::</td></tr>
  <tr><th>Relevant links:</th><td>::links::</td></tr>
  <tr><th>Further help can be found at:</th><td>::help::</td></tr>
  <tr><td colspan="2">This trophy was contributed by ::author::</td></tr>
</table>
""";

class TrophyDetails extends StatefulWidget {
  const TrophyDetails({Key? key, required this.trophyId}) : super(key: key);

  final String trophyId;

  @override
  _TrophyDetailsState createState() => _TrophyDetailsState();
}

class _TrophyDetailsState extends State<TrophyDetails> {
  late Future<Accomplishment> trophyDetails;

  @override
  void initState() {
    super.initState();
    trophyDetails = getAccomData(widget.trophyId)
        .then((trophy) => Accomplishment.fromJson(trophy));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: trophyDetails,
        builder:
            (BuildContext context, AsyncSnapshot<Accomplishment> snapshot) {
          if (snapshot.hasData) {
            final bool accomplished = snapshot.data!.accomplished;
            final String title = snapshot.data!.title;
            final String description = snapshot.data!.description;
            final String image = snapshot.data!.iconPath;
            final String summary = snapshot.data!.summary;
            String steps = snapshot.data!.steps;
            String links = snapshot.data!.links;
            String help = snapshot.data!.help;
            String tips = snapshot.data!.tips;
            String pitfalls = snapshot.data!.pitfalls;
            String author = snapshot.data!.author;

            steps = steps.convertToHtmlList(ordered: true);
            links = links.addUrlsAsHtmlAnchors();
            links = links.convertToHtmlList(ordered: false);
            help = help.addUrlsAsHtmlAnchors();
            help = help.convertToHtmlList(ordered: false);
            tips = tips.convertToHtmlList(ordered: false);
            pitfalls = pitfalls.convertToHtmlList(ordered: false);
            author = author.addEmailsAsHtmlAnchors();

            return Scaffold(
              appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text("Trophy Details: $title"),
              ),
              body: SingleChildScrollView(
                child: Html(
                  data: htmlContent
                      .replaceAll('::description::', description)
                      .replaceAll('::image::', image)
                      .replaceAll('::summary::', summary)
                      .replaceAll('::steps::', steps)
                      .replaceAll('::links::', links)
                      .replaceAll('::help::', help)
                      .replaceAll('::tips::', tips)
                      .replaceAll('::pitfalls::', pitfalls)
                      .replaceAll('::author::', author),
                  style: {
                    'tr': Style(
                      padding: const EdgeInsets.all(10.0),
                    ),
                    'th': Style(
                      alignment: Alignment.topLeft,
                    ),
                  },
                  onLinkTap: (String? url, _, __, ___) async {
                    if (url != null) {
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch $url')));
                      }
                    }
                  },
                  customImageRenders: {
                    networkSourceMatcher(extension: 'svg', schemas: ['file']):
                        (context, attributes, element) {
                      Widget imageWidget = SvgPicture.file(
                        File(attributes['src']?.substring(7) ?? 'about:blank'),
                        fit: BoxFit.contain,
                      );

                      if (!accomplished) {
                        imageWidget = Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: 0.2,
                              child: imageWidget,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: SvgPicture.asset('data/media/lock.svg'),
                            ),
                          ],
                        );
                      }

                      return SizedBox(
                        width: 176,
                        height: 257,
                        child: imageWidget,
                      );
                    },
                    networkSourceMatcher(schemas: ['file']):
                        (context, attributes, element) {
                      return Image.file(File(
                          attributes['src']?.substring(7) ?? 'about:blank'));
                    },
                  },
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Error... ${snapshot.error}");
          }
          return const CircularProgressIndicator();
        });
  }
}
