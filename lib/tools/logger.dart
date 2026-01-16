import 'dart:async';

class Logger {
  static final Logger _instance = Logger._internal();
  factory Logger() => _instance;

  Logger._internal();

  final List<String> _logs = [];
  final StreamController<List<String>> _logStreamController = StreamController<List<String>>.broadcast();

  Stream<List<String>> get logStream => _logStreamController.stream;

  void log(String message) {
    final timestamp = DateTime.now().toString();
    final logEntry = '$timestamp: $message';
    _logs.add(logEntry);
    _logStreamController.add(_logs);
    print(logEntry); // 同时输出到控制台
  }

  List<String> get logs => List.unmodifiable(_logs);

  void clear() {
    _logs.clear();
    _logStreamController.add(_logs);
  }
}

// 全局日志实例
final logger = Logger();
