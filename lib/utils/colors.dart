import 'package:flutter/material.dart';

class ColorPalette {
  static final Color color = Colors.grey.shade200;
  static final Color buttoncolor = Colors.grey.shade200;
  static final Color cardcolor = Colors.grey.shade200;
  static final Color appbarbackgroundColor = Colors.grey.shade200;
  static final Color bottomcolor = Colors.grey.shade400;
  static final Color dropdowncolor = Colors.grey.shade200;
  static final Color textcolor = Colors.deepPurpleAccent.shade700;
  static const Color iconColor = Colors.deepPurple;
}

class IconUsed {
  static final items = <Widget>[
    const Icon(
      Icons.camera,
      color: ColorPalette.iconColor,
    ),
    const Icon(Icons.text_fields_rounded, color: ColorPalette.iconColor),
    const Icon(
      Icons.mic_sharp,
      color: ColorPalette.iconColor,
    ),
  ];
}
