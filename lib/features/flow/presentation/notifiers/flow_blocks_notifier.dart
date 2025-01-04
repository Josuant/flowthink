import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:flow/features/flow/domain/entities/flow_block_state.dart';
import 'package:flow/features/flow/utils/constants/flow_default_constants.dart';
import 'package:flow/features/flow/utils/enums/flow_block_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlowBlocksNotifier extends StateNotifier<List<FlowBlockState>> {
  FlowBlocksNotifier() : super([]);

  //Add new flow block
  void addNewBlock(FlowBlock entity) {
    //check if the entity is already in the list
    if (state.any((block) => block.entity.id == entity.id)) {
      return;
    }
    state = [
      ...state,
      FlowBlockState(
        entity: entity,
        position: entity.position,
        textController: TextEditingController(text: entity.text),
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

  // Toggle editing
  void setEditing(bool value, String id) {
    state = state.map((block) {
      if (block.entity.id == id) {
        return block.copyWith(isEditing: value, entity: block.entity);
      }
      return block;
    }).toList();
  }

  void setPanUpdating(bool value, String id) {
    state = state.map((block) {
      if (block.entity.id == id) {
        return block.copyWith(isPanUpdating: value, entity: block.entity);
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
  }

  void onEditing(id) {}

  void onCreateNewWidget(id, FlowBlock newBlock) {}

  bool isAnyDragging() {
    return state.any((block) => block.isDragging);
  }

  bool isAnyEditing() {
    return state.any((block) => block.isEditing);
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

  Offset? getTapPosition() {
    return state.firstWhere((block) => block.tapPosition != null).tapPosition;
  }

  Offset getTapPositionById(String id) {
    return state.firstWhere((block) => block.entity.id == id).tapPosition!;
  }

  Offset getDraggingPosition() {
    return state.firstWhere((block) => block.isDragging).position;
  }

  Offset getPanningPosition() {
    var panning = state.firstWhere((block) => block.isPanUpdating ?? false);
    return panning.tapPosition ?? panning.position;
  }

  void setAllEditingFalse() {
    state = state.map((block) {
      return block.copyWith(isEditing: false, entity: block.entity);
    }).toList();
  }

  void setAllLongPressDownFalse() {
    state = state.map((block) {
      return block.copyWith(isLongPressDown: false, entity: block.entity);
    }).toList();
  }

  void setOthersLongPressDownFalse(String id) {
    state = state.map((block) {
      if (block.entity.id != id) {
        return block.copyWith(isLongPressDown: false, entity: block.entity);
      }
      return block;
    }).toList();
  }

  isAnyPanUpdating() {
    return state.any((block) => block.isPanUpdating ?? false);
  }

  void setTapPosition(Offset position, String id) {
    state = state.map((block) {
      if (block.entity.id == id) {
        return block.copyWith(tapPosition: position, entity: block.entity);
      }
      return block;
    }).toList();
  }

  //Get the Rect area of the block
  Rect getBlockRect(String id) {
    final block = state.firstWhere((block) => block.entity.id == id);
    return Rect.fromLTWH(
      block.position.dx - block.entity.width / 2,
      block.position.dy - block.entity.height / 2,
      block.entity.width,
      block.entity.height,
    );
  }

  //Get the default Rect area of a tap position
  Rect getPositionRect(Offset tapPosition) {
    return Rect.fromLTWH(
      tapPosition.dx - FlowDefaultConstants.flowBlockWidth / 2,
      tapPosition.dy - FlowDefaultConstants.flowBlockHeight / 2,
      FlowDefaultConstants.flowBlockWidth,
      FlowDefaultConstants.flowBlockHeight,
    );
  }

  double getSpaceBetweenRects(Rect rectA, Rect rectB, Direction direction) {
    switch (direction) {
      case Direction.up:
        return rectA.top - rectB.bottom;
      case Direction.down:
        return rectB.top - rectA.bottom;
      case Direction.left:
        return rectA.left - rectB.right;
      case Direction.right:
        return rectB.left - rectA.right;
    }
  }

  getSpaceBetweenBlocks(String idA, String idB, Direction direction) {
    final rectA = getBlockRect(idA);
    final rectB = getBlockRect(idB);
    return getSpaceBetweenRects(rectA, rectB, direction);
  }

  getSpaceBetweenBlockAndPosition(
      Offset position, String id, Direction direction) {
    final rect = getBlockRect(id);
    final positionRect = getPositionRect(position);
    return getSpaceBetweenRects(rect, positionRect, direction);
  }

  //Check if the Dragging block is colliding with any other block
  bool isDraggingColliding() {
    final draggingBlock = getDraggingBlock();
    return isBlockColliding(draggingBlock);
  }

  // Check if the Pan Updating block tap position is colliding with any other block
  bool isPanUpdatingTapPositionColliding() {
    final panUpdatingBlock =
        state.firstWhere((block) => block.isPanUpdating ?? false);
    return state.any((block) {
      if (block.entity.id != panUpdatingBlock.entity.id) {
        final blockRect = getBlockRect(block.entity.id);
        return blockRect
            .overlaps(getPositionRect(panUpdatingBlock.tapPosition!));
      }
      return false;
    });
  }

  // Check if the Pan Updating block tap position is colliding with itself
  bool isPanUpdatingTapPositionCollidingWithItself() {
    final panUpdatingBlock =
        state.firstWhere((block) => block.isPanUpdating ?? false);
    final panUpdatingBlockRect = getBlockRect(panUpdatingBlock.entity.id);
    return panUpdatingBlockRect
        .overlaps(getPositionRect(panUpdatingBlock.tapPosition!));
  }

  // Check if a certain block is colliding with another block
  bool isBlockColliding(FlowBlockState blockA) {
    final blockARect = getBlockRect(blockA.entity.id);
    return state.any((block) {
      if (block.entity.id != blockA.entity.id) {
        final blockRect = getBlockRect(block.entity.id);
        return blockARect.overlaps(blockRect);
      }
      return false;
    });
  }

  bool isPositionColliding(Offset position) {
    return state.any((block) {
      final blockRect = getBlockRect(block.entity.id);
      return blockRect.contains(position);
    });
  }

  // Check if any block is colliding with another block
  bool isAnyBlockColliding() {
    return state.any((block) => isBlockColliding(block));
  }

  // Get the block that is currently being dragged
  FlowBlockState getDraggingBlock() {
    return state.firstWhere((block) => block.isDragging);
  }

  // Get the block that is currently being Pan Updating
  FlowBlockState getPanUpdatingBlock() {
    return state.firstWhere((block) => block.isPanUpdating ?? false);
  }

  // Get the block that is currently being Pan Updating and colliding with the tap position
  FlowBlockState getPanUpdatingCollidingBlock() {
    final panUpdatingBlock =
        state.firstWhere((block) => block.isPanUpdating ?? false);
    return state.firstWhere((block) {
      if (block.entity.id != panUpdatingBlock.entity.id) {
        final blockRect = getBlockRect(block.entity.id);
        return blockRect
            .overlaps(getPositionRect(panUpdatingBlock.tapPosition!));
      }
      return false;
    });
  }

  // Get the block that is currently being dragged and colliding with another block
  FlowBlockState getDraggingCollidingBlock() {
    final draggingBlock = getDraggingBlock();
    return state.firstWhere((block) {
      if (block.entity.id != draggingBlock.entity.id) {
        final blockARect = getBlockRect(draggingBlock.entity.id);
        final blockRect = getBlockRect(block.entity.id);
        return blockARect.overlaps(blockRect);
      }
      return false;
    });
  }

  FlowBlockState getBlock(String id) {
    return state.firstWhere((block) => block.entity.id == id);
  }

  FlowBlockState? getBlockByPosition(Offset position) {
    final positionRect = getPositionRect(position);

    // Find the block if it exists
    for (final block in state) {
      final blockRect = getBlockRect(block.entity.id);
      if (blockRect.overlaps(positionRect)) {
        return block;
      }
    }

    // Return null if no block matches
    return null;
  }

  bool isAnimating(String id) {
    return state.firstWhere((block) => block.entity.id == id).isAnimating;
  }

  void setAnimating(bool bool, String id) {
    state = state.map((block) {
      if (block.entity.id == id) {
        return block.copyWith(isAnimating: bool, entity: block.entity);
      }
      return block;
    }).toList();
  }
}
