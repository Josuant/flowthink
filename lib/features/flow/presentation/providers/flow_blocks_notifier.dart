import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:flow/features/flow/domain/entities/flow_block_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlowBlocksNotifier extends StateNotifier<List<FlowBlockState>> {
  FlowBlocksNotifier() : super([]);

  //Add new flow block
  void addNewBlock(FlowBlock entity) {
    state = [
      ...state,
      FlowBlockState(
        entity: entity,
        isLongPressDown: false,
        isLongPress: false,
        isEditing: false,
        isDragging: false,
        tapPosition: null,
        position: entity.position,
        buttonAlignment: Alignment.centerLeft,
        textController: TextEditingController(text: entity.text),
        isSelected: false,
        isHovered: false,
        isAnimating: false,
        isLocked: false,
        isExpanded: false,
        isInAnotherBlock: false,
        anotherBlockPosition: Offset.zero,
      )
    ];
  }

  // Add a new block
  void addBlock(FlowBlockState block) {
    state = [...state, block];
  }

  // Remove a block entirely
  void removeBlock(String blockId) {
    state = state.where((b) => b.entity.id != blockId).toList();
  }

  // Update an existing block
  void updateBlock(FlowBlockState updatedBlock) {
    state = state
        .map((b) => b.entity.id == updatedBlock.entity.id ? updatedBlock : b)
        .toList();
  }

  // Or simple partial updates:
  void updateBlockPosition(String id, Offset position) {
    state = state.map((block) {
      if (block.entity.id == id) {
        return block.copyWith(position: position, entity: block.entity);
      }
      return block;
    }).toList();
  }

  // Combine blocks example
  void combineBlocks(String blockAId, String blockBId) {
    final blockA = state.firstWhere((b) => b.entity.id == blockAId);
    final blockB = state.firstWhere((b) => b.entity.id == blockBId);

    // combine text as example
    final combinedText =
        '${blockA.textController.text} + ${blockB.textController.text}';

    TextEditingController textController =
        TextEditingController(text: combinedText);

    // place block A in block B's position
    final updatedBlockA = blockA.copyWith(
      textController: textController,
      position: blockB.position,
      entity: blockA.entity,
    );

    // remove block B
    removeBlock(blockBId);

    // replace block A
    updateBlock(updatedBlockA);
  }

  // Toggle or set isLongPressDown
  void setLongPressDown(bool value, String id, [Offset? localPosition]) {
    state = state.map((block) {
      if (block.entity.id == id) {
        return block.copyWith(
            isLongPressDown: value,
            isLongPress: value ? block.isLongPress : false,
            tapPosition: localPosition ?? block.tapPosition,
            entity: block.entity);
      }
      return block;
    }).toList();
  }

  void setPosition(Offset position, String id) {
    state = state.map((block) {
      if (block.entity.id == id) {
        return block.copyWith(position: position, entity: block.entity);
      }
      return block;
    }).toList();
  }

  // Toggle or set isLongPress
  void setLongPress(bool value, String id) {
    state = state.map((block) {
      if (block.entity.id == id) {
        return block.copyWith(isLongPress: value, entity: block.entity);
      }
      return block;
    }).toList();
  }

  // Toggle editing
  void setEditing(bool value, String id) {
    state = state.map((block) {
      if (block.entity.id == id) {
        return block.copyWith(isEditing: value, entity: block.entity);
      }
      return block;
    }).toList();
  }

  void onFinishDrag(String id, Offset finalPosition) {
    state = state.map((block) {
      if (block.entity.id == id) {
        return block.copyWith(position: finalPosition, entity: block.entity);
      }
      return block;
    }).toList();
  }

  // Toggle dragging
  void setDragging(bool value, String id) {
    state = state.map((block) {
      if (block.entity.id == id) {
        return block.copyWith(isDragging: value, entity: block.entity);
      }
      return block;
    }).toList();
  }

  // Update tap position + alignment
  void updateTapPosition(
    String id, {
    required Offset localPosition,
    required Alignment alignment,
  }) {
    state = state.map((block) {
      if (block.entity.id == id) {
        return block.copyWith(
          tapPosition: localPosition,
          buttonAlignment: alignment,
          entity: block.entity,
        );
      }
      return block;
    }).toList();
  }

  // Update global position when dragging ends
  void updateGlobalPosition(Offset lastTapPosition, double height, String id) {
    state = state.map((block) {
      if (block.entity.id == id) {
        return block.copyWith(
          position: lastTapPosition -
              Offset(50, height / 2), // 50 is half the width of the block
          entity: block.entity,
        );
      }
      return block;
    }).toList();
  }

  // Update text in controller
  void updateText(String newText, String id) {
    state = state.map((block) {
      if (block.entity.id == id) {
        return block.copyWith(
          textController: TextEditingController(text: newText),
          entity: block.entity,
        );
      }
      return block;
    }).toList();
  }

  void onDrag(Offset tapPosition, id) {
    state = state.map((block) {
      if (block.entity.id == id) {
        return block.copyWith(
            position: tapPosition,
            isDragging: true,
            tapPosition: tapPosition,
            entity: block.entity);
      }
      return block;
    }).toList();
    veryfyCollisions(tapPosition);
  }

  void onEditing(id) {}

  void onCreateNewWidget(id, FlowBlock newBlock) {}

  bool isAnyDragging() {
    return state.any((block) => block.isDragging);
  }

  bool isAnyEditing() {
    return state.any((block) => block.isEditing);
  }

  bool isAnyLongPress() {
    return state.any((block) => block.isLongPress);
  }

  bool isAnyLongPressDown() {
    return state.any((block) => block.isLongPressDown);
  }

  bool isAnyHovered() {
    return state.any((block) => block.isHovered);
  }

  bool isAnyAnimating() {
    return state.any((block) => block.isAnimating);
  }

  bool isAnyLocked() {
    return state.any((block) => block.isLocked);
  }

  bool isAnyExpanded() {
    return state.any((block) => block.isExpanded);
  }

  bool isAnySelected() {
    return state.any((block) => block.isSelected);
  }

  bool isAnyCollision() {
    return state.any((block) => block.isInAnotherBlock ?? false);
  }

  Offset? getTapPosition() {
    return state.firstWhere((block) => block.tapPosition != null).tapPosition;
  }

  Offset getTapPositionById(String id) {
    return state.firstWhere((block) => block.entity.id == id).tapPosition!;
  }

  FlowBlockState getCollisionBlock() {
    return state.firstWhere((block) => block.isInAnotherBlock == true);
  }

  Offset getDraggingPosition() {
    return state.firstWhere((block) => block.isDragging).position;
  }

  void veryfyCollisions(Offset position) {
    state = state.map((block) {
      if (block.position.dx < position.dx &&
          block.position.dx + 100 > position.dx &&
          block.position.dy < position.dy &&
          block.position.dy + 100 > position.dy) {
        return block.copyWith(isInAnotherBlock: true, entity: block.entity);
      }
      return block.copyWith(isInAnotherBlock: false, entity: block.entity);
    }).toList();
  }

  void setAllEditingFalse() {
    state = state.map((block) {
      return block.copyWith(isEditing: false, entity: block.entity);
    }).toList();
  }
}
