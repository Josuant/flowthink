import 'package:flow/features/flow/presentation/widgets/widget_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flow/core/widgets/animated_dashed_line.dart';
import 'package:flow/core/widgets/xml_input.dart';

import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:flow/features/flow/domain/entities/flow_block_state.dart';
import 'package:flow/features/flow/domain/entities/flow_connection.dart';
import 'package:flow/features/flow/domain/entities/trash_state.dart';

import 'package:flow/features/flow/presentation/widgets/widget_flow_block.dart';
import 'package:flow/features/flow/presentation/widgets/widget_flow_static_block.dart';
import 'package:flow/features/flow/presentation/widgets/widget_trash.dart';
import 'package:flow/features/flow/presentation/widgets/widget_union_indicator.dart';

import 'package:flow/features/flow/presentation/notifiers/flow_blocks_notifier.dart';
import 'package:flow/features/flow/presentation/notifiers/flow_connections_notifier.dart';
import 'package:flow/features/flow/presentation/notifiers/trash_notifier.dart';
import 'package:flow/features/flow/presentation/notifiers/grid_screen_notifier.dart';

import 'package:flow/features/flow/presentation/providers/flow_providers.dart';

class FlowPage extends ConsumerWidget {
  const FlowPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridState = ref.watch(gridScreenProvider);

    final blocks = ref.watch(flowBlocksProvider);
    final blocksNotifier = ref.read(flowBlocksProvider.notifier);

    final connections = ref.watch(flowConnectionsProvider);
    final connectionsNotifier = ref.read(flowConnectionsProvider.notifier);

    final TrashState trashState = ref.watch(trashProvider);
    final TrashNotifier trashNotifier = ref.read(trashProvider.notifier);

    final screenSize = MediaQuery.of(context).size;

