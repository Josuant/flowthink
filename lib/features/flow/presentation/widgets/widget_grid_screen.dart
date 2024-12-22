import 'package:flow/core/widgets/grid/grid_display.dart';
import 'package:flow/core/widgets/widget_trash.dart';
import 'package:flow/core/widgets/xml_input.dart';
import 'package:flow/features/flow/data/models/flow_block_model.dart';
import 'package:flow/features/flow/data/models/flow_connection_model.dart';
import 'package:flow/features/flow/presentation/flow_styles.dart';
import 'package:flow/features/flow/presentation/providers/grid_screen_notifier.dart';
import 'package:flow/features/flow/presentation/widgets/widget_flow_block.dart';

import 'package:flow/features/flow/presentation/providers/flow_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/enums/flow_block_type.dart';
import '../../../../core/widgets/animated_dashed_line.dart';

class GridScreen extends ConsumerWidget {
  const GridScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gridScreenProvider);
    final notifier = ref.read(gridScreenProvider.notifier);

    final blocks = ref.watch(flowBlocksProvider);
    final blocksNotifier = ref.read(flowBlocksProvider.notifier);

    final connections = ref.watch(flowConnectionsProvider);
    final connectionsNotifier = ref.read(flowConnectionsProvider.notifier);

    final screenSize = MediaQuery.of(context).size;
    final trashInitialPosition = Offset(
      screenSize.width / 2 - state.trashSize / 2,
      screenSize.height - 150,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      body: Stack(
        children: [
          // 1) Tap outside to disable editing
          GestureDetector(
            onTap: () {
              for (var notifierBool in state.editingNotifiers) {
                notifierBool.value = false;
              }
            },
            behavior: HitTestBehavior.translucent,
            child: Container(),
          ),

          // 2) Main stack with InteractiveViewer
          Stack(
            children: [
              InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(double.infinity),
                minScale: 0.5,
                maxScale: 3.0,
                constrained: false,
                child: SizedBox(
                  width: screenSize.width * 2,
                  height: screenSize.height * 2,
                  child: Stack(
                    children: [
                      // 2.0) Grid background
                      const GridDisplay(),

                      // 2.1) Lines
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          for (var notifierBool in state.editingNotifiers) {
                            notifierBool.value = false;
                          }
                        },
                        child: Stack(
                            children: _buildConnections(connections, blocks)),
                      ),

                      // 2.2) FlowBlocks
                      Stack(
                        children: blocks.map((data) {
                          final id = data.id;
                          return FlowBlock(
                            key: ValueKey(id),
                            text: data.text,
                            cornerRadius: data.cornerRadius,
                            width: data.width,
                            height: data.height,
                            position: data.position,
                            startEditing: state.editingNotifiers[id].value,
                            type: data.type,
                            onDrag: (Offset newPosition) {
                              notifier.setDragging(true);
                              notifier.setTapPosition(newPosition);
                              // Update the local position in widgetsData
                              data['position'] = newPosition;

                              // Detect collisions
                              notifier.detectCollision(
                                draggingWidgetIndex: id,
                                draggingWidgetPosition: newPosition,
                                draggingWidgetWidth: data['width'],
                                draggingWidgetHeight: data['height'],
                              );

                              // Possibly notify trash about proximity
                              final trashState =
                                  WidgetTrash.globalKey.currentState;
                              if (trashState != null) {
                                trashState.notifyProximity(newPosition);
                              }
                            },
                            onFinishDrag: (Offset finalPosition) {
                              // If near trash, delete
                              if ((WidgetTrash.globalKey.currentState?.isNear ??
                                  false)) {
                                notifier.setWidgetDeleted(id, true);
                                Future.delayed(
                                    Duration(
                                        milliseconds: state.deletedDurationMS),
                                    () {
                                  notifier.removeWidget(id);
                                  notifier.startAnimation(500);
                                });
                              }
                              // If collision
                              if (state.collisionIndex != null) {
                                final collisionIdx = state.collisionIndex!;
                                notifier.setWidgetDeleted(collisionIdx, true);
                                Future.delayed(
                                    Duration(
                                        milliseconds: state.deletedDurationMS),
                                    () {
                                  notifier.combineWidgets(id, collisionIdx);
                                  notifier.startAnimation(500);
                                });
                              }
                              notifier.setDragging(false);
                            },
                            onEditing: () {
                              // Called when user enters editing -
                              // up to you if you need something here
                            },
                            onCreateWidget:
                                (Offset position, Offset circlePosition) {
                              final newId = state.widgetsData.length;
                              notifier.addWidget(
                                "New Block $newId",
                                FlowBlockType.process,
                                position,
                              );
                              notifier.addConnection(id, newId);
                            },
                          );
                        }).toList(),
                      ),

                      // 2.3) Union indicator
                      if (state.isDragging && state.collisionIndex != null)
                        _buildUnionIndicator(
                          context,
                          state,
                          state.collisionIndex!,
                          state.tapPosition,
                        ),

                      // 2.4) Trash widget
                      WidgetTrash(
                        key: WidgetTrash.globalKey,
                        widgetSize: state.trashSize,
                        expandedSize: state.trashExpandedSize,
                        initialPosition: trashInitialPosition,
                        distanceThreshold: 50,
                        outsideWidgetSize: state.flowProcessHeight,
                        isTrashVisible: state.isDragging,
                      ),
                    ],
                  ),
                ),
              ),
              // 3) Xml input
              XmlInputWidget(
                onXmlSubmitted: notifier.sendMessage,
                hintText: 'Escribe algo...',
              ),

              // 4) Display last message
              if (state.messages.isNotEmpty) Text(state.messages.last),
            ],
          ),
        ],
      ),
    );
  }

  // Build the dashed lines for all connections
  List<AnimatedDashedLine> _buildConnections(
    List<FlowConnectionModel> connections,
    List<FlowBlockModel> blocks,
  ) {
    return connections.map((conn) {
      List<Offset> position = _getPosition(blocks, conn.flowIdA, conn.flowIdB);
      return _buildLine(position.first, position.last);
    }).toList();
  }

  // Helper: get start and end positions of a connection
  List<Offset> _getPosition(
      List<FlowBlockModel> blocks, String firstIndex, String secondIndex) {
    final widgetA = blocks.firstWhere((element) => element.id == firstIndex);
    final widgetB = blocks.firstWhere((element) => element.id == secondIndex);

    final start = Offset(
      widgetA.position.dx + widgetA.width / 2,
      widgetA.position.dy + widgetA.height / 2,
    );
    final end = Offset(
      widgetB.position.dx + widgetB.width / 2,
      widgetB.position.dy + widgetB.height / 2,
    );
    return [start, end];
  }

  AnimatedDashedLine _buildLine(Offset start, Offset end) {
    return AnimatedDashedLine(
      isPreview: false,
      start: start,
      end: end,
      color: Colors.purple,
    );
  }

  // Build the union indicator when dragging near another block
  Widget _buildUnionIndicator(
    BuildContext context,
    GridScreenState state,
    int collisionIndex,
    Offset dragPosition,
  ) {
    if (!_isIndexValid(state, collisionIndex)) {
      return const SizedBox.shrink();
    }

    final anotherBlockPos =
        state.widgetsData[collisionIndex]['position'] as Offset;
    const iconSize = 20.0;
    const circleRadius = 15.0;
    final width = state.flowProcessWidth;
    final height = state.flowProcessHeight;

    return Transform.translate(
      offset: anotherBlockPos + const Offset(5, 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(circleRadius),
        child: Transform.translate(
          offset: -anotherBlockPos + dragPosition,
          child: Stack(
            children: [
              Container(
                width: width,
                height: height,
                decoration:
                    FlowStyles.buldBoxDecoration(true, false, false, 10.0),
              ),
              Transform.translate(
                offset: (-(dragPosition - anotherBlockPos) +
                        Offset(width - iconSize, height - iconSize)) /
                    2,
                child: const Icon(
                  Icons.add,
                  size: iconSize,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isIndexValid(GridScreenState state, int index) {
    return index >= 0 &&
        index < state.widgetsData.length &&
        !state.erasedWidgets.contains(index);
  }
}
