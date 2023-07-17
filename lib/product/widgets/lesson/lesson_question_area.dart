import 'package:codingo/core/widget/image_network_widget.dart';
import 'package:codingo/product/enum/lesson_enums.dart';
import 'package:codingo/product/model/question_model.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/lesson/lesson_choices.dart';
import 'package:codingo/product/widgets/lesson/speak_question.dart';
import 'package:flutter/material.dart';

class LessonQuestionArea extends StatefulWidget {
  const LessonQuestionArea({Key? key, required this.questions, required this.onAnswered, required this.isNextQuestion, required this.passedQuestion, required this.type, this.finishedLesson, this.controlLevel, this.endQuestionPython}) : super(key: key);
  final List<QuestionModel> questions;
  final LessonAreaType type;
  final void Function(bool status) onAnswered;
  final bool isNextQuestion;
  final VoidCallback passedQuestion;
  final Future<void> Function(List<Map> data)? controlLevel;
  final void Function(int trueCount, int falseCount)? finishedLesson;
  final Future<void> Function()? endQuestionPython;
  @override
  State<LessonQuestionArea> createState() => _LessonQuestionAreaState();
  
}

class _LessonQuestionAreaState extends State<LessonQuestionArea> {
  int _activeQuestion = 0;
  bool _selectedOption = false;
  int? _correctAnswer;
  int _trueCount = 0;
  int _falseCount = 0;
  final List<Map> _pythonLevelData = [];
  bool? _checkQuestion(int order) {
    if (_selectedOption == true) {
      return null;
    } else {
      _selectedOption = true;
      setState(() {
        _correctAnswer = widget.questions[_activeQuestion].questionAnswer;
      });

      if (widget.questions[_activeQuestion].questionAnswer == order) {
        if (widget.type == LessonAreaType.lesson) {
          _trueCount ++;
        }

        if (widget.type == LessonAreaType.pythonLevel) {
          _pythonLevelData.add({
            'QuestionID': widget.questions[_activeQuestion].id,
            'QuestionStatus': true,
          });
        }

        widget.onAnswered(true);
        return true;
      } else {
        if (widget.type == LessonAreaType.lesson) {
          _falseCount ++;
        }

        if (widget.type == LessonAreaType.pythonLevel) {
          _pythonLevelData.add({
            'QuestionID': widget.questions[_activeQuestion].id,
            'QuestionStatus': false,
          });
        }

        widget.onAnswered(false);
        return false;
      }
    }
  }

  void _nextQuestion(){
    widget.passedQuestion();
    if (widget.type == LessonAreaType.pythonLevel) {
      if (_activeQuestion == widget.questions.length - 1) {
        widget.endQuestionPython!();
      }else{
        if ((_activeQuestion + 1) % 3 == 0 && _activeQuestion + 1 != 1) {
          if(_pythonLevelData.length == 3){
            widget.controlLevel!(_pythonLevelData);
          }else{
            widget.controlLevel!(_pythonLevelData.sublist(_pythonLevelData.length - 3));
          }
        }
        setState(() {
          _activeQuestion = _activeQuestion + 1;
          _selectedOption = false;
          _correctAnswer = null;
        });
      }
      
    }
    else{
      if (_activeQuestion == widget.questions.length - 1) {
        if (widget.type == LessonAreaType.practice) {
          widget.questions.shuffle();
          setState(() {
            _activeQuestion = 0;
            _selectedOption = false;
            _correctAnswer = null;
          });
        }
        else{
          widget.finishedLesson!(_trueCount, _falseCount);
        }
        
      }else{
        setState(() {
          _activeQuestion = _activeQuestion + 1;
          _selectedOption = false;
          _correctAnswer = null;
        });
      }
    }
    
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isNextQuestion) {
      _nextQuestion();
    }
    final device = MediaQuery.of(context).size;
    var speakerText = 'Soru İçeriği';
    final questions = widget.questions;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: device.width * .05, vertical: device.height * .025),
      child: SizedBox(
        width: device.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    speakerText,
                    style: _headerTextStyle(),
                  ),
                  _customWhiteSpace(width: 20),
                  SpeakQuestion(questions: questions, activeQuestion: _activeQuestion)
                ],
              ),
              _customWhiteSpace(height: 10),
              Text(
                questions[_activeQuestion].content,
                style: _contentTextStyle(),
              ),
              _customWhiteSpace(height: 10),
              if (questions[_activeQuestion] is ImageQuestionModel)
                Column(
                  children: [
                    const ImageNetworkWidget(pictureSrc: 'https://www.indyturk.com/sites/default/files/styles/1368x911/public/article/main_image/2019/10/24/194256-82855996.jpg?itok=M0Tbg-Ju'),
                    _customWhiteSpace(height: 10),
                  ],
                )
              else
                _customWhiteSpace(height: 10),
    
              LessonChoice(
                choiceOrder: 1,
                choiceValue: questions[_activeQuestion].A,
                onChoiced: (int value) {
                  return _checkQuestion(value);
                },
                isCorrectAnswer: _correctAnswer == null ? null : 1 == _correctAnswer,
              ),
    
              LessonChoice(
                choiceOrder: 2,
                choiceValue: questions[_activeQuestion].B,
                onChoiced: (int value) {
                  return _checkQuestion(value);
                },
                isCorrectAnswer: _correctAnswer == null ? null : 2 == _correctAnswer,
              ),
    
              LessonChoice(
                choiceOrder: 3,
                choiceValue: questions[_activeQuestion].C,
                onChoiced: (int value) {
                  return _checkQuestion(value);
                },
                isCorrectAnswer: _correctAnswer == null ? null : 3 == _correctAnswer,
              ),
    
              LessonChoice(
                choiceOrder: 4,
                choiceValue: questions[_activeQuestion].D,
                onChoiced: (int value) {
                  return _checkQuestion(value);
                },
                isCorrectAnswer: _correctAnswer == null ? null : 4 == _correctAnswer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _customWhiteSpace({double width = 0, double height = 0}) {
    return SizedBox(
      width: width,
      height: height,
    );
  }

  TextStyle _headerTextStyle() {
    return const TextStyle(
      fontFamily: FontTheme.fontFamily,
      fontSize: FontTheme.xlfontSize,
      fontWeight: FontTheme.xfontWeight,
    );
  }

  TextStyle _contentTextStyle() {
    return const TextStyle(
      fontFamily: FontTheme.fontFamily,
      fontSize: FontTheme.fontSize,
      fontWeight: FontTheme.rfontWeight,
    );
  }
}
