import 'package:flutter_udid/flutter_udid.dart';

Future<String> getDeviceUniqueId() async {
    String uniqueId = await FlutterUdid.consistentUdid;
    return uniqueId;
}