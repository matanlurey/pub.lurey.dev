import 'package:dev/src/sinks/yaml_sink.dart';

/// Generates a GitHub Actions workflow file for a package.
String generateGithubPackageWorkflow({
  required String package,
  required bool usesChrome,
  required bool uploadCoverage,
}) {
  final buffer = StringBuffer();
  final writer = YamlSink.fromSink(buffer);

  writer.writeKeyValue('name', 'package/$package');
  writer.writeNewline();

  writer.writeKey('on');
  writer.indent();
  writer.writeComment('Post-submit.');
  writer.writeKey('push');
  writer.indent();
  writer.writeKeyValue('branches', '[ main ]');
  writer.unindent();
  writer.writeNewline();
  writer.writeComment('Pre-submit.');
  writer.writeKey('pull_request');
  writer.indent();
  writer.writeKeyValue('branches', '[ main ]');
  writer.writeKey('paths');
  writer.indent();
  writer.writeListValue('.github/workflows/package_$package.yaml');
  writer.writeListValue('packages/$package/**');
  writer.unindent();
  writer.unindent();
  writer.unindent();

  writer.writeNewline();
  writer.writeKey('jobs');
  writer.indent();
  writer.writeKey('build');
  writer.indent();
  writer.writeKeyValue('runs-on', 'ubuntu-latest');

  writer.writeKey('steps');
  writer.indent();
  writer.writeListValue('uses: actions/checkout@v4.2.0');
  writer.writeListValue('uses: dart-lang/setup-dart@v1.6.5');
  if (usesChrome) {
    writer.writeListValue('uses: browser-actions/setup-chrome@v1.7.2');
  }
  writer.writeListValue('run: dart pub get');
  writer.indent();
  writer.writeKeyValue('working-directory', 'packages/$package');
  writer.unindent();

  writer.writeListValue('run: ./dev.sh check --packages packages/$package');
  writer.writeListValue('run: ./dev.sh test --packages packages/$package');
  writer.writeListValue('run: ./dev.sh coverage --packages packages/$package');

  if (uploadCoverage) {
    writer.writeListValue('uses: codecov/codecov-action@v4.6.0');
    writer.indent();
    writer.writeKey('with');
    writer.indent();
    writer.writeKeyValue('token', r'${{ secrets.CODECOV_TOKEN }}');
    writer.writeKeyValue('flags', package);
    writer.writeKeyValue('file', 'packages/$package/coverage/lcov.info');
    writer.writeKeyValue('fail_ci_if_error', 'true');
    writer.unindent();
    writer.unindent();
  }

  return buffer.toString();
}
