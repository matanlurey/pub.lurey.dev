// Uncomment a line below to see the diagnostics caught by the lint rules.

// Ignore this to make the example more readable.
// ignore_for_file: unused_local_variable

void main() {
  // Strict analysis options
  {
    final notAnInt = ':)' as dynamic;
    // int definitelyAnInt = notAnInt;
    // var oopsListOfDynamic = [];
    // List anotherOopsListOfDynamic = [];
  }
}
