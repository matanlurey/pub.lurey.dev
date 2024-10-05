/// Run and manage OS processes with an extensible and testable API.
///
/// Most use cases of running processes are typically handled by importing and
/// using `dart:io` and using the `Process` class. However, the `proc` library
/// provides a more flexible and extensible API for running and managing
/// processes.
///
/// Features include:
///
/// - Setting default parameters for launching processes.
/// - Cross-platform APIs that do not require `dart:io`.
/// - Create and manage individual processes using [ProcessController].
/// - Emulate a file system like environment using [ExecutableContainer].
///
/// Use and create a [ProcessHost], which is a replacement for `dart:io`'s
/// `Process` class.
///
/// The `ProcessHost` class can start a new process or listen to signals to the
/// current process:
///
/// ```dart
/// import 'package:proc/proc.dart';
///
/// void main() async {
///   final host = ProcessHost();
///   host.watch(ProcessSignal.sigint).listen((signal) {
///     print('Received signal: $signal');
///   });
///   final process = await host.run('echo', ['Hello, World!']);
///   print('Process exited with code: ${await process.exitCode}');
/// }
/// ```
///
/// To emulate a process, use [ProcessController]:
///
/// ```dart
/// import 'package:proc/proc.dart';
///
/// void main() {
///   final controller = ProcessController();
///   controller.addStdoutLine('Hello, World!');
///   controller.complete(ExitCode.success);
///
///   // Use the controller to access the process.
///   final process = controller.process;
///
///   // ...
/// }
/// ```
///
/// Create a simulated [ProcessHost] using [ExecutableContainer], which stores
/// callbacks to execute programs:
///
/// ```dart
/// import 'package:proc/proc.dart';
///
/// void main() async {
///   final container = ExecutableContainer();
///   container.setExecutable('echo', (start) async {
///     late final ProcessController controller;
///     controller = ProcessController(
///       onInput: (data) {
///         controller.addStdoutBytes(data);
///       },
///     );
///     return controller.process;
///   });
/// }
/// ```
///
/// <!--
/// @docImport 'src/executable_container.dart';
/// @docImport 'src/process_controller.dart';
/// @docImport 'src/process_host.dart';
/// -->
library;

export 'src/executable_container.dart' show ExecutableContainer;
export 'src/exit_code.dart' show ExitCode;
export 'src/process.dart' show Process;
export 'src/process_controller.dart' show ProcessController;
export 'src/process_exception.dart' show ProcessException;
export 'src/process_host.dart' show ProcessHost;
export 'src/process_run_mode.dart' show ProcessRunMode;
export 'src/process_signal.dart' show ProcessSignal;
export 'src/process_sink.dart' show ProcessSink;
