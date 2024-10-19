import 'package:chore/chore.dart';

/// Generates a region of a package's README file.
String generatePackageReadmeRegion(Package package) {
  final buffer = StringBuffer();
  buffer.writeln('# `${package.name}`\n');
  buffer.writeln('${package.description}\n');

  // Table header.
  buffer.writeln('| ✅ Health | 🚀 Release | 📝 Docs | ♻️ Maintenance |');
  buffer.writeln('|:----------|:-----------|:--------|:--------------|');

  // Build status.
  buffer.write('| ');
  buffer.write(_generateBuildStatus(package.name));

  // Release status.
  buffer.write(' | ');
  if (package.isPublishable) {
    buffer.write(_generatePubStatus(package.name));
  } else {
    buffer.write('Unreleased');
  }

  // Documentation status.
  buffer.write(' | ');
  if (package.isPublishable) {
    buffer.write(_generateDartDocs(package.name));
  } else {
    buffer.write('Unreleased');
  }

  // Maintenance status.
  buffer.write(' | ');
  buffer.write(_githubIssues(package.name));
  buffer.write(' |');

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

/// Generates a contributing section for a package's README file.
String generatePackageContributingSection(Package package) {
  final buffer = StringBuffer();
  buffer.writeln('## Contributing\n');
  if (!package.isPublishable) {
    buffer.writeln(
      'This is an experimental package that is **not intended for general use**.\n'
      '\n'
      'Please [file an issue][] if changes to this package are desired.\n'
      '\n'
      '[file an issue]: https://github.com/matanlurey/pub.lurey.dev/issues/new',
    );
  } else {
    buffer.writeln(
      'We welcome contributions to this package!\n'
      '\n'
      'Please [file an issue][] before contributing larger changes.\n'
      '\n'
      '[file an issue]: https://github.com/matanlurey/pub.lurey.dev/issues/new?labels=pkg-${package.name}'
      '\n\n'
      'This package uses repository specific tooling to enforce formatting, '
      'static analysis, and testing. Please run the following commands locally '
      'before submitting a pull request:\n'
      '\n'
      '- `./dev.sh --packages packages/${package.name} check `\n'
      '- `./dev.sh --packages packages/${package.name} test `\n',
    );
  }
  return buffer.toString();
}
