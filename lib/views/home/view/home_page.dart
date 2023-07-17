import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with NavigatorMixin {

  final String _mainTitle = 'Codingo';
  final String _changeableTitle = 'Ana Menü ~ Hoş geldin';
  final String _elevatedButtonText = 'Üye Ol';
  final String _textButtonText = 'Giriş Yap';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        mainTitle: _mainTitle,
        changeableTitle: _changeableTitle,
      ),
      body: Column(
        crossAxisAlignment: _HomepageTheme.crossAxisAlignment,
        mainAxisAlignment: _HomepageTheme.mainAxisAlignment,
        children: [
          Center(child: ImagePaths.greeting.toWidget(height: 200)),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                    router.pushReplacementToPage(NavigatorRoutesPaths.register);
                },
                
                style: ElevatedButton.styleFrom(
                  padding: _HomepageTheme.buttonPadding,
                  shape: RoundedRectangleBorder(borderRadius: _HomepageTheme.buttonRadius),
                  backgroundColor: _HomepageTheme.buttonBgColor,
                  elevation: _HomepageTheme.buttonElevation
                ), 
                
                child: Text(
                  _elevatedButtonText,
                  style: const TextStyle(
                    fontSize: _HomepageTheme.buttonFontSize,
                    fontFamily: _HomepageTheme.fontFamily
                  ),
                ),

              ),
              const SizedBox(
                height: _HomepageTheme.whiteSpace,
              ),
              TextButton(
                onPressed: () {
                    router.pushReplacementToPage(NavigatorRoutesPaths.login);
                },
                
                style: TextButton.styleFrom(
                  padding: _HomepageTheme.buttonPadding,
                  shape: RoundedRectangleBorder(borderRadius: _HomepageTheme.buttonRadius),
                ), 
                
                child: Text(
                  _textButtonText,
                  style: const TextStyle(
                    fontSize: _HomepageTheme.buttonFontSize,
                    fontFamily: _HomepageTheme.fontFamily,
                    decoration: TextDecoration.underline,
                    color: _HomepageTheme.fontColor
                  ),
                ),
                
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _HomepageTheme {
  static const CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center;
  static const MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceAround;

  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 80,vertical: 20);
  static final BorderRadius buttonRadius = BorderRadius.circular(25);
  static const Color buttonBgColor = Color.fromRGBO(66, 133, 244, 1);
  static const Color fontColor = Color.fromRGBO(54, 113, 211, 1);
  static const double buttonElevation = 0;
  static const double buttonFontSize = 18;
  static const double whiteSpace = 25;

  static const String fontFamily = 'Inter';

}