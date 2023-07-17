import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/enum/lesson_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_bottom_bar.dart';
import 'package:codingo/product/widgets/custom_lesson_container.dart';
import 'package:codingo/views/user_home/model/user_home_model.dart';
import 'package:codingo/views/user_home/service/user_home_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> with NavigatorMixin {
  String _initialUsername = '';
  final _currentPage = NavigatorRoutesPaths.userHome;
  late final UserHomeService _service;
  UserHomeModel _model = UserHomeModel(
    name: '...',userClass: 0,mathNumber: 0,pythonNumber: 0, userCompleted: false, mathSubject: '...', pythonStatus: false, pythonSubject: '...'
  );
  @override
  void initState() {
    super.initState();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    _service = UserHomeService();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final UserHomeModel response = await _service.getUserValues(_initialUsername);
    if (mounted) {
      if (response.getUserCompleted) {
        setState(() {
          _model = response;
        });
      } else {
        router.pushReplacementToPage(NavigatorRoutesPaths.completeRegister, arguments: {'username': _initialUsername});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        mainTitle: 'Hoş Geldin,',
        changeableTitle: _model.getName,
        fontSize: _UserHomeTheme.fontSize,
        hasMenu: true, 
        onTap: () { 
          router.pushReplacementToPage(NavigatorRoutesPaths.menu,arguments: {'backPage':NavigatorRoutesPaths.userHome});
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomLessonContainer(
              imgPath: ImagePaths.math_image,
              lessonContent: _model.getMathSubject,
              lesson: LessonEnum.math,
              lessonNo: _model.getMathNumber,
              userClass: _model.getUserClass.toString(),
              ),
            CustomLessonContainer(
              imgPath: ImagePaths.python_image,
              lessonContent: _model.getPythonSubject,
              lesson: LessonEnum.python,
              status: _model.getPythonStatus,
              lessonNo: _model.getPythonNumber,
              userClass: _model.getUserClass.toString(),
              ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(activePage: _currentPage,)
    );
  }

}

class _UserHomeTheme {
  static const double fontSize = 22;
}