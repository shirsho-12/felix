import 'package:avatar_glow/avatar_glow.dart';
import 'package:facethelaw/utils/colors.dart';
import 'package:facethelaw/utils/languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';

class SpeechToTextTranslate extends StatefulWidget {
  const SpeechToTextTranslate({Key? key}) : super(key: key);

  @override
  _SpeechToTextTranslateState createState() => _SpeechToTextTranslateState();
}

class _SpeechToTextTranslateState extends State<SpeechToTextTranslate> {
  String? selectedto = "Chinese";
  bool isTranslate = true;
  String finaltext = "";
  final stt.SpeechToText _speechtotext = stt.SpeechToText();

  bool isListening = false;
  String speechToText = "Press The Button and Start Speaking";
  // TextEditingController textController = TextEditingController();
  int initialindex = 2;
  final translator = GoogleTranslator();
  final FlutterTts flutterTts = FlutterTts();
  var output;
  translate(String text, String lang) async {
    await translator.translate(text, to: lang).then((value) {
      setState(() {
        output = value;

        isTranslate = true;
      });
    });
    await flutterTts.setLanguage(lang);
    await flutterTts.setPitch(0.7);
    await flutterTts.speak(output.toString());
  }

  listen() async {
    if (isListening == false) {
      bool available = await _speechtotext.initialize(
          onStatus: (v) => {}, onError: (v) => {});
      if (available) {
        setState(() {
          isListening = true;
        });
        _speechtotext.listen(onResult: (value) {
          speechToText = value.recognizedWords;
        });
      }
    } else {
      setState(() {
        isListening = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 4.5;
    return Scaffold(
      extendBody: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: height),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple, width: 3),
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: Text(
                        speechToText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: ColorPalette.buttoncolor,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: speechToText));
                      },
                      child: const Icon(
                        Icons.copy,
                        color: ColorPalette.iconColor,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Card(
                    color: ColorPalette.dropdowncolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    elevation: 25,
                    child: SizedBox(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Convert To",
                            style: TextStyle(
                                color: ColorPalette.textcolor,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            decoration:
                                BoxDecoration(color: ColorPalette.color),
                            // color: Colors.white,
                            width: 160,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hoverColor: ColorPalette.color,
                                fillColor: ColorPalette.color,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  borderSide: BorderSide(
                                      width: 5, color: ColorPalette.color),
                                ),
                              ),
                              value: selectedto,
                              items: TranslationLanguages.selectLanguages
                                  .map((language) => DropdownMenuItem<String>(
                                        value: language,
                                        child: Text(
                                          "  $language",
                                          style: TextStyle(
                                              color: ColorPalette.textcolor),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (language) =>
                                  setState(() => selectedto = language),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.deepPurpleAccent,
                              ),
                              iconSize: 42,
                              // // underline: SizedBox(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            backgroundColor: ColorPalette.buttoncolor,
                          ),
                          onPressed: () {
                            setState(() {
                              isTranslate = false;
                            });
                            output = "";
                            setState(() {
                              finaltext = speechToText;
                            });
                            translate(
                                finaltext,
                                TranslationLanguages.getLanguageCode(
                                    selectedto!));
                          },
                          child: isTranslate
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "Translate",
                                    style: TextStyle(
                                        color: ColorPalette.textcolor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(
                                    color: ColorPalette.textcolor,
                                  ),
                                )),
                      const SizedBox(
                        height: 50,
                      ),
                      output == null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  color: ColorPalette.cardcolor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  elevation: 25,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      output == null ? "" : output.toString(),
                                      style: TextStyle(
                                          color: ColorPalette.textcolor,
                                          fontSize: 17),
                                    ),
                                  )),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: ColorPalette.iconColor,
                            ),
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: output.toString()));
                            },
                            child: Icon(
                              Icons.copy,
                              color: ColorPalette.buttoncolor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        glowColor: ColorPalette.iconColor,
        endRadius: 75,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
            backgroundColor: ColorPalette.buttoncolor,
            onPressed: () {
              listen();
            },
            child: isListening
                ? const Icon(
                    Icons.mic,
                    color: ColorPalette.iconColor,
                  )
                : const Icon(Icons.mic_none, color: ColorPalette.iconColor)),
      ),
    );
  }
}
