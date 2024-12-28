import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:flow/features/flow/domain/entities/flow_block_state.dart';
import 'package:flow/features/flow/domain/entities/flow_connection.dart';
import 'package:flow/features/flow/presentation/notifiers/flow_blocks_notifier.dart';
import 'package:flow/features/flow/presentation/notifiers/flow_connections_notifier.dart';
import 'package:flow/features/flow/presentation/notifiers/trash_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'package:flow/features/flow/domain/entities/grid_screen_state.dart'; // We'll define state in the same folder

final gridScreenProvider =
    StateNotifierProvider<GridScreenNotifier, GridScreenState>(
  (ref) => GridScreenNotifier(),
);

class GridScreenNotifier extends StateNotifier<GridScreenState> {
  GridScreenNotifier() : super(GridScreenState.initial());

  void startAnimation(int durationMS) {
    state.isOnAnimation = true;
    Future.delayed(Duration(milliseconds: durationMS), () {
      state.isOnAnimation = false;
    });
  }

  // Start a drag operation simulation
  static void startDragAnimation(
      FlowBlockState block,
      Offset finalPosition,
      int durationMS,
      TickerProvider tickerProvider,
      FlowBlocksNotifier blocksNotifier,
      FlowConnectionsNotifier connectionsNotifier,
      TrashNotifier trashNotifier) {
    final dragAnimationController = BlockAnimationController(
      block: block,
      finalPosition: finalPosition,
      durationMS: durationMS,
      tickerProvider: tickerProvider,
      blocksNotifier: blocksNotifier,
      connectionsNotifier: connectionsNotifier,
      trashNotifier: trashNotifier,
      initialPosition: block.position,
    );

    dragAnimationController.startAnimation(
      onUpdate: (position) {
        blocksNotifier.setPosition(position, block.entity.id);
      },
      onComplete: () {
        onDragEnd(block.entity.id, finalPosition, finalPosition, trashNotifier,
            blocksNotifier, connectionsNotifier);
      },
      onBegin: () {
        blocksNotifier.setDragging(true, block.entity.id);
      },
    );
  }

  static void onDragEnd(
      String id,
      Offset position,
      Offset transformedPosition,
      TrashNotifier trashNotifier,
      FlowBlocksNotifier blocksNotifier,
      FlowConnectionsNotifier connectionsNotifier) {
    if (trashNotifier.veryfyProximity(position)) {
      blocksNotifier.removeBlock(id);
      connectionsNotifier.removeConnectionsByBlockId(id);
    } else if (blocksNotifier.isDraggingColliding()) {
      final collidingBlock = blocksNotifier.getDraggingCollidingBlock();
      blocksNotifier.combineBlocks(id, collidingBlock.entity.id);
      connectionsNotifier.mergeConnections(id, collidingBlock.entity.id);

      blocksNotifier.setLongPressDown(false, id);
      blocksNotifier.setDragging(false, id);
    } else {
      blocksNotifier.onFinishDrag(id, transformedPosition);
      blocksNotifier.setLongPressDown(false, id);
      blocksNotifier.setDragging(false, id);
    }
    trashNotifier.setVisibility(false);
  }

  // Start a panning animation simulation
  static void startPanAnimation(
      FlowBlockState block,
      Offset finalPosition,
      int durationMS,
      TickerProvider tickerProvider,
      FlowBlocksNotifier blocksNotifier,
      FlowConnectionsNotifier connectionsNotifier) {
    final panAnimationController = BlockAnimationController(
      block: block,
      finalPosition: finalPosition,
      durationMS: durationMS,
      tickerProvider: tickerProvider,
      blocksNotifier: blocksNotifier,
      connectionsNotifier: connectionsNotifier,
      initialPosition: block.position,
    );

    panAnimationController.startAnimation(
      onUpdate: (position) {
        blocksNotifier.setTapPosition(position, block.entity.id);
      },
      onComplete: () {
        onPanEnd(block.entity.id, finalPosition, blocksNotifier,
            connectionsNotifier);
      },
      onBegin: () {
        blocksNotifier.setPanUpdating(true, block.entity.id);
      },
    );
  }

  static void onPanEnd(
      String id,
      Offset finalPosition,
      FlowBlocksNotifier blocksNotifier,
      FlowConnectionsNotifier connectionsNotifier) {
    void resetPanAndLongPress(String blockId) {
      blocksNotifier.setPanUpdating(false, blockId);
      blocksNotifier.setLongPressDown(false, blockId);
    }

    if (blocksNotifier.isPanUpdatingTapPositionCollidingWithItself()) {
      resetPanAndLongPress(id);
      return;
    }

    if (blocksNotifier.isPanUpdatingTapPositionColliding()) {
      String collidingBlockId =
          blocksNotifier.getPanUpdatingCollidingBlock().entity.id;
      connectionsNotifier.addConnection(
        FlowConnection.buildDefault(id, collidingBlockId),
      );
      resetPanAndLongPress(id);
      return;
    }

    FlowBlock newBlock = FlowBlock.buildDefault("NewBlock", finalPosition);
    blocksNotifier.addNewBlock(newBlock);

    connectionsNotifier.addConnection(
      FlowConnection.buildDefault(id, newBlock.id),
    );

    resetPanAndLongPress(id);
  }
}

class BlockAnimationController {
  final FlowBlockState block;
  final Offset initialPosition;
  final Offset finalPosition;
  final int durationMS;
  final TickerProvider tickerProvider;
  final FlowBlocksNotifier blocksNotifier;
  final FlowConnectionsNotifier connectionsNotifier;

  BlockAnimationController({
    required this.block,
    required this.initialPosition,
    required this.finalPosition,
    required this.durationMS,
    required this.tickerProvider,
    required this.blocksNotifier,
    required this.connectionsNotifier,
    TrashNotifier? trashNotifier,
  });

  void startAnimation({
    required void Function(Offset position) onUpdate,
    required void Function() onComplete,
    required void Function() onBegin,
    Curve curve = Curves.fastLinearToSlowEaseIn,
  }) {
    final controller = AnimationController(
      vsync: tickerProvider,
      duration: Duration(milliseconds: durationMS),
    );

    final curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: curve,
    );

    final animation = Tween<Offset>(
      begin: initialPosition,
      end: finalPosition,
    ).animate(curvedAnimation);

    controller.addListener(() {
      onUpdate(animation.value);
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
        onComplete();
      }
    });

    onBegin();

    controller.forward();
  }
}
