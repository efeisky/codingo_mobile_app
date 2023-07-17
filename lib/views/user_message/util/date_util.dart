import 'package:intl/intl.dart';

String getTime() {
  DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);
}