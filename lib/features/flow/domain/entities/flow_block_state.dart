import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:flutter/material.dart';

/// Holds all mutable state for the FlowContainer.
class FlowBlockState {
  final FlowBlock entity;
  final bool isLongPressDown;
  final bool isLongPress;
  final bool isEditing;
  final bool isDragging;
  final Offset? tapPosition;
  final Offset position;
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
    required this.entity,
    required this.isLongPressDown,
    required this.isLongPress,
    required this.isEditing,
    required this.isDragging,
    required this.tapPosition,
    required this.position,
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
    required FlowBlock entity,
    bool? isLongPressDown,
    bool? isLongPress,
    bool? isEditing,
    bool? isDragging,
    Offset? tapPosition,
    Offset? position,
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
      entity: entity,
      isLongPressDown: isLongPressDown ?? this.isLongPressDown,
      isLongPress: isLongPress ?? this.isLongPress,
      isEditing: isEditing ?? this.isEditing,
      isDragging: isDragging ?? this.isDragging,
      tapPosition: tapPosition ?? this.tapPosition,
      position: position ?? this.position,
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
