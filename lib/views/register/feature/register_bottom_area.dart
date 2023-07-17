import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/button/custom_icon_button.dart';
import 'package:codingo/views/register/feature/theme/register_theme.dart';
import 'package:flutter/material.dart';

class BottomArea extends StatefulWidget {
  const BottomArea({
    Key? key, required this.currentPageNo, required this.onTap, required this.buttonText, required this.buttonIcon,
  }) : super(key: key);
  final Future<void> Function() onTap;
  final int currentPageNo;
  final String buttonText;
  final Icon buttonIcon;

  @override
  State<BottomArea> createState() => _BottomAreaState();
}

class _BottomAreaState extends State<BottomArea> {
  bool _isLoading = false;
  void _changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        widget.currentPageNo != 0 ?
        RichText(
          text: TextSpan(
            text: '${widget.currentPageNo}',
            style: const TextStyle(
              color: RegisterTheme.sColor,
              fontSize: FontTheme.xlfontSize,
              fontFamily: FontTheme.fontFamily,
              fontWeight: FontTheme.xfontWeight
            ),
            children: const [
              TextSpan(
                text: ' / 2',
                style: TextStyle(
                  color: RegisterTheme.dColor,
                  fontSize: FontTheme.nbfontSize,
                ),
              ),
            ],
          ),
        ) : const SizedBox.shrink(),

        CustomIconButton(
          iconType: _isLoading ? const CircularProgressIndicator(color: RegisterTheme.buttonFgColor,) : widget.buttonIcon,
          buttonText: widget.buttonText, 
          foregroundColor: RegisterTheme.buttonFgColor, 
          backgroundColor: RegisterTheme.buttonBgColor, 
          borderRadius: RegisterTheme.buttonRadius,
          horizontalPadding: RegisterTheme.buttonHPadding, 
          verticalPadding: RegisterTheme.buttonVPadding, 
          fontSize: FontTheme.nbfontSize, 
          onPressed: () async{
            _changeLoading();
            await widget.onTap();
            _changeLoading();
            return true;
          },
        )
    ],),
  );
}
