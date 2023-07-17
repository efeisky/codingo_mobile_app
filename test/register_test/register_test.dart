
import 'package:codingo/product/model/json_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    SchoolModel model = SchoolModel();

    await model.getSchoolList('ADIYAMAN', '2');
  });
}
