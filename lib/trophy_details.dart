import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ubuntuaccomplishments/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dbus.dart';
import 'i18n_messages.dart';
import 'models/accomplishment.dart';

const htmlContent = r"""
<p style="text-align: center"><img src="file://::image::"></p>
<table>
  ::description::
  ::summary::
  ::depends::
  ::steps::
  ::tips::
  ::pitfalls::
  ::links::
  ::help::
  ::author::
</table>
""";

class TrophyDetails extends StatefulWidget {
  const TrophyDetails({Key? key, required this.trophyId}) : super(key: key);

  final String trophyId;

  @override
  _TrophyDetailsState createState() => _TrophyDetailsState();
}

String asTableRow(String title, String text) =>
    "<tr><th>$title</th><td>$text</td></tr>";

String asHeadingRow(String text) => '<tr><th colspan="2">$text</th></tr>';

class _TrophyDetailsState extends State<TrophyDetails> {
  Accomplishment? trophyDetails;
  Map<String, Accomplishment>? dependencies;

  @override
  void initState() {
    super.initState();
    () async {
      final details = await getAccomData(widget.trophyId)
          .then((trophy) => Accomplishment.fromJson(trophy));
      final deps = await listDependingOn(widget.trophyId);
      setState(() {
        trophyDetails = details;
        dependencies = deps;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    if (dependencies == null || trophyDetails == null) {
      return const CircularProgressIndicator();
    }

    final bool accomplished = trophyDetails!.accomplished;
    final String title = trophyDetails!.title;
    final String description = trophyDetails!.description;
    final String image = trophyDetails!.iconPath;
    final String summary = trophyDetails!.summary;
    String steps = trophyDetails!.steps;
    String links = trophyDetails!.links;
    String help = trophyDetails!.help;
    String tips = trophyDetails!.tips;
    String pitfalls = trophyDetails!.pitfalls;
    String author = trophyDetails!.author;

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
        title: Text(getTrophyScreenTitle(title)),
      ),
      body: SingleChildScrollView(
        child: Html(
          data: htmlContent
              .replaceAll('::image::', image)
              .replaceAll('::description::',
                  asTableRow(getDescriptionTitle(), description))
              .replaceAll('::summary::', asTableRow(getSummaryTitle(), summary))
              .replaceAll(
                  '::depends::',
                  trophyDetails!.locked
                      ? asHeadingRow(getTrophyDependencies('<depends />'))
                      : '')
              .replaceAll('::steps::', asTableRow(getStepsTitle(), steps))
              .replaceAll('::tips::', asTableRow(getTipsTitle(), tips))
              .replaceAll(
                  '::pitfalls::', asTableRow(getPitfallsTitle(), pitfalls))
              .replaceAll(
                  '::links::', asTableRow(getRelevantLinksTitle(), links))
              .replaceAll('::help::', asTableRow(getFurtherHelpTitle(), help))
              .replaceAll('::author::', asHeadingRow(getTrophyAuthor(author))),
          style: {
            'tr': Style(
              padding: const EdgeInsets.all(10.0),
            ),
            'th': Style(
              alignment: Alignment.topLeft,
            ),
          },
          customRender: {
            'depends': (RenderContext renderContext, Widget child) {
              if (dependencies!.isNotEmpty) {
                return TextSpan(
                    children: dependencies!.keys
                        .map((k) => TextSpan(
                                children: [
                              TextSpan(
                                text: dependencies![k]!.title,
                                style: const TextStyle(
                                    decoration: TextDecoration.underline),
                                mouseCursor: SystemMouseCursors.click,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TrophyDetails(
                                            key: Key(k),
                                            trophyId: k,
                                          ),
                                        ),
                                      ),
                              ),
                              const TextSpan(text: ', '),
                            ]..removeLast()))
                        .toList()
                        .cast<InlineSpan>());
              } else {
                return const TextSpan();
              }
            },
          },
          onLinkTap: (String? url, _, __, ___) async {
            if (url != null) {
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(getCannotLaunchUrlText(url))));
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
              return Image.file(
                  File(attributes['src']?.substring(7) ?? 'about:blank'));
            },
          },
          tagsList: Html.tags..add('depends'),
        ),
      ),
    );
  }
}
