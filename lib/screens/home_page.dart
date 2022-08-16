// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:voice_to_text/utils.dart';
import '../speech_api.dart';
import '../widget/substring_highlight.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String text = 'Press the button and start speaking';
  bool isListening = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Voice to Text'),
          actions: [
            Builder(builder: (context) => IconButton(
              icon: const Icon(Icons.content_copy,color: Colors.white,),
              onPressed: () async {
                await FlutterClipboard.copy(text);
                Scaffold.of(context).showSnackBar(
                    const SnackBar(content: Text('✔   Copied to clipboard'),)
                );
              },
            ),
            )
          ],
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding:const EdgeInsets.all(30).copyWith(bottom: 100),
            child: SubstringHighlight(
              text: text,
              terms: Command.all,
              textStyle: const TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.w400
              ),
              textStyleHighlight: const TextStyle(
                fontSize: 25,
                color: Colors.red,
                fontWeight: FontWeight.w400
              ),
            ),
          )
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
            animate: isListening,
            endRadius: 75,
            glowColor: Colors.black,
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: toggleRecording,
              child: Icon(
                isListening ? Icons.mic : Icons.mic_none,
                size: 35,),
            ),
        )
      ),
    );
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
    onResult: (text) => setState(() => this.text = text),
    onListening: (isListening) {
      setState(() => this.isListening = isListening);

      if (!isListening) {
        Future.delayed(const Duration(seconds: 1), () {
          Utils.scanText(text);
        });
      }
    },
  );
}
