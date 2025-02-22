import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:webby/webby.dart';

import '_prelude.dart';

void main() {
  test('FileList', () {
    final input = HTMLInputElement(type: 'file', multiple: true);

    final data = DataTransfer();
    final file = File(
      [BlobPart.fromString('Hello World'.toJS)].toJS,
      'file.txt'.toJS,
    );

    data.items.addFile(file);

    // Patch the input element.
    input['files'] = data.files;

    check(input.files).has((a) => a.length, 'length').equals(1);
    final item = input.files.item(0);

    check(item)
      ..has((a) => a.name, 'name').equals('file.txt')
      ..has((a) => a.size, 'size').equalsInt(11);
  });
}
