# Change Log

## 0.2.0

**BREAKING CHANGE**: `library.yaml` was renmed to `strict.yaml`, and ...

Removed the following lint rules:

- [`avoid_types_on_closure_parameters`](https://dart.dev/tools/linter-rules/avoid_types_on_closure_parameters):
  Too many false positives.
- [`cascade_invocations`](https://dart.dev/tools/linter-rules/cascade_invocations):
  Too prescriptive, separate lines can be useful for readability.
- [`cast_nullable_to_non_nullable`](https://dart.dev/tools/linter-rules/cast_nullable_to_non_nullable):
  Could be useful as a code review hint, but too verbose for a lint.
- [`one_member_abstracts`](https://dart.dev/tools/linter-rules/one_member_abstracts):
  Avoiding unnecessary classes is good design guidance, but not as a lint.

Added the following lints:

- [`comment_references`](https://dart.dev/tools/linter-rules/comment_references):
  Enforces that all references in comments are valid. There are some false
  positives between this and what `dartdoc` supports, but it's probably worth
  ignoring those versus not knowing if a reference is valid.
- [`missing_code_block_language_in_doc_comment`](https://dart.dev/tools/linter-rules/missing_code_block_language_in_doc_comment):
  Useful for ensuring that code blocks are syntax highlighted.
- [`unnecessary_library_name`](https://dart.dev/tools/linter-rules/unnecessary_library_name):
  There are no benefits to having a library name in modern Dart.

**BREAKING CHANGE**: `application.yaml` was renamed to `relaxed.yaml`, and ...

Removed the following lints:

- [`avoid_redundant_argument_values`](https://dart.dev/tools/linter-rules/avoid_redundant_argument_values):
  Causes a lot of churn for little benefit.
- [`unnecessary_raw_strings`](https://dart.dev/tools/linter-rules/unnecessary_raw_strings):
  Too prescriptive, raw strings can be useful for readability.

## 0.1.1

Added a new set, `package:oath/flutter/*.yaml`, for Flutter packages.

```yaml
# analysis_options.yaml

# Strict set of lints and analysis options.
include: package:oath/flutter/library.yaml

# Relaxed set of lints and analysis options.
include: package:oath/flutter/application.yaml
```

## 0.1.0

Initial release, with two sets of lints:

```yaml
# analysis_options.yaml

# Strict set of lints and analysis options.
include: package:oath/library.yaml
```

Or, for a slightly relaxed set for applications:

```yaml
# Relaxed set of lints and analysis options.
include: package:oath/application.yaml
```
