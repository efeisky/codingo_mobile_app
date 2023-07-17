import 'package:codingo/product/constant/duration_items.dart';
import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/button/custom_border_button.dart';
import 'package:codingo/product/widgets/button/custom_button.dart';
import 'package:codingo/product/widgets/lesson/lesson_app_bar.dart';
import 'package:codingo/views/lesson/model/lesson_finish_model.dart';
import 'package:codingo/views/lesson/model/lesson_information_model.dart';
import 'package:codingo/views/lesson/model/lesson_note_model.dart';
import 'package:codingo/views/lesson/service/lesson_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LessonFinishView extends StatefulWidget {
  const LessonFinishView({super.key});

  @override
  State<LessonFinishView> createState() => _LessonFinishViewState();
}

class _LessonFinishViewState extends State<LessonFinishView> with NavigatorMixin{
  String _initialUsername = '';
  final LessonInformationModel _informationModel = LessonInformationModel();
  List<LessonNoteModel>? _nots;
  final LessonFinishModel _model = LessonFinishModel();
  late final LessonService _service;
  Map? _lessonResult;

  @override
  void initState() {
    super.initState();
    _service = LessonService();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    ()async{
      await _initializeValue();
      setData();
      await _finishLesson();
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
          _lessonResult = modelArgs['lesson_result'];
          _nots = modelArgs['lesson_nots'];
        });
      }
      else{
        router.pushReplacementToPage(NavigatorRoutesPaths.lessonCheck);
      }
    });
  }
  
  void setData() {
    _model.username = _initialUsername;
    _model.subject = _informationModel.subject;
    _model.lessonId = _informationModel.lessonId;
    _model.lessonClass = _informationModel.lessonClass;
    _model.lessonName = _informationModel.lessonName;
    _model.lessonResult = _lessonResult;
    _model.lessonNots = _nots?.map((note) {
      return {'content' : note.content};
    }).toList();

    double trueCount = _lessonResult?['trueAnswerCount'].toDouble();
    double falseCount = _lessonResult?['falseAnswerCount'].toDouble();

    double scoreToAdd = (trueCount / (trueCount + falseCount)) * 100;
    _model.lessonScore = scoreToAdd.isNaN ? 50 : scoreToAdd.floorToDouble();
  }
  
  Future<void> _finishLesson() async {
  final status = await _service.finishLesson(_model);
  if (status) {
    _showStatusSnackBar('Ders Başarıyla Kaydedildi');
  } else {
    _showStatusSnackBar('Ders Kaydedilemedi');
  }
  }

  void _showStatusSnackBar(String message) {
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
  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Scaffold(
      appBar: LessonAppBar(context: context, barTitle: 'Ders Sonu'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: device.width * .125),
        child: Column(
          children: [
            SizedBox(height: device.height * .1),
            ImagePaths.finish_lesson.toFullWidthWidget(context),
            SizedBox(height: device.height * .05),
            _scoreText(),
            SizedBox(height: device.height * .05),
            CustomButton(
              buttonText: 'Ana sayfaya Git', 
              foregroundColor: Colors.white, 
              backgroundColor: Colors.black, 
              borderRadius: BorderRadius.circular(10), 
              horizontalPadding: 30, 
              verticalPadding: 20, 
              fontSize: FontTheme.xlfontSize,
              onPressed: () async{
                router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
                return true;
              }
            ),
            SizedBox(height: device.height * .05),
            CustomBorderButton(
              buttonText: 'Pratik Yap', 
              foregroundColor: Colors.black, 
              backgroundColor: Colors.transparent, 
              borderRadius: BorderRadius.circular(10), 
              horizontalPadding: 30, 
              verticalPadding: 20, 
              fontSize: FontTheme.xlfontSize,
              onPressed: () async{
                router.pushReplacementToPage(NavigatorRoutesPaths.practice, arguments: _model.lessonName);
                return true;
              }
            ),
          ],
        ),
      ),
    );
  }

  RichText _scoreText() {
    return RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Bu derste ',
                  style: TextStyle(
                    color: FontTheme.lightNormalColor,
                    fontFamily: FontTheme.fontFamily,
                    fontSize: FontTheme.fontSize,
                    fontWeight: FontTheme.rfontWeight
                  ),
                ),
                TextSpan(
                  text: _model.lessonScore?.toInt().toString(),
                  style: const TextStyle(
                    color: FontTheme.lightNormalColor,
                    fontFamily: FontTheme.fontFamily,
                    fontSize: FontTheme.nbfontSize,
                    fontWeight: FontTheme.xfontWeight
                  ),
                ),
                const TextSpan(
                  text: ' puan kazandınız.',
                  style: TextStyle(
                    color: FontTheme.lightNormalColor,
                    fontFamily: FontTheme.fontFamily,
                    fontSize: FontTheme.fontSize,
                    fontWeight: FontTheme.rfontWeight
                  ),
                ),
              ],
            ),
          );
  }
}

