// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:developer';

import 'package:codingo/views/user_home/service/user_home_service.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // final LessonService service = LessonService();

    // await service.getLessonQuestions('a', LessonEnum.math, '', 2, '');

    final UserHomeService service = UserHomeService();

    final value = await service.getUserValues('se');

    inspect(value);
    print(value);
  });
}
