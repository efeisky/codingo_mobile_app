import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/button/custom_button.dart';
import 'package:codingo/product/widgets/lesson/lesson_app_bar.dart';
import 'package:codingo/views/lesson/model/lesson_information_model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LessonInformationView extends StatefulWidget {
  const LessonInformationView({super.key});

  @override
  State<LessonInformationView> createState() => _LessonInformationViewState();
}

class _LessonInformationViewState extends State<LessonInformationView> with NavigatorMixin {
  late final WebViewController _videoController;
  late final WebViewController _textController;
  final String _stabilizeHtmlString = '<!DOCTYPE html><html><head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>';
  final LessonInformationModel _informationModel = LessonInformationModel();
  @override
  void initState() {
    super.initState();
    _videoController = WebViewController();
    _textController = WebViewController();
    ()async{
      await _initializeValue();

      _videoController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(_informationModel.infoVideoSrc!));

      _textController
      ..setBackgroundColor(Colors.transparent)
      ..loadHtmlString(_stabilizeHtmlString + _informationModel.infoXml.toString());
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
          _informationModel.infoXml = modelArgs['info_xml'];
          _informationModel.infoVideoSrc = modelArgs['info_video_src'];
          _informationModel.questions = modelArgs['questions'];
        });
      }
      else{
        router.pushReplacementToPage(NavigatorRoutesPaths.lessonCheck);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    const Color fgColor = Color(0xFFFFFFFF);
    const Color bgColor = Color(0xFF4285F4);
    return Scaffold(
      appBar: LessonAppBar(context: context,barTitle: 'Konu Anlatımı'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: device.width * .05),
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: WebViewWidget(
                  controller: _videoController,
                ),
              ),
              _customSizedBox(device.height * .025),
              SizedBox(
                width: device.width,
                child: Text(
                  _informationModel.subject ?? '',
                  style: const TextStyle(
                    fontFamily: FontTheme.fontFamily,
                    fontSize: FontTheme.bfontSize,
                    fontWeight: FontTheme.xfontWeight
                  ),
                )
              ),
              _customSizedBox(device.height * .025),
              SizedBox(
                height: device.height * .2,
                child: WebViewWidget(
                  controller: _textController,
                ),
              ),
              _customSizedBox(device.height * .025),
              CustomButton(
                buttonText: 'Sorulara Başla', 
                foregroundColor: fgColor, 
                backgroundColor: bgColor, 
                borderRadius: BorderRadius.circular(25), 
                horizontalPadding: 45, 
                verticalPadding: 30, 
                fontSize: FontTheme.nbfontSize, 
                onPressed: () async{
                router.pushReplacementToPage(NavigatorRoutesPaths.lessonQuestion,arguments: {
                  'subject' : _informationModel.subject,
                  'lesson_id' : _informationModel.lessonId,
                  'lesson_class' : _informationModel.lessonClass,
                  'lesson_name' : _informationModel.lessonName,
                  'questions' : _informationModel.questions
                });
                return true;
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _customSizedBox(double height) => SizedBox(height: height);
}