import '../src/naive_grid.dart';

import '../src/suites/mutable_growable.dart';
import '../src/suites/mutable_in_place.dart';
import '../src/suites/read.dart';

void main() {
  runGrowableTestSuite(NaiveListGrid.fromRows);
  runReadOnlyTestSuite(NaiveListGrid.fromRows);
  runMutableInPlaceTestSuite(NaiveListGrid.fromRows);
}
