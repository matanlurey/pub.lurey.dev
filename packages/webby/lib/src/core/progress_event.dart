part of '../../webby.dart';

/// Represents events measuring progress of an underlying process.
extension type ProgressEvent._(JSObject _) implements Event {
  /// Creates a new progress event of tyoe `loadstart`.
  factory ProgressEvent.loadStart({
    bool lengthComputable = false,
    int loaded = 0,
    int total = 0,
  }) {
    if (lengthComputable || loaded != 0 || total != 0) {
      return ProgressEvent._native(
        'loadstart'.toJS,
        _ProgressEventOptions(
          lengthComputable: lengthComputable.toJS,
          loaded: loaded.toJS,
          total: total.toJS,
        ),
      );
    }
    return ProgressEvent._native('loadstart'.toJS);
  }

  /// Creates a new progress event of tyoe `progress`.
  factory ProgressEvent.progress({
    bool lengthComputable = false,
    int loaded = 0,
    int total = 0,
  }) {
    return ProgressEvent._with(
      'progress',
      lengthComputable: lengthComputable,
      loaded: loaded,
      total: total,
    );
  }

  /// Creates a new progress event of tyoe `abort`.
  factory ProgressEvent.abort({
    bool lengthComputable = false,
    int loaded = 0,
    int total = 0,
  }) {
    return ProgressEvent._with(
      'abort',
      lengthComputable: lengthComputable,
      loaded: loaded,
      total: total,
    );
  }

  /// Creates a new progress event of tyoe `error`.
  factory ProgressEvent.error({
    bool lengthComputable = false,
    int loaded = 0,
    int total = 0,
  }) {
    return ProgressEvent._with(
      'error',
      lengthComputable: lengthComputable,
      loaded: loaded,
      total: total,
    );
  }

  /// Creates a new progress event of tyoe `load`.
  factory ProgressEvent.load({
    bool lengthComputable = false,
    int loaded = 0,
    int total = 0,
  }) {
    return ProgressEvent._with(
      'load',
      lengthComputable: lengthComputable,
      loaded: loaded,
      total: total,
    );
  }

  /// Creates a new progress event of tyoe `loadend`.
  factory ProgressEvent.loadEnd({
    bool lengthComputable = false,
    int loaded = 0,
    int total = 0,
  }) {
    return ProgressEvent._with(
      'loadend',
      lengthComputable: lengthComputable,
      loaded: loaded,
      total: total,
    );
  }

  /// Creates a new progress event of tyoe `timeout`.
  factory ProgressEvent.timeout({
    bool lengthComputable = false,
    int loaded = 0,
    int total = 0,
  }) {
    return ProgressEvent._with(
      'timeout',
      lengthComputable: lengthComputable,
      loaded: loaded,
      total: total,
    );
  }

  factory ProgressEvent._with(
    String type, {
    bool lengthComputable = false,
    int loaded = 0,
    int total = 0,
  }) {
    if (lengthComputable || loaded != 0 || total != 0) {
      return ProgressEvent._native(
        type.toJS,
        _ProgressEventOptions(
          lengthComputable: lengthComputable.toJS,
          loaded: loaded.toJS,
          total: total.toJS,
        ),
      );
    }
    return ProgressEvent._native(type.toJS);
  }

  external ProgressEvent._native(
    JSString type, [
    _ProgressEventOptions options,
  ]);

  /// Whether the length of the progress can be calculated or not.
  external JSBoolean get lengthComputable;

  /// The amount of work that has been loaded so far.
  external JSNumber get loaded;

  /// The total amount of work that will be loaded.
  external JSNumber get total;
}

extension type _ProgressEventOptions._(JSObject _) implements JSObject {
  external factory _ProgressEventOptions({
    JSBoolean lengthComputable,
    JSNumber loaded,
    JSNumber total,
  });
}
