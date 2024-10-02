/// Exception thrown when a process fails to execute.
final class ProcessException implements Exception {
  /// Create a new process exception.
  ProcessException({
    required this.executable,
    required this.arguments,
    required this.workingDirectory,
    this.message = '',
    this.errorCode = 0,
  });

  /// The executable provided for the process.
  final String executable;

  /// The arguments provided for the process.
  final List<String> arguments;

  /// The working directory for the process.
  final String workingDirectory;

  /// The system message for the process exception, if any.
  final String message;

  /// The error code for the process exception, if any.
  final int errorCode;

  @override
  String toString() {
    final buffer = StringBuffer('ProcessException: ($errorCode)');
    if (message.isNotEmpty) {
      buffer.write(' $message');
    }
    buffer.write('\n  Command: $executable');
    if (arguments.isNotEmpty) {
      buffer.write(' ');
      buffer.writeAll(arguments, ' ');
      buffer.writeln();
    }
    buffer.write('  Working directory: $workingDirectory');
    return buffer.toString();
  }
}
