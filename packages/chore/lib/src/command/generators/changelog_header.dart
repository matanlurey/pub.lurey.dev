/// Generates the header for the `CHANEGLOG.md` file.
String generateChangelogHeader() {
  final buffer = StringBuffer();

  /*
  All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
  */

  buffer.writeln('# Changelog');
  buffer.writeln();
  buffer.writeln(
    'All notable changes to this project will be documented in this file.',
  );
  buffer.writeln();
  buffer.writeln(
    'The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),',
  );
  buffer.writeln(
    'and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).',
  );

  return buffer.toString();
}
