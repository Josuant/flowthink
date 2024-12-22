import 'package:flutter/material.dart';

/// Holds all mutable state for the FlowContainer.
class FlowBlockState {
  final String id;
  final bool isLongPressDown;
  final bool isLongPress;
  final bool isEditing;
  final bool isDragging;
  final Offset? tapPosition;
  final Offset globalPosition;
  final Alignment buttonAlignment;
  final TextEditingController textController;
  final bool isSelected;
  final bool isHovered;
  final bool isAnimating;
  final bool isLocked;
  final bool isExpanded;
  final bool? isInAnotherBlock;
  final Offset? anotherBlockPosition;

  const FlowBlockState({
    required this.id,
    required this.isLongPressDown,
    required this.isLongPress,
    required this.isEditing,
    required this.isDragging,
    required this.tapPosition,
    required this.globalPosition,
    required this.buttonAlignment,
    required this.textController,
    required this.isSelected,
    required this.isHovered,
    required this.isAnimating,
    required this.isLocked,
    required this.isExpanded,
    required this.isInAnotherBlock,
    required this.anotherBlockPosition,
  });

  FlowBlockState copyWith({
    required String id,
    bool? isLongPressDown,
    bool? isLongPress,
    bool? isEditing,
    bool? isDragging,
    Offset? tapPosition,
    Offset? globalPosition,
    Alignment? buttonAlignment,
    TextEditingController? textController,
    bool? isSelected,
    bool? isHovered,
    bool? isAnimating,
    bool? isLocked,
    bool? isExpanded,
    bool? isInAnotherBlock,
    Offset? anotherBlockPosition,
  }) {
    return FlowBlockState(
      id: id,
      isLongPressDown: isLongPressDown ?? this.isLongPressDown,
      isLongPress: isLongPress ?? this.isLongPress,
      isEditing: isEditing ?? this.isEditing,
      isDragging: isDragging ?? this.isDragging,
      tapPosition: tapPosition ?? this.tapPosition,
      globalPosition: globalPosition ?? this.globalPosition,
      buttonAlignment: buttonAlignment ?? this.buttonAlignment,
      textController: textController ?? this.textController,
      isSelected: isSelected ?? this.isSelected,
      isHovered: isHovered ?? this.isHovered,
      isAnimating: isAnimating ?? this.isAnimating,
      isLocked: isLocked ?? this.isLocked,
      isExpanded: isExpanded ?? this.isExpanded,
      isInAnotherBlock: isInAnotherBlock,
      anotherBlockPosition: anotherBlockPosition,
    );
  }
}
