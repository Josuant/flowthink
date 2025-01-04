import 'package:logger/logger.dart';

class FlowLogger {
  static final Logger _logger = Logger(
    printer:
        PrettyPrinter(), // Cambia a SimplePrinter() para entornos de producción.
  );

  static void info(String message) {
    _logger.i(message);
  }

  static void warning(String message) {
    _logger.w(message);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error, stackTrace);
  }

  static void debug(String message) {
    _logger.d(message);
  }

  static void verbose(String message) {
    _logger.v(message);
  }
}
