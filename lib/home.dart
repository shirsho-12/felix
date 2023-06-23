import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:facethelaw/image_to_text.dart';
import 'package:facethelaw/text_translate.dart';
import 'package:facethelaw/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:facethelaw/speech_to_text_translate.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  int page = 1;
  @override
  Widget build(BuildContext context) {
    whichpage() {
      if (page == 0) {
        return const ImageToText();
      } else if (page == 2) {
        return const SpeechToTextTranslate();
      } else {
        return const TextTranslate();
      }
    }

    return Scaffold(
      body: whichpage(),
      bottomNavigationBar: CurvedNavigationBar(
        color: ColorPalette.bottomcolor,
        index: 1,
        height: 50,
        backgroundColor: Colors.transparent,
        items: IconUsed.items,
        onTap: (index) {
          if (index == 0) {
            setState(() {
              page = 0;
            });
            whichpage();
          } else if (index == 1) {
            setState(() {
              page = 1;
            });
          } else if (index == 2) {
            setState(() {
              page = 2;
            });
          }
        },
      ),
    );
  }
}
