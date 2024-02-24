enum ExportFileType {
  documentJson,
  markdown,
  html,
  delta,
}

extension GetExtension on ExportFileType {
  String get extension {
    switch (this) {
      case ExportFileType.documentJson:
      case ExportFileType.delta:
        return 'json';
      case ExportFileType.markdown:
        return 'md';
      case ExportFileType.html:
        return 'html';
    }
  }
}
