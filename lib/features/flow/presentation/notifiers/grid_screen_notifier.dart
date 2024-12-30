import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:flow/features/flow/domain/entities/flow_block_state.dart';
import 'package:flow/features/flow/domain/entities/flow_connection.dart';
import 'package:flow/features/flow/presentation/notifiers/flow_blocks_notifier.dart';
import 'package:flow/features/flow/presentation/notifiers/flow_connections_notifier.dart';
import 'package:flow/features/flow/presentation/notifiers/trash_notifier.dart';
import 'package:flow/features/flow/utils/constants/flow_default_constants.dart';
import 'package:flow/features/flow/utils/enums/flow_block_enums.dart';
import 'package:flow/features/flow/utils/flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'package:flow/features/flow/domain/entities/grid_screen_state.dart';
part 'package:flow/features/flow/presentation/notifiers/grid_screen_animator_notifier.dart';

final gridScreenProvider =
    StateNotifierProvider<GridScreenNotifierAnimator, GridScreenState>(
  (ref) => GridScreenNotifierAnimator(),
);

class GridScreenNotifier extends StateNotifier<GridScreenState> {
  GridScreenNotifier() : super(GridScreenState.initial());

  void setBlocksNotifier(FlowBlocksNotifier blocksNotifier) {
    state.blocksNotifier = blocksNotifier;
  }

  void setConnectionsNotifier(FlowConnectionsNotifier connectionsNotifier) {
    state.connectionsNotifier = connectionsNotifier;
  }

  void setTrashNotifier(TrashNotifier trashNotifier) {
    state.trashNotifier = trashNotifier;
  }

  void setTickerProvider(TickerProvider tickerProvider) {
    state.tickerProvider = tickerProvider;
  }

  void onDragEnd(String id, Offset position) {
    if (state.trashNotifier.veryfyProximity(position)) {
      state.blocksNotifier.removeBlock(id);
      state.connectionsNotifier.removeConnectionsByBlockId(id);
    } else if (state.blocksNotifier.isDraggingColliding()) {
      final collidingBlock = state.blocksNotifier.getDraggingCollidingBlock();
      state.blocksNotifier.combineBlocks(id, collidingBlock.entity.id);
      state.connectionsNotifier.mergeConnections(id, collidingBlock.entity.id);

      state.blocksNotifier.setLongPressDown(false, id);
      state.blocksNotifier.setDragging(false, id);
      state.blocksNotifier.setAnimating(false, id);
    } else {
      state.blocksNotifier.setLongPressDown(false, id);
      state.blocksNotifier.setDragging(false, id);
      state.blocksNotifier.setAnimating(false, id);
    }
    state.trashNotifier.setVisibility(false);
  }

  void onPanEnd(String id, Offset finalPosition, {Offset? tp}) {
    Offset transformedPosition =
        tp ?? state.transformationController.toScene(finalPosition);

    void resetPanAndLongPress(String blockId) {
      print("resetPanAndLongPress $blockId");
      state.blocksNotifier.setPanUpdating(false, blockId);
      state.blocksNotifier.setLongPressDown(false, blockId);
      state.blocksNotifier.setAnimating(false, id);
    }

    if (state.blocksNotifier.isPanUpdatingTapPositionCollidingWithItself()) {
      resetPanAndLongPress(id);
      return;
    }

    if (state.blocksNotifier.isPanUpdatingTapPositionColliding()) {
      String collidingBlockId =
          state.blocksNotifier.getPanUpdatingCollidingBlock().entity.id;
      state.connectionsNotifier.addConnection(
        FlowConnection.buildDefault(id, collidingBlockId),
      );
      resetPanAndLongPress(id);
      return;
    }

    FlowBlock newBlock =
        FlowBlock.buildDefault("NewBlock", transformedPosition);
    state.blocksNotifier.addNewBlock(newBlock);

    state.connectionsNotifier.addConnection(
      FlowConnection.buildDefault(id, newBlock.id),
    );

    resetPanAndLongPress(id);
  }

  void onPanUpdate(String id, Offset position) {
    state.blocksNotifier.setPanUpdating(true, id);
    state.blocksNotifier
        .setTapPosition(state.transformationController.toScene(position), id);
  }

  void onLongPressDown(String id) {
    state.blocksNotifier.setLongPressDown(true, id);
  }

  void onEditingStart(String id) {
    state.blocksNotifier.setAllEditingFalse();
    state.blocksNotifier.setAllLongPressDownFalse();
    state.blocksNotifier.setEditing(true, id);
    state.blocksNotifier.setPanUpdating(false, id);
  }

  void onDragStart(Offset position, String id, Offset trashInitialPosition) {
    state.blocksNotifier.setAllEditingFalse();
    state.blocksNotifier
        .onDrag(state.transformationController.toScene(position), id);
    state.blocksNotifier.setDragging(true, id);
    state.blocksNotifier.setPanUpdating(false, id);

    state.trashNotifier.setInitialPosition(trashInitialPosition);
    state.trashNotifier.setVisibility(true);
    state.trashNotifier.updateCurrentPosition(position);
  }

  void onEditing(String id) {
    state.blocksNotifier.onEditing(id);
  }

  void onDrag(Offset position, String id) {
    state.blocksNotifier
        .onDrag(state.transformationController.toScene(position), id);
    state.trashNotifier.updateCurrentPosition(position);
  }

  void doubleTapOnScreen(TapDownDetails details) {
    state.blocksNotifier.setAllEditingFalse();
    state.blocksNotifier.addNewBlock(
      FlowBlock.buildDefault("NewBlock", details.localPosition),
    );
  }

  void tapOnScreen() => state.blocksNotifier.setAllEditingFalse();
}
