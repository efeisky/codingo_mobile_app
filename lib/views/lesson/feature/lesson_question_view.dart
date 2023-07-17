import 'package:codingo/product/enum/lesson_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/lesson/lesson_action_area.dart';
import 'package:codingo/product/widgets/lesson/lesson_app_bar.dart';
import 'package:codingo/product/widgets/lesson/lesson_question_area.dart';
import 'package:codingo/views/lesson/model/lesson_information_model.dart';
import 'package:codingo/views/lesson/model/lesson_note_model.dart';
import 'package:flutter/material.dart';

class LessonQuestionView extends StatefulWidget {
  const LessonQuestionView({super.key});

  @override
  State<LessonQuestionView> createState() => _LessonQuestionViewState();
}

class _LessonQuestionViewState extends State<LessonQuestionView> with NavigatorMixin {
  final LessonInformationModel _informationModel = LessonInformationModel();
  bool _isPassedQuestion = false;
  bool? _windowStatus;
  final List<LessonNoteModel> _nots = [];

  @override
  void initState() {
    super.initState();
    ()async{
      await _initializeValue();

    }();
  }

  Future<void> _initializeValue() async {
    Future.microtask(() {
      final modelArgs = ModalRoute.of(context)?.settings.arguments;
      if (modelArgs is Map) {
        setState(() {
          _informationModel.subject = modelArgs['subject'];
          _informationModel.lessonId = modelArgs['lesson_id'];
          _informationModel.lessonClass = modelArgs['lesson_class'];
          _informationModel.lessonName = modelArgs['lesson_name'];
          _informationModel.questions = modelArgs['questions'];
        });
      }
      else{
        router.pushReplacementToPage(NavigatorRoutesPaths.lessonCheck);
      }
    });
  }

  void _passQuestion() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isPassedQuestion = false;
        _windowStatus = null;
      });
    });
  }

  void sendToFinish(int trueCount, int falseCount) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router.pushReplacementToPage(NavigatorRoutesPaths.lessonFinish, arguments: {
        'subject' : _informationModel.subject,
        'lesson_id' : _informationModel.lessonId,
        'lesson_class' : _informationModel.lessonClass,
        'lesson_name' : _informationModel.lessonName,
        'lesson_result' : {
          'trueAnswerCount' : trueCount,
          'falseAnswerCount' : falseCount,
        },
        'lesson_nots' : _nots
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    Widget buildBody() {
      if (_informationModel.questions != null) {
        return Stack(
          children: [
            Column(
            children: [
              LessonActionArea(
                router: router,
                addedNote: (text) {
                  _nots.add(LessonNoteModel(content: text));
                },
              ),
              Container(
                constraints: BoxConstraints(maxHeight: device.height * .75),
                child: SingleChildScrollView(
                  child: LessonQuestionArea(
                    type: LessonAreaType.lesson,
                    questions: _informationModel.questions!,
                    onAnswered: (status) {
                      setState(() {
                        _windowStatus = status;
                      });
                    }, 
                    isNextQuestion: _isPassedQuestion, 
                    passedQuestion: () {
                      _passQuestion();
                    },
                    finishedLesson: (trueCount, falseCount) {
                      sendToFinish(trueCount,falseCount);
                    },
                  ),
                ),
              )
            ],
                    ),
          _windowStatus != null
          ? Positioned(
            bottom: 0,left: 0,right: 0,
            child: Container(
              color: _windowStatus == true ? const Color(0xFF34B670) : const Color(0xFFEA4335),
              height: 150,
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 15,
                    child: Row(
                      children: [
                        Icon(
                          _windowStatus == true ? Icons.done_rounded : Icons.close_rounded,
                          size: 24,
                          color: FontTheme.whiteColor,
                        ),
                        _customWhiteSpace(width: 10),
                        Text(
                          _windowStatus == true ? 'Doğru Cevap' : 'Yanlış Cevap',
                          style: _contentTextStyle(),
                        )
                      ],
                    )
                  ),
                  Positioned(
                    bottom: 10,
                    right: 15,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isPassedQuestion = true;
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            'Sonraki Soru',
                            style: _contentTextStyle(),
                          ),
                          _customWhiteSpace(width: 10),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 32,
                            color: FontTheme.whiteColor,
                          ),
                        ],
                      ),
                    )
                  )
                ],
              ),
            ),
          )
          : const SizedBox.shrink()
          ]
        );
      } else {
        return _progress();
      }
    }
    


    return Scaffold(
      appBar: LessonAppBar(
        context: context, barTitle: 'Soru Çözümü'
      ),
      body: buildBody(),
    );
  }

  SizedBox _customWhiteSpace({double width = 0, double height = 0}) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
  
  TextStyle _contentTextStyle() {
    return const TextStyle(
      fontFamily: FontTheme.fontFamily,
      fontSize: FontTheme.nbfontSize,
      fontWeight: FontTheme.rfontWeight,
      color: FontTheme.whiteColor
    );
  }

  Center _progress() => const Center(
    child: CircularProgressIndicator(
      color: Color.fromRGBO(92, 74, 203, 1),
    )
  );
}