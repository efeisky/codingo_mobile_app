import 'package:codingo/product/theme/font_theme.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatefulWidget {
  const CustomIconButton({
    super.key, 
    required this.buttonText, 
    required this.foregroundColor, 
    required this.backgroundColor, 
    required this.borderRadius, 
    required this.horizontalPadding, 
    required this.verticalPadding, 
    required this.fontSize, 
    required this.onPressed, 
    required this.iconType
    });

  final String buttonText;
  final Color foregroundColor;
  final Color backgroundColor;
  final Widget iconType;
  final BorderRadius borderRadius;
  final double horizontalPadding;
  final double verticalPadding;
  final double fontSize;
  final Future<bool> Function() onPressed;
  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
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
        child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.buttonText),
                const SizedBox(width: 20),
                _isLoading
                ? CircularProgressIndicator(color: widget.backgroundColor,)
                : widget.iconType
              ],
            ),
      ),
    );
  }
}