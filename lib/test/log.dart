import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Logger {
  static File? _logFile;

  static Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    _logFile = File('${dir.path}/app_debug.log');
  }

  static void log(String message) {
    final now = DateTime.now().toIso8601String();
    final logMessage = '[$now] $message\n';
    _logFile?.writeAsStringSync(logMessage, mode: FileMode.append);
  }
}
