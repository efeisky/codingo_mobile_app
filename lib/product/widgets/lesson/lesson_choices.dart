import 'package:codingo/product/theme/font_theme.dart';
import 'package:flutter/material.dart';

class LessonChoice extends StatefulWidget {
  const LessonChoice({Key? key, required this.choiceOrder, required this.choiceValue, required this.onChoiced, required this.isCorrectAnswer}) : super(key: key);
  final int choiceOrder;
  final String choiceValue;
  final bool? Function(int value) onChoiced;
  final bool? isCorrectAnswer;

  @override
  State<LessonChoice> createState() => _LessonChoiceState();
}

class _LessonChoiceState extends State<LessonChoice> {
  bool? _choiceStatus;

  final List _choices = ['', 'A', 'B', 'C', 'D'];

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    if (widget.isCorrectAnswer == null) {
      setState(() {
        _choiceStatus = null;
      });
    }
    if (widget.isCorrectAnswer == true) {
      setState(() {
        _choiceStatus = true;
      });
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: InkWell(
        onTap: () {
          final result = widget.onChoiced(widget.choiceOrder);
          if (result != null) {
            if (result) {
              setState(() {
                _choiceStatus = true;
              });
            } else {
              setState(() {
                _choiceStatus = false;
              });
            }
          }
        },
        child: Container(
          width: device.width,
          height: 50,
          decoration: ShapeDecoration(
            color: _getBackgroundColor(),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: _getBorderColor(),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Row(
            children: [
              _customWhiteSpace(width: 20),
              Text(
                '${_choices[widget.choiceOrder]} ) ',
                style: _choiceOrderText(),
              ),
              SizedBox(
                width: device.width * .75,
                child: Text(
                  widget.choiceValue,
                  style: _choiceContentText(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (_choiceStatus == null) {
      return _ChoiceTheme._disableBackground;
    } else if (_choiceStatus == true) {
      return _ChoiceTheme._trueBackground;
    } else {
      return _ChoiceTheme._falseBackground;
    }
  }

  Color _getBorderColor() {
    if (_choiceStatus == null) {
      return _ChoiceTheme._disableBorder;
    } else if (_choiceStatus == true) {
      return _ChoiceTheme._trueBorder;
    } else {
      return _ChoiceTheme._falseBorder;
    }
  }

  TextStyle _choiceOrderText() {
    return TextStyle(
      fontFamily: FontTheme.fontFamily,
      fontSize: FontTheme.nbfontSize,
      fontWeight: FontTheme.xfontWeight,
      color: _choiceStatus == null ? Colors.black : Colors.white,
    );
  }

  TextStyle _choiceContentText() {
    return TextStyle(
      fontFamily: FontTheme.fontFamily,
      fontSize: FontTheme.fontSize,
      fontWeight: FontTheme.rfontWeight,
      color: _choiceStatus == null ? Colors.black : Colors.white,
    );
  }

  SizedBox _customWhiteSpace({double width = 0, double height = 0}) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}

class _ChoiceTheme {
  static const Color _disableBackground = Color(0xFFFFFFFF);
  static const Color _disableBorder = Color(0xFFC9C9C9);

  static const Color _trueBackground = Color(0xFF3ACD7E);
  static const Color _trueBorder = Color(0xFF34B670);

  static const Color _falseBackground = Color(0xFFEA4335);
  static const Color _falseBorder = Color(0xFFE64A19);
}
