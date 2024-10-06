/// An artisnal hand-crafted interopability library for the web platform.
///
/// This library intentionally does not import any non-SDK library (i.e.
/// `package:web`), and insists on tight control and testing coverage of the
/// interop layer whenever possible. For a more complete implementation of the
/// web platform, consider using [`package:web`](https://pub.dev/packages/web)
/// instead.
///
/// References:
/// - <https://dart.dev/interop/js-interop>
/// - <https://developer.mozilla.org/en-US/docs/Web/API>
/// - <https://web.dev>
library;

import 'dart:async';
import 'dart:collection';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

part 'src/utils/_unmodifiable_list.dart';

part 'src/core/abort_controller.dart';
part 'src/core/abort_signal.dart';
part 'src/core/async_iterator.dart';
part 'src/core/event_target.dart';
part 'src/core/event.dart';
part 'src/core/progress_event.dart';

part 'src/data/blob.dart';
part 'src/data/data_transfer_item_kind.dart';
part 'src/data/data_transfer_item_list.dart';
part 'src/data/data_transfer_item.dart';
part 'src/data/data_transfer.dart';

part 'src/dom/character_data.dart';
part 'src/dom/document.dart';
part 'src/dom/element.dart';

part 'src/files/file_list.dart';
part 'src/files/file_reader_ready_state.dart';
part 'src/files/file_reader.dart';
part 'src/files/file_system_directory_handle.dart';
part 'src/files/file_system_file_handle.dart';
part 'src/files/file_system_handle_kind.dart';
part 'src/files/file_system_handle.dart';
part 'src/files/file_system_writable_file_stream.dart';
part 'src/files/file.dart';

part 'src/dom/html_element.dart';
part 'src/dom/html_input_element.dart';
part 'src/dom/navigator.dart';
part 'src/dom/node_list.dart';
part 'src/dom/node.dart';

part 'src/data/readable_stream_default_reader.dart';
part 'src/data/readable_stream.dart';
part 'src/data/storage_manager.dart';

part 'src/dom/text.dart';
part 'src/dom/window.dart';
part 'src/data/writable_stream_default_writer.dart';
part 'src/data/writable_stream.dart';

/// Current window object.
@JS()
external Window get window;
