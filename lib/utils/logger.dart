import 'package:logger/logger.dart';
import 'package:flutter/services.dart';

const platform = MethodChannel('logger');

class Printer extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    //final source = _getCallerFrame();
    return [event.message];
  }

  String? _getCallerFrame() {
    try {
      final trace = StackTrace.current.toString().split('\n');

      // Skip the first few frames to get to the actual caller
      final frame = trace.firstWhere(
            (line) =>
        line.contains('package:') &&
            !line.contains('logger.dart') &&
            !line.contains('CustomPrinter'),
        orElse: () => '',
      );

      final match = RegExp(r'#\d+\s+(.*)\s+\((.*?):(\d+):\d+\)').firstMatch(frame);
      if (match != null) {
        final method = match.group(1);
        final file = match.group(2);
        final line = match.group(3);
        return "$file:$line";
      }
    } catch (_) {}
    return null;
  }
}

class PlatformOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      platform.invokeMethod('log', {
        'level': event.level.name,
        'message': line,
      });
    }
  }
}

final logger = Logger(
  printer: Printer(),
  output: PlatformOutput(),
);