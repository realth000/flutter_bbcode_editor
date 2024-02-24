enum BBCodeFileType {
  documentJson,
  markdown,
  html,
  delta,
}

extension GetExtension on BBCodeFileType {
  String get extension {
    switch (this) {
      case BBCodeFileType.documentJson:
      case BBCodeFileType.delta:
        return 'json';
      case BBCodeFileType.markdown:
        return 'md';
      case BBCodeFileType.html:
        return 'html';
    }
  }
}
