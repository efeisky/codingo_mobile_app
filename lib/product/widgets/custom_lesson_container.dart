import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/enum/lesson_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:flutter/material.dart';

class CustomLessonContainer extends StatefulWidget {
  const CustomLessonContainer({super.key, required this.imgPath, required this.lesson, required this.lessonContent, this.status, required this.lessonNo, required this.userClass});
  final ImagePaths imgPath;
  final LessonEnum lesson;
  final String lessonContent;
  final int lessonNo;
  final String userClass;
  final bool? status;
  @override
  State<CustomLessonContainer> createState() => _CustomLessonContainerState();
}

class _CustomLessonContainerState extends State<CustomLessonContainer> with NavigatorMixin {
  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    var customedSizedBox = SizedBox(height: device.height*.025,);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: device.width * .025, vertical: device.height * 0.025),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: widget.imgPath.toFullWidthWidget(context),
          ),
          customedSizedBox,
          Text(
            widget.lesson == LessonEnum.math ? 'Matematik' : 'Python',
            style: _LessonTheme.titleStyle,
          ),
          Text(
            widget.lessonContent,
            style: _LessonTheme.textStyle,
          ),
          customedSizedBox,

          if (widget.lesson == LessonEnum.python && widget.status == false)
          Row(
            children: [
              _pythonLevel()
            ],
          )
          else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _goLesson(),
              _doPractice(widget.lesson),
              _details(widget.lesson),
            ],
          )
        ],
      ),
    );
  }

  ElevatedButton _pythonLevel() {
    return ElevatedButton(
            onPressed: () {
              router.pushReplacementToPage(NavigatorRoutesPaths.pythonDecide);
            },
            style: _LessonTheme.elevatedButtonStyle,
            child: const Text(
              'Seviye Tespit',
              style: _LessonTheme.textStyle,
            ),
          );
  }

  ElevatedButton _goLesson() {
    return ElevatedButton(
              onPressed: () {
                final Map sendData = {
                  'lesson_name' : widget.lesson,
                  'lesson_id' : widget.lessonNo,
                  'lesson_class' : widget.userClass,
                  'lesson_content' : widget.lessonContent
                };
                router.pushReplacementToPage(NavigatorRoutesPaths.lessonCheck, arguments: sendData);
              },
              style: _LessonTheme.elevatedButtonStyle,
              child: const Text(
                'Derse Git',
                style: _LessonTheme.textStyle,
              ),
            );
  }

  TextButton _details(LessonEnum lesson) {
    return TextButton(
              onPressed: () {
                router.pushReplacementToPage(NavigatorRoutesPaths.lessonDetail, arguments: lesson);
              }, 
              style: _LessonTheme.textButtonStyle,
              child: const Text(
                  'Detayları',
                  style: _LessonTheme.textStyle,
              
              ),
            );
  }

  OutlinedButton _doPractice(LessonEnum lesson) {
    return OutlinedButton(
              onPressed: () {
               router.pushReplacementToPage(NavigatorRoutesPaths.practice, arguments: lesson);
              },
              style: _LessonTheme.outlinedButtonStyle, 
              child: const Text(
                'Pratik Yap',
                style: _LessonTheme.textStyle,
              ),
            );
  }
}
class _LessonTheme {
  static const TextStyle titleStyle = TextStyle(
    fontFamily: FontTheme.fontFamily,
    fontSize: FontTheme.nbfontSize,
    fontWeight: FontTheme.xfontWeight,
  );

  static const TextStyle textStyle = TextStyle(
    fontFamily: FontTheme.fontFamily,
    fontSize: FontTheme.fontSize,
    fontWeight: FontTheme.rfontWeight,
  );

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: _LessonTheme.whiteColor,
    backgroundColor: _LessonTheme.blueColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 0,
  );

  static ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    backgroundColor: _LessonTheme.transparentColor,
    foregroundColor: _LessonTheme.blueColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    side: const BorderSide(
      color: _LessonTheme.blueColor, // Set the desired border color here
    ),
    elevation: 0,
  );

  static ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: _LessonTheme.blueColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    
  );

  static const Color blueColor = Color.fromRGBO(66, 133, 244, 1);
  static const Color whiteColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color transparentColor = Colors.transparent;
}
