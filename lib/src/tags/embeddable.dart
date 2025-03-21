import 'package:flutter_quill/flutter_quill.dart';

/// Base class of all embed types used in editor.
abstract class BBCodeEmbeddable extends Embeddable {
  /// Constructor.
  BBCodeEmbeddable({required String type, required String data}) : super(type, data);

  @override
  Map<String, dynamic> toJson() => {type: data};
}
