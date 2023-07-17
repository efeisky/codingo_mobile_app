import 'package:codingo/product/constant/duration_items.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/button/custom_border_button.dart';
import 'package:codingo/product/widgets/button/custom_button.dart';
import 'package:codingo/product/widgets/lesson/lesson_app_bar.dart';
import 'package:codingo/views/python_level/model/python_level_models.dart';
import 'package:codingo/views/python_level/service/python_level_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PythonLevelDecide extends StatefulWidget {
  const PythonLevelDecide({ Key? key }) : super(key: key);

  @override
  State<PythonLevelDecide> createState() => _PythonLevelDecideState();
}

class _PythonLevelDecideState extends State<PythonLevelDecide> with NavigatorMixin{

  late final PythonLevelService _service;
  String _initialUsername = '';
  @override
  void initState() {
    _service = PythonLevelService();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    super.initState();
  }

  Future<void> finishDecideAsNotKnow() async{
    PythonNotKnowModel model = PythonNotKnowModel(username: _initialUsername);
    final response = await _service.notKnowPython(model);
    if (response) {
      await _showStatusSnackBar('Güncellendi');
    }else{
      await _showStatusSnackBar('Bir Hata Oluştu!');
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

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Scaffold(
      appBar: LessonAppBar(context: context, barTitle: 'Python Seviye Tespiti'),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Python Biliyor Musun?',
              style: TextStyle(
                fontFamily: FontTheme.fontFamily,
                fontSize: FontTheme.xlfontSize,
                fontWeight: FontTheme.rfontWeight,
                color: FontTheme.lightNormalColor
              ),
            ),
            SizedBox(height: device.height * .03),
            CustomButton(
              buttonText: 'Biliyorum', 
              foregroundColor: Colors.white, 
              backgroundColor: Colors.black, 
              borderRadius: BorderRadius.circular(10), 
              horizontalPadding: 20, 
              verticalPadding: 20, 
              fontSize: FontTheme.xlfontSize,
              onPressed: () async{
                router.pushReplacementToPage(NavigatorRoutesPaths.pythonLeveling);
                return true;
              }
            ),
            SizedBox(height: device.height * .045),
            CustomBorderButton(
              buttonText: 'Bilmiyorum', 
              foregroundColor: Colors.black, 
              backgroundColor: Colors.transparent, 
              borderRadius: BorderRadius.circular(10), 
              horizontalPadding: 20, 
              verticalPadding: 20, 
              fontSize: FontTheme.xlfontSize,
              onPressed: () async{
                await finishDecideAsNotKnow();
                router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
                return true;
              }
            ),
          ],
        ),
      ),
    );
  }
}