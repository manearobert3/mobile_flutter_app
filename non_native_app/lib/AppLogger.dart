import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  static void d(String message) {
    _logger.d(message);  // Debug log
  }

  static void i(String message) {
    _logger.i(message);  // Info log
  }

  static void w(String message) {
    _logger.w(message);  // Warning log
  }

  static void e(String message) {
    _logger.e(message);  // Error log
  }
}
