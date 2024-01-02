import 'package:flutter/material.dart';

import 'app_state.dart';
import 'app_state_manager.dart';

/// The toggle buttons that can be selected.
enum ToggleButtonsState {
  bold,
  italic,
  underline,
  url,
}

class BBCodeToolbar extends StatelessWidget {
  const BBCodeToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final BBCodeStateManager manager = BBCodeStateManager.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ToggleButtons(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            isSelected: [
              manager.bbcodeState.toggleButtonsState
                  .contains(ToggleButtonsState.bold),
              manager.bbcodeState.toggleButtonsState
                  .contains(ToggleButtonsState.italic),
              manager.bbcodeState.toggleButtonsState
                  .contains(ToggleButtonsState.underline),
              manager.bbcodeState.toggleButtonsState
                  .contains(ToggleButtonsState.url),
            ],
            onPressed: (index) => BBCodeScopeWidget.of(context)
                .updateToggleButtonsStateOnButtonPressed(index),
            children: const [
              Icon(Icons.format_bold),
              Icon(Icons.format_italic),
              Icon(Icons.format_underline),
              Icon(Icons.link),
            ],
          ),
        ],
      ),
    );
  }
}
