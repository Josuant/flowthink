import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:flutter/material.dart';

/// Holds all mutable state for the FlowContainer.
class FlowBlockState {
  final FlowBlock entity;
  final bool isLongPressDown;
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
  final bool? isPanUpdating;

  const FlowBlockState({
    required this.entity,
    required this.position,
    this.buttonAlignment = Alignment.centerLeft,
    this.isLongPressDown = false,
    this.isEditing = false,
    this.isDragging = false,
    this.tapPosition = Offset.zero,
    required this.textController,
    this.isSelected = false,
    this.isHovered = false,
    this.isAnimating = false,
    this.isLocked = false,
    this.isExpanded = false,
    this.isPanUpdating,
  });

  FlowBlockState copyWith({
    required FlowBlock entity,
    bool? isLongPressDown,
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
    bool? isPanUpdating,
    Offset? anotherBlockPosition,
  }) {
    return FlowBlockState(
      entity: entity,
      isLongPressDown: isLongPressDown ?? this.isLongPressDown,
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
      isPanUpdating: isPanUpdating ?? this.isPanUpdating,
    );
  }
}
