import 'package:codingo/product/theme/font_theme.dart';
import 'package:flutter/material.dart';

Future<dynamic> messageAlert(BuildContext context, String errorText) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                'Hata Mesajı',
                style: TextStyle(
                  fontFamily: FontTheme.fontFamily,
                  fontWeight: FontTheme.xfontWeight,
                  fontSize: FontTheme.bfontSize
                ),
            ),
            content: Text(
              'Hata Sebebi : $errorText',
              style: const TextStyle(
                  fontFamily: FontTheme.fontFamily,
                  fontWeight: FontTheme.rfontWeight,
                  fontSize: FontTheme.nbfontSize
                ),
              ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Kapat',
                  style: TextStyle(
                    fontFamily: FontTheme.fontFamily,
                    fontWeight: FontTheme.xfontWeight,
                    fontSize: FontTheme.fontSize
                  ),

                ),
              ),
            ],
          );
      });
  }