import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/model/question_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeakQuestion extends StatelessWidget {
  SpeakQuestion({
    super.key,
    required this.questions,
    required int activeQuestion,
  }) : _activeQuestion = activeQuestion;

  final List<QuestionModel> questions;
  final int _activeQuestion;

  final FlutterTts speach = FlutterTts();

  Future<void> _speak(String content) async {
    await speach.setLanguage("tr-TR");
    await speach.setVolume(1);
    await speach.setPitch(1);
    await speach.setSpeechRate(.5);
    await speach.speak(content);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        await _speak(questions[_activeQuestion].content);
      },
      child: ImagePaths.speaker.toWidget(height: 30),
    );
  }
}
