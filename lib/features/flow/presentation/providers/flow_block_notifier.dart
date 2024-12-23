import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:flow/features/flow/domain/entities/flow_block_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class FlowBlockNotifier extends StateNotifier<FlowBlockState> {
  FlowBlockNotifier({
    required FlowBlock entity,
    required bool startEditing,
    required String initialText,
    required Offset initialPosition,
  }) : super(
          FlowBlockState(
            entity: entity,
            isLongPressDown: false,
            isLongPress: false,
            isEditing: startEditing,
            isDragging: false,
            tapPosition: null,
            position: initialPosition,
            buttonAlignment: Alignment.centerLeft,
            textController: TextEditingController(text: initialText),
            isSelected: false,
            isHovered: false,
            isAnimating: false,
            isLocked: false,
            isExpanded: false,
            isInAnotherBlock: false,
            anotherBlockPosition: Offset.zero,
          ),
        );
}
