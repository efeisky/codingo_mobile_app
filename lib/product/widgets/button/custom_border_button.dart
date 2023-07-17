import 'package:codingo/product/theme/font_theme.dart';
import 'package:flutter/material.dart';

class CustomBorderButton extends StatefulWidget {
  const CustomBorderButton({
    Key? key,
    required this.buttonText,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderRadius,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.fontSize,
    required this.onPressed,
  }) : super(key: key);

  final String buttonText;
  final Color foregroundColor;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final double horizontalPadding;
  final double verticalPadding;
  final double fontSize;
  final Future<bool> Function() onPressed;

  @override
  State<CustomBorderButton> createState() => _CustomBorderButtonState();
}

class _CustomBorderButtonState extends State<CustomBorderButton> {
  bool _isLoading = false;

  Future<void> _handlePressed() async {
    setState(() {
      _isLoading = true;
    });

    await widget.onPressed();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        side: BorderSide(
          color: widget.foregroundColor
        ),
        textStyle: TextStyle(
          fontFamily: FontTheme.fontFamily,
          fontSize: widget.fontSize,
        ),
        foregroundColor: widget.foregroundColor,
        backgroundColor: widget.backgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius,
        ),
      ),
      onPressed: _isLoading ? null : _handlePressed,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.horizontalPadding,
          vertical: widget.verticalPadding,
        ),
        child: _isLoading
            ? CircularProgressIndicator(color: widget.backgroundColor,)
            : Text(widget.buttonText),
      ),
    );
  }
}