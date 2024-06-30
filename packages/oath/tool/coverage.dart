#!/usr/bin/env dart

import 'package:oath/tools/coverage.dart';

void main() async {
  await runCoverage(mode: CoverageMode.preview);
}
