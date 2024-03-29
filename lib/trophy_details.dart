import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:accomplishments_viewer/utils.dart';
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
  TrophyDetailsState createState() => TrophyDetailsState();
}

String asTableRow(String title, String text) =>
    "<tr><th>$title</th><td>$text</td></tr>";

String asHeadingRow(String text) => '<tr><th colspan="2">$text</th></tr>';

class TrophyDetailsState extends State<TrophyDetails> {
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

  Widget withLockAndOpacity(Widget imageWidget) {
    if (!trophyDetails!.accomplished) {
      imageWidget = Opacity(
        opacity: 0.2,
        child: imageWidget,
      );
    }

    if (trophyDetails!.locked) {
      imageWidget = Stack(
        alignment: Alignment.center,
        children: [
          imageWidget,
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
  }

  @override
  Widget build(BuildContext context) {
    if (dependencies == null || trophyDetails == null) {
      return const CircularProgressIndicator();
    }

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
          customRenders: {
            tagMatcher("depends"):
                CustomRender.inlineSpan(inlineSpan: (renderContext, children) {
              if (dependencies!.isNotEmpty) {
                return TextSpan(
                    children: dependencies!.keys
                        .where((key) =>
                            !(dependencies![key]?.accomplished ?? false))
                        .expand((element) => [
                              TextSpan(
                                text: dependencies![element]!.title,
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue),
                                mouseCursor: SystemMouseCursors.click,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TrophyDetails(
                                            key: Key(element),
                                            trophyId: element,
                                          ),
                                        ),
                                      ),
                              ),
                              const TextSpan(text: ', ')
                            ])
                        .toList()
                        .cast<InlineSpan>()
                      ..removeLast());
              } else {
                return const TextSpan();
              }
            }),
            networkSourceMatcher(extension: 'svg', schemas: ['file']):
                CustomRender.widget(
                    widget: (context, children) =>
                        withLockAndOpacity(SvgPicture.file(
                          File(context.tree.element?.attributes["src"]
                                  ?.substring(7) ??
                              'about:blank'),
                          fit: BoxFit.contain,
                        ))),
            networkSourceMatcher(schemas: ['file']): CustomRender.widget(
                widget: (context, children) => withLockAndOpacity(Image.file(
                      File(context.tree.element?.attributes["src"]
                              ?.substring(7) ??
                          'about:blank'),
                      fit: BoxFit.contain,
                    ))),
          },
          onLinkTap: (String? url, _, __, ___) async {
            if (url != null) {
              var targetUrl = Uri.parse(url);
              if (await canLaunchUrl(targetUrl)) {
                await launchUrl(targetUrl);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(getCannotLaunchUrlText(url))));
              }
            }
          },
          tagsList: Html.tags..add('depends'),
        ),
      ),
    );
  }
}
