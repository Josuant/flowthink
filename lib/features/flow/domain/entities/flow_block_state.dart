import 'package:flutter/material.dart';

/// Holds all mutable state for the FlowContainer.
class FlowBlockState {
  final bool isLongPressDown;
  final bool isLongPress;
  final bool isEditing;
  final bool isDragging;
  final Offset? tapPosition;
  final Offset globalPosition;
  final Alignment buttonAlignment;
  final TextEditingController textController;

  const FlowBlockState({
    required this.isLongPressDown,
    required this.isLongPress,
    required this.isEditing,
    required this.isDragging,
    required this.tapPosition,
    required this.globalPosition,
    required this.buttonAlignment,
    required this.textController,
  });

  FlowBlockState copyWith({
    bool? isLongPressDown,
    bool? isLongPress,
    bool? isEditing,
    bool? isDragging,
    Offset? tapPosition,
    Offset? globalPosition,
    Alignment? buttonAlignment,
    TextEditingController? textController,
  }) {
    return FlowBlockState(
      isLongPressDown: isLongPressDown ?? this.isLongPressDown,
      isLongPress: isLongPress ?? this.isLongPress,
      isEditing: isEditing ?? this.isEditing,
      isDragging: isDragging ?? this.isDragging,
      tapPosition: tapPosition ?? this.tapPosition,
      globalPosition: globalPosition ?? this.globalPosition,
      buttonAlignment: buttonAlignment ?? this.buttonAlignment,
      textController: textController ?? this.textController,
    );
  }
}
