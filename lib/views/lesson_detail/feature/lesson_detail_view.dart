import 'package:codingo/product/enum/lesson_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_bottom_bar.dart';
import 'package:codingo/views/lesson_detail/model/lesson_detail_model.dart';
import 'package:codingo/views/lesson_detail/service/lesson_detail_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LessonDetailView extends StatefulWidget {
  const LessonDetailView({super.key});

  @override
  State<LessonDetailView> createState() => _LessonDetailViewState();
}

class _LessonDetailViewState extends State<LessonDetailView> with NavigatorMixin{
  LessonEnum? _selectedLesson;
  late final LessonDetailService _service;
  String _initialUsername = '';
  int _maxLessonID = 0;
  List<LessonDetailModel>? _list;

  @override
  void initState() {
    super.initState();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    _service = LessonDetailService();
    ()async{
      await _initializeValue();
      await _fetchLessonDatas();
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

  Future<void> _fetchLessonDatas() async {
    final response = await _service.getLessonDetail(_selectedLesson!, _initialUsername);
    if (response != null) {
      setState(() {
        _maxLessonID = response['myLessonID'];
        _list = response['lessonDetails'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        mainTitle: 'Ders Detayı',
        changeableTitle: _selectedLesson == LessonEnum.math ? 'Matematik Detayları' : 'Python Detayları',
        hasArrow: true,
        backPage: NavigatorRoutesPaths.userHome,
      ),
      body: Column(
        children: [
          if (_list == null)
            _progress()
          else
            Expanded(
              child: ListView.builder(
                itemCount: _list!.length,
                itemBuilder: (context, index) {
                  final item = _list![index];
                  var isCompleted = item.lessonResult.trueAnswerCount != 0 && item.lessonResult.falseAnswerCount  != 0 && _maxLessonID > item.id;
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: device.width * .05, vertical: device.height * .025),
                    padding: EdgeInsets.symmetric(horizontal: device.width * .025, vertical: device.height * .02),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text : TextSpan(
                                children: [
                                  TextSpan(
                                    text: ' ${item.id + 1}. Ders ',
                                    style: const TextStyle(
                                      color: FontTheme.lightNormalColor,
                                      fontFamily: FontTheme.fontFamily,
                                      fontSize: FontTheme.nbfontSize,
                                      fontWeight: FontTheme.xfontWeight
                                    ),
                                  ),
                                  TextSpan(
                                      text: '${item.questionCount} soru',
                                      style: const TextStyle(
                                        color: _LessonDetailTheme.italicTextColor,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: FontTheme.fontFamily,
                                        fontSize: FontTheme.fontSize,
                                        fontWeight: FontTheme.rfontWeight
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isCompleted)
                              const Row(
                                children: [
                                  Icon(Icons.done_rounded, color: FontTheme.greenColor,),
                                  SizedBox(width: 5,),
                                  Text('Yapıldı',style: TextStyle(
                                    color: FontTheme.greenColor,
                                    fontFamily: FontTheme.fontFamily,
                                    fontSize: FontTheme.xsfontSize,
                                    fontWeight: FontTheme.rfontWeight
                                  ),)
                                ],
                              )
                            else 
                              const Row(
                                children: [
                                  Icon(Icons.error_outline_rounded, color: FontTheme.errorColor,),
                                  SizedBox(width: 5,),
                                  Text('Yapılmadı',style: TextStyle(
                                    color: FontTheme.errorColor,
                                    fontFamily: FontTheme.fontFamily,
                                    fontSize: FontTheme.xsfontSize,
                                    fontWeight: FontTheme.rfontWeight
                                  ),)
                                ],
                              )
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.subject,
                              style: const TextStyle(
                                color: FontTheme.lightNormalColor,
                                fontFamily: FontTheme.fontFamily,
                                fontSize: FontTheme.fontSize,
                                fontWeight: FontTheme.xfontWeight
                              ),
                            ),
                            if(isCompleted)
                              Text('${item.lessonResult.trueAnswerCount / item.questionCount}',style: const TextStyle(
                                color: FontTheme.greenColor,
                                fontFamily: FontTheme.fontFamily,
                                fontSize: FontTheme.xsfontSize,
                                fontWeight: FontTheme.rfontWeight
                              ),)
                            else
                              TextButton(
                                onPressed: () {
                                
                                }, 
                                child: const Text(
                                  'Dersi Yap',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontFamily: FontTheme.fontFamily,
                                    fontSize: FontTheme.xsfontSize,
                                    fontWeight: FontTheme.xfontWeight
                                  ),
                                  )
                              )
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(activePage: NavigatorRoutesPaths.lessonDetail),
    );
  }
  Center _progress() => const Center(child: CircularProgressIndicator(
    color: _LessonDetailTheme.progressColor ,
  ));
}

class _LessonDetailTheme {
  static const Color progressColor = Color.fromRGBO(92, 74, 203, 1);
  static const Color italicTextColor = Color(0xFF7D7D7D);
}