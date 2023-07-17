import 'package:codingo/views/options_pages/user_settings/service/user_setting_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Get Setting Values', (WidgetTester tester) async {
    UserSettingService service = UserSettingService();

    await service.getSetting('se');
  });
}
