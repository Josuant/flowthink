import 'package:flow/features/flow/domain/entities/flow_block_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class FlowBlockNotifier extends StateNotifier<FlowBlockState> {
  FlowBlockNotifier({
    required bool startEditing,
    required String initialText,
    required Offset initialPosition,
  }) : super(
          FlowBlockState(
            isLongPressDown: false,
            isLongPress: false,
            isEditing: startEditing,
            isDragging: false,
            tapPosition: null,
            globalPosition: initialPosition,
            buttonAlignment: Alignment.centerLeft,
            textController: TextEditingController(text: initialText),
          ),
        );

  // Toggle or set isLongPressDown
  void setLongPressDown(bool value, [Offset? localPosition]) {
    state = state.copyWith(
      isLongPressDown: value,
      isLongPress: value ? state.isLongPress : false,
      tapPosition: localPosition ?? state.tapPosition,
    );
  }

  // Toggle or set isLongPress
  void setLongPress(bool value) {
    state = state.copyWith(isLongPress: value);
  }

  // Toggle editing
  void setEditing(bool value) {
    state = state.copyWith(isEditing: value);
  }

  // Toggle dragging
  void setDragging(bool value) {
    state = state.copyWith(isDragging: value);
  }

  // Update tap position + alignment
  void updateTapPosition({
    required Offset localPosition,
    required Alignment alignment,
  }) {
    state = state.copyWith(
      tapPosition: localPosition,
      buttonAlignment: alignment,
    );
  }

  // Update global position when dragging ends
  void updateGlobalPosition(Offset lastTapPosition, double height) {
    final dx = lastTapPosition.dx - 5;
    final dy = lastTapPosition.dy - height / 2;
    state = state.copyWith(
      globalPosition: state.globalPosition.translate(dx, dy),
    );
  }

  // Update text in controller
  void updateText(String newText) {
    state.textController.text = newText;
  }
}
