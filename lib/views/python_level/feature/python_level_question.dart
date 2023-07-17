import 'package:codingo/product/constant/duration_items.dart';
import 'package:codingo/product/enum/lesson_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/model/question_model.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/lesson/lesson_app_bar.dart';
import 'package:codingo/product/widgets/lesson/lesson_question_area.dart';
import 'package:codingo/product/widgets/lesson/basic_action_area.dart';
import 'package:codingo/views/python_level/model/python_level_models.dart';
import 'package:codingo/views/python_level/model/python_machine_model.dart';
import 'package:codingo/views/python_level/service/python_level_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PythonLevelingView extends StatefulWidget {
  const PythonLevelingView({super.key});

  @override
  State<PythonLevelingView> createState() => _PythonLevelingViewState();
}

class _PythonLevelingViewState extends State<PythonLevelingView> with NavigatorMixin{

  late final PythonLevelService _service;
  String _initialUsername = '';

  List<QuestionModel>? _questions;
  int _questionLength = 0;
  bool _isPassedQuestion = false;
  bool? _windowStatus;
  bool _isLoading = false;
  @override
  void initState() {
    _service = PythonLevelService();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    super.initState();
    ()async{
      await _fetchUserData();
    }();
  }

  Future<void> _fetchUserData() async {
    final response = await _service.getQuestions();
    if (response != null) {
      setState(() {
        _questions = response.questions;
        _questionLength = response.questions.length;
      });
    }else{
      router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
    }
  }
  void _changeLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
      _isLoading = !_isLoading;
      });
    });
  }
  Future<void> _controlPythonLevel(List<Map> data) async {
    _changeLoading();
    final response = await _service.controlPythonLevel(data);
    if (response != null) {
      if (response.status == PythonMachineItems.passed) {
        if (_questions != null && _questions!.length >= 3) {
          _questions = _questions!.sublist(3);
        }
      }else{
        await _finishedPythonLeveling(response.recommendResult!);
      }
    }
    _changeLoading();
  }

  Future<void> _finishedPythonLeveling(int pythonLevel) async{
    PythonKnowModel model = PythonKnowModel(username: _initialUsername, status: pythonLevel);
    final response = await _service.setPythonLevel(model);
    if (response) {
      await _showStatusSnackBar('Ders Seviyesi : $pythonLevel');
      router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
    }else{
      await _showStatusSnackBar('Bir Hata Oluştu!');
      router.pushReplacementToPage(NavigatorRoutesPaths.pythonDecide);
    }
  }

  Future<void> _showStatusSnackBar(String message) async{
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          message,
          style: const TextStyle(
            color: FontTheme.whiteColor,
            fontFamily: FontTheme.fontFamily,
            fontSize: FontTheme.xsfontSize,
            fontWeight: FontTheme.rfontWeight
          ),
        ),
        duration: DurationItems.durationLarge(),
      ),
    );
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
                  child: !_isLoading ? LessonQuestionArea(
                    type: LessonAreaType.pythonLevel,
                    questions: _questions!,
                    onAnswered: (status) {
                      setState(() {
                        _windowStatus = status;
                      });
                    }, 
                    isNextQuestion: _isPassedQuestion, 
                    passedQuestion: () {
                      _passQuestion();
                    },
                    controlLevel: (data) async{
                      await _controlPythonLevel(data);
                    },
                    endQuestionPython: () async{
                      await _finishedPythonLeveling((_questionLength / 2).floor());
                    },
                  ) : Column(
                    children: [
                      _progress(),
                    ],
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
      appBar: LessonAppBar(context: context, barTitle: 'Python Seviye Soruları'),
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