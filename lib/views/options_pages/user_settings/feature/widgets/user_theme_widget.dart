import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/button/custom_button.dart';
import 'package:codingo/product/widgets/custom_text_field.dart';
import 'package:codingo/views/options_pages/user_settings/model/user_setting_model.dart';
import 'package:flutter/material.dart';

class UserThemeWidget extends StatefulWidget {
  const UserThemeWidget({super.key, required this.model, required this.onTap});
  final UserSettingModel model;
  final Future<void> Function(String title, String content) onTap;
  @override
  State<UserThemeWidget> createState() => _UserThemeWidgetState();
}

class _UserThemeWidgetState extends State<UserThemeWidget> {

  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.model.biographyTitle);
    _contentController = TextEditingController(text: widget.model.biographyContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    const sizedBox = SizedBox(height: 20,);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: device.width * .05, vertical: device.height *.025),
      child: Column(
        children: [
            _headerText(),
            Column(
              children: [
                _contentText('Biyografi Başlığı', device.width),
                CustomTextField(
                  controller: _titleController, 
                  hintText: 'Biyografi Başlığı',
                  prefixIcon: const Icon(Icons.title_rounded), 
                  hasSuffixIcon: false, 
                  inputAction: TextInputAction.next, 
                  autoFillHints: const [], 
                  textInputType: TextInputType.text
                ),
                _contentText('Biyografi İçeriği', device.width),
                TextFormField(
                  controller: _contentController,
                  maxLines: 5,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _InfoTheme.borderColor,
                      ),
                      borderRadius: _InfoTheme.borderRadius
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _InfoTheme.focusBorderColor,
                      ),
                      borderRadius: _InfoTheme.borderRadius,
                    ),
                    labelStyle: TextStyle(
                      fontFamily: FontTheme.fontFamily,
                      fontWeight: FontTheme.xfontWeight,
                      fontSize: FontTheme.fontSize,
                      color: Colors.black,
                    ),
                  ),
                ),
                sizedBox,
                CustomButton(
                  buttonText: 'Değişiklikleri Kaydet', 
                  foregroundColor: Colors.white, 
                  backgroundColor: Colors.black, 
                  borderRadius: BorderRadius.circular(20), 
                  horizontalPadding: 35, 
                  verticalPadding: 20, 
                  fontSize: 16, 
                  onPressed: () async{
                    widget.onTap(_titleController.text, _contentController.text);
                    return true;
                  },
                )
              ],
            )
        ],
      ),
    );
  }

  Padding _contentText(String text, double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: width,
        child: Text(
          text,
          style: const TextStyle(
            color: _InfoTheme.infoColor,
            fontFamily: FontTheme.fontFamily,
            fontSize: FontTheme.bfontSize
          ),
        ),
      ),
    );
  }

  Text _headerText() {
    return const Text(
      'Tema Bilgileri',
      style: TextStyle(
        fontFamily: FontTheme.fontFamily,
        fontSize: FontTheme.nbfontSize,
        fontWeight: FontTheme.xfontWeight,
        color: _InfoTheme.contentColor
      ),
    );
  }

}
class _InfoTheme {
  static const Color infoColor = Color(0xFF4285F4);
  static const Color contentColor = Colors.black;
  static const Color borderColor = Color.fromRGBO(242, 242, 242, 1);
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(5));
  static const Color focusBorderColor = Color.fromRGBO(204, 204, 204, 1);
}