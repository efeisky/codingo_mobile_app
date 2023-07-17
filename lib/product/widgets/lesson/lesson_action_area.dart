import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/manager/navigator_manager.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/button/custom_button.dart';
import 'package:codingo/product/widgets/custom_text_field.dart';
import 'package:codingo/product/widgets/lesson/lesson_action_button.dart';
import 'package:flutter/material.dart';

class LessonActionArea extends StatelessWidget {
  const LessonActionArea({
    super.key, required this.router, required this.addedNote,
  });
  final NavigatorManager router;
  final void Function(String text) addedNote;
  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
            child: LessonActionButton(
              text: 'Dersten Çık', 
              bgColor: ActionButtonTheme.logoutBg, 
              fgColor: ActionButtonTheme.logoutFg, 
              onTap: () async{ 
                router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
              },
            ),
          ),
          SizedBox(
            child: LessonActionButton(
              text: 'Not Ekle', 
              bgColor: ActionButtonTheme.addnoteBg, 
              fgColor: ActionButtonTheme.addnoteFg, 
              onTap: () async{ 
                showModalBottomSheet(
                  context: context,

                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (context) {
                    return SizedBox(
                      height: device.height * .75,
                      child: _NoteArea(
                        addedNote: (text) { 
                          addedNote(text);
                        },
                      )
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class _NoteArea extends StatefulWidget {
  const _NoteArea({super.key, required this.addedNote});
  final void Function(String text) addedNote;
  @override
  State<_NoteArea> createState() => _NoteAreaState();
}
class _NoteAreaState extends State<_NoteArea> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _isAdded = false;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  void addNote(String noteStr) {
    widget.addedNote(noteStr);
  }
  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(
                color: Colors.grey,
                height: 2.5,
              ),
              SizedBox(height: device.height * .05),
              const Text(
                'Not Ekle',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontTheme.fontFamily,
                  fontSize: FontTheme.xlfontSize,
                  fontWeight: FontTheme.xfontWeight
                ),
              ),
              Form( 
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _controller, 
                      hintText: 'Not Ekle', 
                      prefixIcon: const Icon(Icons.note_add_rounded), 
                      hasSuffixIcon: false, 
                      inputAction: TextInputAction.done, 
                      autoFillHints: const [], 
                      textInputType: TextInputType.text
                    ),
                    SizedBox(height: device.height * .015),
                    _isAdded ? const Text(
                      'Not Eklendi',
                      style: TextStyle(
                        fontFamily: FontTheme.fontFamily,
                        fontSize: FontTheme.nbfontSize,
                        fontWeight: FontTheme.rfontWeight,
                        color: FontTheme.greenColor
                      ),
                    ) : const SizedBox.shrink(),
                    SizedBox(height: device.height * .015),
                    CustomButton(
                      buttonText: 'Notu Kaydet', 
                      foregroundColor: Colors.white, 
                      backgroundColor: Colors.black, 
                      borderRadius: BorderRadius.circular(5), 
                      horizontalPadding: 40, 
                      verticalPadding: 20, 
                      fontSize: FontTheme.fontSize, 
                      onPressed: () async{
                        if (_formKey.currentState!.validate() && _controller.text.isNotEmpty) {
                          setState(() {
                            _controller.clear();
                            _isAdded = true;
                          });
                          addNote(_controller.text);
                          return true;
                        }else{
                          setState(() {
                            _isAdded = false;
                          });
                          return false;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
