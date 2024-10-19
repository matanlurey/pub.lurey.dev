import 'package:strink/strink.dart';

/// Generates a GitHub Actions workflow file for a package.
String generateGithubPackageWorkflow({
  required String package,
  required bool usesChrome,
  required bool uploadCoverage,
}) {
  final buffer = StringBuffer();
  final writer = YamlSink(buffer);

  writer.writeKeyValue('name', 'package/$package');
  writer.writeNewline();

  writer.startObjectOrList('on');
  writer.writeComment('Post-submit.');
  writer.startObjectOrList('push');
  writer.writeKeyValue('branches', '[ main ]');
  writer.endObjectOrList();
  writer.writeNewline();
  writer.writeComment('Pre-submit.');
  writer.startObjectOrList('pull_request');
  writer.writeKeyValue('branches', '[ main ]');
  writer.startObjectOrList('paths');
  writer.writeListValue('.github/workflows/package_$package.yaml');
  writer.writeListValue('packages/$package/**');
  writer.endObjectOrList();
  writer.endObjectOrList();
  writer.endObjectOrList();

  writer.writeNewline();
  writer.startObjectOrList('jobs');
  writer.startObjectOrList('build');
  writer.writeKeyValue('runs-on', 'ubuntu-latest');

  writer.startObjectOrList('steps');
  writer.writeListValue('uses: actions/checkout@v4.2.0');
  writer.writeListValue('uses: dart-lang/setup-dart@v1.6.5');
  if (usesChrome) {
    writer.writeListValue('uses: browser-actions/setup-chrome@v1.7.2');
  }
  writer.writeListObject('run', 'dart pub get');
  writer.writeKeyValue('working-directory', 'packages/$package');
  writer.endObjectOrList();

  writer.writeListValue('run: ./dev.sh check --packages packages/$package');
  writer.writeListValue('run: ./dev.sh test --packages packages/$package');

  if (uploadCoverage) {
    writer.writeListValue(
      'run: ./dev.sh coverage --packages packages/$package',
    );
    writer.writeListObject(
      'uses',
      'codecov/codecov-action@v4.6.0',
    );
    writer.startObjectOrList('with');
    writer.writeKeyValue('token', r'${{ secrets.CODECOV_TOKEN }}');
    writer.writeKeyValue('flags', package);
    writer.writeKeyValue('file', 'packages/$package/coverage/lcov.info');
    writer.writeKeyValue('fail_ci_if_error', 'true');
    writer.endObjectOrList();
    writer.endObjectOrList();
  }

  return buffer.toString();
}
