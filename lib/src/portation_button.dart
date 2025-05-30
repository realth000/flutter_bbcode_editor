import 'dart:convert';
import 'dart:io';

import 'package:dart_bbcode_parser/dart_bbcode_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_quill/flutter_quill.dart';

extension _DateTimeExt on DateTime {
  /// Format [DateTime] to format yyyy-MM-DD hh:mm:ss
  String yyyyMMDDHHMMSS() {
    return '$year${month.toString().padLeft(2, '0')}'
        '${day.toString().padLeft(2, '0')}${hour.toString().padLeft(2, '0')}'
        '${minute.toString().padLeft(2, '0')}'
        '${second.toString().padLeft(2, '0')}';
  }
}

Future<String?> _importFile(BuildContext context, List<String> exts) async {
  final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: exts);
  if (result == null) {
    return null;
  }
  return File(result.files.single.path!).readAsString();
}

Future<void> _exportFile(BuildContext context, String prefix, String ext, String data) async {
  final result = await FilePicker.platform.saveFile(
    dialogTitle: context.bbcodeL10n.portationSelectDirectory,
    fileName: '$prefix${DateTime.now().yyyyMMDDHHMMSS()}.$ext',
    bytes: Uint8List.fromList(utf8.encode(data)),
  );
  if (result == null) {
    return;
  }
  await File(result).writeAsString(data);
}

void _showCopiedSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.bbcodeL10n.portationCopiedToClipboard)));
}

void _showInvalidQuillDeltaSnackBar(BuildContext context) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(context.bbcodeL10n.portationImportQuillDeltaFailed)));
}

void _showInvalidBBCodeSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.bbcodeL10n.portationImportBBCodeFailed)));
}

/// Open a modal bottom sheet to export or import document.
Future<void> openPortationModalBottomSheet(BuildContext context, BBCodeEditorController controller) async =>
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.only(left: 12, top: 4, right: 12, bottom: 12),
          child: Column(
            children: [
              const SizedBox(width: 12, height: 12),
              Text(context.bbcodeL10n.portationTitle, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(width: 12, height: 12),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text(context.bbcodeL10n.portationCopyBBCode),
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: controller.toBBCode()));
                        if (!context.mounted) {
                          return;
                        }
                        _showCopiedSnackBar(context);
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: Text(context.bbcodeL10n.portationExportBBCode),
                      onTap: () async {
                        await _exportFile(context, 'bbcode_', 'txt', controller.toBBCode());
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: Text(context.bbcodeL10n.portationImportBBCode),
                      onTap: () async {
                        final data = await _importFile(context, ['txt']);
                        if (data == null) {
                          return;
                        }
                        if (!context.mounted) {
                          return;
                        }
                        try {
                          final delta = parseBBCodeTextToDelta(data);
                          controller.setDocumentFromDelta(delta);
                        } on Exception catch (e, _) {
                          _showInvalidBBCodeSnackBar(context);
                          // Here we can not log it, so rethrow.
                          rethrow;
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: Text(context.bbcodeL10n.portationCopyQuillDelta),
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: controller.toQuillDelta()));
                        if (!context.mounted) {
                          return;
                        }
                        _showCopiedSnackBar(context);
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: Text(context.bbcodeL10n.portationExportQuillDelta),
                      onTap: () async {
                        await _exportFile(context, 'quilldata_', 'json', controller.toQuillDelta());
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: Text(context.bbcodeL10n.portationImportQuillDelta),
                      onTap: () async {
                        final data = await _importFile(context, ['json']);
                        if (data == null) {
                          return;
                        }
                        if (!context.mounted) {
                          return;
                        }

                        try {
                          controller.setDocumentFromJson(jsonDecode(data) as List<dynamic>);
                        } on Exception catch (e, _) {
                          _showInvalidQuillDeltaSnackBar(context);
                          // Here we can not log it, so rethrow.
                          rethrow;
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

/// Button to export and export data stored in controller.
class BBCodePortationButtonOptions extends QuillToolbarCustomButtonOptions {
  /// Constructor.
  const BBCodePortationButtonOptions({
    required super.onPressed,
    super.icon = const Icon(Icons.import_export_outlined),
    super.tooltip,
  });
}
