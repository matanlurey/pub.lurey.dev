import 'package:dev/src/generators/root_readme.dart';

/// Generates a region of a package's README file.
String generatePackageReadmeRegion(Package package) {
  final buffer = StringBuffer();

  buffer.writeln(_generateBuildStatus(package.name));
  if (package.isPublishable) {
    buffer.writeln(_generatePubStatus(package.name));
    buffer.writeln(_generateDartDocs(package.name));
  }
  buffer.writeln(_githubIssues(package.name));

  return buffer.toString();
}

String _generateBuildStatus(String package) {
  return ''
      '[![Build status for package/$package]'
      '(https://github.com/matanlurey/pub.lurey.dev/actions/workflows/package_$package.yaml/badge.svg)]'
      '(https://github.com/matanlurey/pub.lurey.dev/actions/workflows/package_$package.yaml)';
}

String _generatePubStatus(String package) {
  return ''
      '[![Pub version for package/$package]'
      '(https://img.shields.io/pub/v/$package)]'
      '(https://pub.dev/packages/$package)';
}

String _generateDartDocs(String package) {
  return ''
      '[![Dart documentation for package/$package]'
      '(https://img.shields.io/badge/dartdoc-reference-blue.svg)]'
      '(https://pub.dev/documentation/$package)';
}

String _githubIssues(String package) {
  return ''
      '[![GitHub Issues for package/$package](https://img.shields.io/github/issues/matanlurey/pub.lurey.dev/pkg-$package?label=issues)]'
      '(https://github.com/matanlurey/pub.lurey.dev/issues?q=is%3Aopen+is%3Aissue+label%3Apkg-$package)';
}
