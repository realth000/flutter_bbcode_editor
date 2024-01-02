import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_state_manager.dart';
import 'formatting_toolbar.dart' show ToggleButtonsState;
import 'replacements.dart';

typedef InlineSpanBuilder = InlineSpan Function(String, TextStyle);

@immutable
class SpanGenerator {
  const SpanGenerator({
    required this.style,
    this.buildRecognizer,
  });

  TextSpan buildText(String text) {
    TextStyle s = style;
    if (buildRecognizer != null) {
      s = s.copyWith(color: Colors.blue);
    }

    return TextSpan(
      text: text,
      style: s,
      // recognizer: buildRecognizer?.call(text),
    );
  }

  final GestureRecognizer Function(String)? buildRecognizer;
  final TextStyle style;
}


class BBCodeEditorState {
  const BBCodeEditorState({
    required this.replacementsController,
    required this.textEditingDeltaHistory,
    required this.toggleButtonsState,
  });

  final BBCodeEditController replacementsController;
  final List<TextEditingDelta> textEditingDeltaHistory;
  final Set<ToggleButtonsState> toggleButtonsState;

  BBCodeEditorState copyWith({
    BBCodeEditController? replacementsController,
    List<TextEditingDelta>? textEditingDeltaHistory,
    Set<ToggleButtonsState>? toggleButtonsState,
  }) {
    return BBCodeEditorState(
      replacementsController:
          replacementsController ?? this.replacementsController,
      textEditingDeltaHistory:
          textEditingDeltaHistory ?? this.textEditingDeltaHistory,
      toggleButtonsState: toggleButtonsState ?? this.toggleButtonsState,
    );
  }
}

class BBCodeScopeWidget extends StatefulWidget {
  const BBCodeScopeWidget({super.key, required this.child});

  final Widget child;

  static BBCodeScopeWidgetState of(BuildContext context) {
    return context.findAncestorStateOfType<BBCodeScopeWidgetState>()!;
  }

  @override
  State<BBCodeScopeWidget> createState() => BBCodeScopeWidgetState();
}

class BBCodeScopeWidgetState extends State<BBCodeScopeWidget> {
  BBCodeEditorState _data = BBCodeEditorState(
    replacementsController: BBCodeEditController(
        text: 'The quick brown fox jumps over the lazy dog.'),
    textEditingDeltaHistory: <TextEditingDelta>[],
    toggleButtonsState: <ToggleButtonsState>{},
  );

  void updateTextEditingDeltaHistory(List<TextEditingDelta> textEditingDeltas) {
    _data = _data.copyWith(textEditingDeltaHistory: <TextEditingDelta>[
      ..._data.textEditingDeltaHistory,
      ...textEditingDeltas
    ]);
    setState(() {});
  }

