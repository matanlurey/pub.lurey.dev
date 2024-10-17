import 'package:chore/chore.dart';

/// Generates a region of the root README file.
String generateRootReadmeRegion(Iterable<Package> packages) {
  final buffer = StringBuffer();
  buffer.writeln();

  buffer.writeln('| Project | Release | Description |');
  buffer.writeln('|:--------|:--------|:------------|');

  for (final package in packages) {
    buffer.write('| ');
    buffer.write(_generateRelativePath(package.name));
    buffer.write(' | ');
    if (package.isPublishable) {
      buffer.write(_generatePubStatus(package.name));
    } else {
      buffer.write('_Unreleased_');
    }
    buffer.write(' | ');
    buffer.write(package.shortDescription);
    buffer.writeln(' |');
  }

  return buffer.toString();
}

String _generateRelativePath(String package) {
  return '[`$package`](./packages/$package)';
}

String _generatePubStatus(String package) {
  return ''
      '[![Pub version for package/$package]'
      '(https://img.shields.io/pub/v/$package?label=%20)]'
      '(https://pub.dev/packages/$package)';
}
