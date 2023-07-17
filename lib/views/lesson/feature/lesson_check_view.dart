import 'package:codingo/product/enum/lesson_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/views/lesson/model/lesson_model.dart';
import 'package:codingo/views/lesson/service/lesson_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LessonCheckView extends StatefulWidget {
  const LessonCheckView({ Key? key }) : super(key: key);

  @override
  State<LessonCheckView> createState() => _LessonCheckViewState();
}

class _LessonCheckViewState extends State<LessonCheckView> with NavigatorMixin{
  
  LessonEnum? _selectedLesson;
  int? _lessonId;
  String? _lessonClass;
  String? _lessonContent;

  late final LessonService _service;
  String _initialUsername = '';

  @override
  void initState() {
    super.initState();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    _service = LessonService();
    ()async{
      await _initializeValue();
      await fetchUserData();
    }();
  }

  Future<void> _initializeValue() async {
    Future.microtask(() {
      final modelArgs = ModalRoute.of(context)?.settings.arguments;
      if (modelArgs is Map) {
        setState(() {
          _selectedLesson = modelArgs['lesson_name'];
          _lessonId = modelArgs['lesson_id'];
          _lessonClass = modelArgs['lesson_class'];
          _lessonContent = modelArgs['lesson_content'];
        });
      }
      else{
        router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
      }
    });
  }

  Future<void> fetchUserData() async {
    final LessonModel? response = await _service.getLesson(_initialUsername,_selectedLesson!,_lessonId!,_lessonClass!);
    if (response != null) {
      if (response.informationStatus) {
        router.pushReplacementToPage(NavigatorRoutesPaths.lessonInformation,arguments: {
          'subject' : _lessonContent,
          'lesson_id' : _lessonId,
          'lesson_class' : _lessonClass,
          'lesson_name' : _selectedLesson,
          'info_xml' : response.infoXml,
          'info_video_src' : response.videoSrc,
          'questions' : response.questions
        });
      } else {
        router.pushReplacementToPage(NavigatorRoutesPaths.lessonQuestion,arguments: {
          'subject' : _lessonContent,
          'lesson_id' : _lessonId,
          'lesson_class' : _lessonClass,
          'lesson_name' : _selectedLesson,
          'questions' : response.questions
        });
      }
    }else{
      router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color progressColor = const Color.fromRGBO(90, 90, 90, 1);
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: progressColor,
        ),
      ),
    );
  }
}