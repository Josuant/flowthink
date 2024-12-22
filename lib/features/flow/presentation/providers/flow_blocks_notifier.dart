// flow_blocks_notifier.dart
import 'dart:ui';

import 'package:flow/features/flow/data/models/flow_block_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlowBlocksNotifier extends StateNotifier<List<FlowBlockModel>> {
  FlowBlocksNotifier() : super([]);

  // Add a new block
  void addBlock(FlowBlockModel block) {
    state = [...state, block];
  }

  // Remove a block entirely
  void removeBlock(String blockId) {
    state = state.where((b) => b.id != blockId).toList();
  }

  // Update an existing block
  void updateBlock(FlowBlockModel updatedBlock) {
    state =
        state.map((b) => b.id == updatedBlock.id ? updatedBlock : b).toList();
  }

  // Or simple partial updates:
  void setPosition(String blockId, Offset newPosition) {
    state = state.map((b) {
      if (b.id == blockId) {
        return b.copyWith(position: newPosition);
      }
      return b;
    }).toList();
  }

  // Example collision detection (just returns the blockId if collision found)
  String? detectCollision(String blockId, Offset newPos) {
    final me = state.firstWhere((b) => b.id == blockId,
        orElse: () => throw 'Not found');
    final movingRect = Rect.fromLTWH(newPos.dx, newPos.dy, me.width, me.height);

    for (final other in state) {
      if (other.id == blockId) continue;
      final otherRect = Rect.fromLTWH(
          other.position.dx, other.position.dy, other.width, other.height);
      if (movingRect.overlaps(otherRect)) {
        return other.id;
      }
    }
    return null;
  }

  // Combine blocks example
  void combineBlocks(String blockAId, String blockBId) {
    final blockA = state.firstWhere((b) => b.id == blockAId);
    final blockB = state.firstWhere((b) => b.id == blockBId);

    // combine text as example
    final combinedText = '${blockA.text} + ${blockB.text}';

    // place block A in block B's position
    final updatedBlockA = blockA.copyWith(
      text: combinedText,
      position: blockB.position,
    );

    // remove block B
    removeBlock(blockBId);

    // replace block A
    updateBlock(updatedBlockA);
  }
}