  void updateToggleButtonsStateOnSelectionChanged(
      TextSelection selection, BBCodeEditController controller) {
    // When the selection changes we want to check the replacements at the new
    // selection. Enable/disable toggle buttons based on the replacements found
    // at the new selection.
    final List<TextStyle> replacementStyles =
        controller.getReplacementsAtSelection(selection);
    final Set<ToggleButtonsState> hasChanged = {};

    if (replacementStyles.isEmpty) {
      _data = _data.copyWith(
        toggleButtonsState: Set.from(_data.toggleButtonsState)
          ..removeAll({
            ToggleButtonsState.bold,
            ToggleButtonsState.italic,
            ToggleButtonsState.underline,
          }),
      );
    }

    for (final TextStyle style in replacementStyles) {
      // See [_updateToggleButtonsStateOnButtonPressed] for how
      // Bold, Italic and Underline are encoded into [style]
      if (style.fontWeight != null &&
          !hasChanged.contains(ToggleButtonsState.bold)) {
        _data = _data.copyWith(
          toggleButtonsState: Set.from(_data.toggleButtonsState)
            ..add(ToggleButtonsState.bold),
        );
        hasChanged.add(ToggleButtonsState.bold);
      }

      if (style.fontStyle != null &&
          !hasChanged.contains(ToggleButtonsState.italic)) {
        _data = _data.copyWith(
          toggleButtonsState: Set.from(_data.toggleButtonsState)
            ..add(ToggleButtonsState.italic),
        );
        hasChanged.add(ToggleButtonsState.italic);
      }

      if (style.decoration != null &&
          !hasChanged.contains(ToggleButtonsState.underline)) {
        _data = _data.copyWith(
          toggleButtonsState: Set.from(_data.toggleButtonsState)
            ..add(ToggleButtonsState.underline),
        );
        hasChanged.add(ToggleButtonsState.underline);
      }
    }

    for (final TextStyle style in replacementStyles) {
      if (style.fontWeight == null &&
          !hasChanged.contains(ToggleButtonsState.bold)) {
        _data = _data.copyWith(
          toggleButtonsState: Set.from(_data.toggleButtonsState)
            ..remove(ToggleButtonsState.bold),
        );
        hasChanged.add(ToggleButtonsState.bold);
      }

      if (style.fontStyle == null &&
          !hasChanged.contains(ToggleButtonsState.italic)) {
        _data = _data.copyWith(
          toggleButtonsState: Set.from(_data.toggleButtonsState)
            ..remove(ToggleButtonsState.italic),
        );
        hasChanged.add(ToggleButtonsState.italic);
      }

      if (style.decoration == null &&
          !hasChanged.contains(ToggleButtonsState.underline)) {
        _data = _data.copyWith(
          toggleButtonsState: Set.from(_data.toggleButtonsState)
            ..remove(ToggleButtonsState.underline),
        );
        hasChanged.add(ToggleButtonsState.underline);
      }
    }

    setState(() {});
  }

  void updateToggleButtonsStateOnButtonPressed(int index) {
    // Index is synced with ToggleButtonState in formatting_toolbar.dart.
    final attributeMap = <int, SpanGenerator>{
      // Bold
      ToggleButtonsState.bold.index: SpanGenerator(
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      // Italic
      ToggleButtonsState.italic.index: const SpanGenerator(
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
      // Underline.
      ToggleButtonsState.underline.index: const SpanGenerator(
        style: TextStyle(decoration: TextDecoration.underline),
      ),
      // Url
      ToggleButtonsState.url.index: SpanGenerator(
        buildRecognizer: (text) => TapGestureRecognizer()
          ..onTap = () async {
            print('>>> tap url text: $text');
          },
        style: const TextStyle(
          decoration: TextDecoration.underline,
          decorationStyle: TextDecorationStyle.dashed,
        ),
      ),
    };

    final BBCodeEditController controller = _data.replacementsController;

    final TextRange replacementRange = TextRange(
      start: controller.selection.start,
      end: controller.selection.end,
    );

    final targetToggleButtonState = ToggleButtonsState.values[index];

    if (_data.toggleButtonsState.contains(targetToggleButtonState)) {
      _data = _data.copyWith(
        toggleButtonsState: Set.from(_data.toggleButtonsState)
          ..remove(targetToggleButtonState),
      );
    } else {
      _data = _data.copyWith(
        toggleButtonsState: Set.from(_data.toggleButtonsState)
          ..add(targetToggleButtonState),
      );
    }

    if (_data.toggleButtonsState.contains(targetToggleButtonState)) {
      controller.applyReplacement(
        TextEditingInlineSpanReplacement(
          replacementRange,
          (string, range) => attributeMap[index]!.buildText(string),
          true,
        ),
      );
      _data = _data.copyWith(replacementsController: controller);
      setState(() {});
    } else {
      controller.disableExpand(attributeMap[index]!.style);
      controller.removeReplacementsAtRange(
        replacementRange,
        attributeMap[index]!.style,
      );
      _data = _data.copyWith(replacementsController: controller);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BBCodeStateManager(
      state: _data,
      child: widget.child,
    );
  }
}
