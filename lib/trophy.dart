import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_svg/flutter_svg.dart';

import 'models/accomplishment.dart';

class Trophy extends StatelessWidget {
  final Accomplishment trophy;

  const Trophy({Key? key, required this.trophy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = trophy.iconPath;
    Widget imageWidget;
    if (path.extension(image) == '.svg') {
      imageWidget = SvgPicture.file(
        File(image),
        fit: BoxFit.contain,
      );
    } else {
      imageWidget = Image.file(
        File(image),
        fit: BoxFit.contain,
      );
    }
    if (!trophy.accomplished) {
      imageWidget = Opacity(
        opacity: 0.35,
        child: imageWidget,
      );
    }
    if (trophy.locked) {
      imageWidget = Stack(
        alignment: Alignment.topCenter,
        children: [
          imageWidget,
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset('data/media/lock.svg'),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: imageWidget,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 8),
            alignment: Alignment.topCenter,
            child: Text(trophy.title, textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}
