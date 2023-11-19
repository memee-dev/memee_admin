import 'package:logger/logger.dart';

class _Log {
  final _logger = Logger();

  void t(message) => _logger.t(message);
  void d(message) => _logger.d(message);
  void i(message) => _logger.i(message);
  void w(message) => _logger.w(message);
  void e(message, {dynamic error}) => _logger.e(message, error: error);
  void f(message, {DateTime? time, Object? error, StackTrace? stackTrace}) =>
      _logger.f(message, error: error, stackTrace: stackTrace);
}

final log = _Log();