    final trashInitialPosition = Offset(
      screenSize.width / 2 - 50 / 2,
      screenSize.height - 250,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      body: Stack(
        children: [
          // 1) Main stack with InteractiveViewer
          Stack(
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                constrained: false,
                transformationController: gridState.transformationController,
                child: Container(
                  width: 2000,
                  height: 2000,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                  ),
                  child: Stack(children: [
                    // 1.1) Background grid
                    const GridWidget(size: Size(2000, 2000)),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTapDown: (position) =>
                          blocksNotifier.setAllEditingFalse(),
                      onDoubleTapDown: (details) {
                        blocksNotifier.setAllEditingFalse();
                        blocksNotifier.addNewBlock(
                          FlowBlock.buildDefault(
                              "NewBlock", details.localPosition),
                        );
                      },
                      child: Stack(
                          children: _buildConnections(connections, blocks)),
                    ),
                    // 1.5) New Block line UI
                    if (blocksNotifier.isAnyPanUpdating() &&
                        !blocksNotifier
                            .isPanUpdatingTapPositionCollidingWithItself())
                      _buildLine(
                        blocksNotifier.getPanUpdatingBlock().position,
                        blocksNotifier.isPanUpdatingTapPositionColliding()
                            ? blocksNotifier
                                .getPanUpdatingCollidingBlock()
                                .position
                            : blocksNotifier.getPanningPosition(),
                        true,
                      ),

                    // 1.2) FlowBlocks
                    Stack(
                      children: blocks.map((block) {
                        final id = block.entity.id;
                        return FlowBlockWidget(
                          key: ValueKey(id),
                          state: block,
                          onDrag: (position) {
                            blocksNotifier.onDrag(
                                gridState.transformationController
                                    .toScene(position),
                                id);
                            trashNotifier.updateCurrentPosition(position);
                          },
                          onFinishDrag: (position) {
                            if (trashNotifier.veryfyProximity(position)) {
                              blocksNotifier.removeBlock(id);
                              connectionsNotifier
                                  .removeConnectionsByBlockId(id);
                            } else if (blocksNotifier.isDraggingColliding()) {
                              final collidingBlock =
                                  blocksNotifier.getDraggingCollidingBlock();
                              blocksNotifier.combineBlocks(
                                  id, collidingBlock.entity.id);
                              connectionsNotifier.mergeConnections(
                                  id, collidingBlock.entity.id);

                              blocksNotifier.setLongPressDown(false, id);
                              blocksNotifier.setDragging(false, id);
                            } else {
                              blocksNotifier.onFinishDrag(
                                  id,
                                  gridState.transformationController
                                      .toScene(position));

                              blocksNotifier.setLongPressDown(false, id);
                              blocksNotifier.setDragging(false, id);
                            }
                            trashNotifier.setVisibility(false);
                          },
                          onEditing: (text) {
                            blocksNotifier.onEditing(id);
                          },
                          onFinishEditing: (text) {},
                          onStartDrag: (position) {
                            blocksNotifier.setAllEditingFalse();
                            blocksNotifier.onDrag(
                                gridState.transformationController
                                    .toScene(position),
                                id);
                            blocksNotifier.setDragging(true, id);
                            blocksNotifier.setPanUpdating(false, id);

                            trashNotifier
                                .setInitialPosition(trashInitialPosition);
                            trashNotifier.setVisibility(true);
                            trashNotifier.updateCurrentPosition(position);
                          },
                          onStartEditing: () {
                            blocksNotifier.setAllEditingFalse();
                            blocksNotifier.setAllLongPressDownFalse();
                            blocksNotifier.setEditing(true, id);
                            blocksNotifier.setPanUpdating(false, id);
                          },
                          onLongPressDown: (position) {
                            blocksNotifier.setLongPressDown(true, id);
                          },
                          onPanUpdate: (position) {
                            blocksNotifier.setPanUpdating(true, id);
                            blocksNotifier.setTapPosition(
                                gridState.transformationController
                                    .toScene(position),
                                id);
                          },
                          onPanEnd: (position) {
                            _onPanEndHandler(
                                blocksNotifier,
                                gridState.transformationController
                                    .toScene(position),
                                connectionsNotifier,
                                id);
                          },
                        );
                      }).toList(),
                    ),

                    // 1.3) Union indicator
                    if (blocksNotifier.isAnyBlockColliding() &&
                        blocksNotifier.isAnyDragging())
                      UnionIndicator(
                        context: context,
                        anotherBlock:
                            blocksNotifier.getDraggingCollidingBlock(),
                        dragPosition: blocksNotifier.getDraggingPosition(),
                      ),

                    // 1.5) New Block UI
                    if (blocksNotifier.isAnyPanUpdating())
                      WidgetFlowAnimatedBlock(
                        isUnion: false,
                        isLongPressDown:
                            !blocksNotifier.isPanUpdatingTapPositionColliding(),
                        isEditing: false,
                        opacity: blocksNotifier
                                    .isPanUpdatingTapPositionCollidingWithItself() ||
                                blocksNotifier
                                    .isPanUpdatingTapPositionColliding()
                            ? 0.3
                            : 1.0,
                        position:
                            blocksNotifier.isPanUpdatingTapPositionColliding()
                                ? blocksNotifier
                                    .getPanUpdatingCollidingBlock()
                                    .position
                                : blocksNotifier.getPanningPosition(),
                      )
                  ]),
                ),
              ),
              // 2) Xml input
              XmlInputWidget(
                onXmlSubmitted: (xml) {},
                hintText: 'Escribe algo...',
              ),
              // 3) Add block button
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.add),
                ),
              ),
              // 1.4) Trash widget
              WidgetTrash(
                state: trashState,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onPanEndHandler(
    FlowBlocksNotifier blocksNotifier,
    Offset position,
    FlowConnectionsNotifier connectionsNotifier,
    String id,
  ) {
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

    FlowBlock newBlock = FlowBlock.buildDefault("NewBlock", position);
    blocksNotifier.addNewBlock(newBlock);

    connectionsNotifier.addConnection(
      FlowConnection.buildDefault(id, newBlock.id),
    );

    resetPanAndLongPress(id);
  }

  // Build the dashed lines for all connections
  List<AnimatedDashedLine> _buildConnections(
    List<FlowConnection> connections,
    List<FlowBlockState> blocks,
  ) {
    return connections.map((conn) {
      final start = blocks
          .firstWhere((element) => element.entity.id == conn.flowIdA)
          .position;

      final end = blocks
          .firstWhere((element) => element.entity.id == conn.flowIdB)
          .position;

      return _buildLine(start, end, false);
    }).toList();
  }

  AnimatedDashedLine _buildLine(Offset start, Offset end, bool isPreview) {
    return AnimatedDashedLine(
      isPreview: isPreview,
      start: start,
      end: end,
      color: Colors.purple,
    );
  }
}
