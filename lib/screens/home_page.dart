import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import '../speech_api.dart';

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
                    SnackBar(content: Text('✔   Copied to clipboard'),)
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
            child: Text(text,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              color: Colors.black
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
              child: Icon(
                isListening ? Icons.mic : Icons.mic_none,
                size: 35,),
              onPressed: toggleRecording,
            ),
        )
      ),
    );
  }

  Future<bool> toggleRecording() => SpeechApi.toggleRecording(
    onResult: (text) => setState(() => this.text = text),
    onListening: (isListening) => setState(() => this.isListening = isListening),
  );
}
