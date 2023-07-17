import 'package:codingo/product/enum/lesson_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/model/question_model.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/lesson/lesson_question_area.dart';
import 'package:codingo/product/widgets/lesson/basic_action_area.dart';
import 'package:codingo/product/widgets/lesson/lesson_app_bar.dart';
import 'package:codingo/views/practice/service/practice_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PracticeView extends StatefulWidget {
  const PracticeView({super.key});

  @override
  State<PracticeView> createState() => _PracticeViewState();
}

class _PracticeViewState extends State<PracticeView> with NavigatorMixin{
  LessonEnum? _selectedLesson;
  late final PracticeService _service;
  String _initialUsername = '';
  List<QuestionModel>? _questions;
  bool _isPassedQuestion = false;
  bool? _windowStatus;

  @override
  void initState() {
    super.initState();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    _service = PracticeService();
    ()async{
      await _initializeValue();
      await fetchUserData();
    }();
  }

  Future<void> _initializeValue() async {
    Future.microtask(() {
      final modelArgs = ModalRoute.of(context)?.settings.arguments;
      if (modelArgs is LessonEnum) {
        setState(() {
          _selectedLesson = modelArgs;
        });
      }
      else{
        router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
      }
    });
  }

  Future<void> fetchUserData() async {
    final response = await _service.getPracticeQuestions(_initialUsername,_selectedLesson!);
    if (response != null) {
      setState(() {
        _questions = response;
      });
    }else{
      router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
    }
  }
  void _passQuestion() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isPassedQuestion = false;
        _windowStatus = null;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    Widget buildBody() {
      if (_questions != null) {
        return Stack(
          children: [
            Column(
            children: [
              BasicActionArea(router: router),
              Container(
                constraints: BoxConstraints(maxHeight: device.height * .75),
                child: SingleChildScrollView(
                  child: LessonQuestionArea(
                    type: LessonAreaType.practice,
                    questions: _questions!,
                    onAnswered: (status) {
                      setState(() {
                        _windowStatus = status;
                      });
                    }, 
                    isNextQuestion: _isPassedQuestion, 
                    passedQuestion: () {
                      _passQuestion();
                    }
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
      appBar: LessonAppBar(context: context,barTitle: 'Pratik Yap'),
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
