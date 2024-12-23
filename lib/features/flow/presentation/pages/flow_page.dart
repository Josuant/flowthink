import 'package:flow/core/widgets/animated_dashed_line.dart';
import 'package:flow/core/widgets/xml_input.dart';
import 'package:flow/features/flow/data/models/flow_connection_model.dart';
import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:flow/features/flow/domain/entities/flow_block_state.dart';
import 'package:flow/features/flow/presentation/widgets/widget_flow_block.dart';
import 'package:flow/features/flow/presentation/widgets/widget_trash.dart';
import 'package:flow/features/flow/presentation/widgets/widget_union_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/features/flow/presentation/providers/grid_screen_notifier.dart';
import 'package:flow/features/flow/presentation/providers/flow_providers.dart';

class FlowPage extends ConsumerWidget {
  const FlowPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gridScreenProvider);

    final blocks = ref.watch(flowBlocksProvider);
    final blocksNotifier = ref.read(flowBlocksProvider.notifier);

    final connections = ref.watch(flowConnectionsProvider);
    final connectionsNotifier = ref.read(flowConnectionsProvider.notifier);

    final screenSize = MediaQuery.of(context).size;
    final trashInitialPosition = Offset(
      screenSize.width / 2 - 50 / 2,
      screenSize.height - 150,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      body: Stack(
        children: [
          // 1) Tap outside to disable editing
          GestureDetector(
            onTap: () => blocksNotifier.setAllEditingFalse(),
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
                      // 2.1) Lines
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => blocksNotifier.setAllEditingFalse(),
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

                      // 2.2) FlowBlocks
                      Stack(
                        children: blocks.map((block) {
                          final id = block.entity.id;
                          return FlowBlockWidget(
                            key: ValueKey(id),
                            state: block,
                            onDrag: (newPosition) {
                              blocksNotifier.onDrag(newPosition, id);
                            },
                            onFinishDrag: (finalPosition) {
                              blocksNotifier.onFinishDrag(id, finalPosition);
                            },
                            onEditing: (text) {
                              blocksNotifier.onEditing(id);
                            },
                            onFinishEditing: (text) {},
                            onStartDrag: (position) {
                              blocksNotifier.setAllEditingFalse();
                              blocksNotifier.onDrag(position, id);
                            },
                            onStartEditing: () {
                              blocksNotifier.setAllEditingFalse();
                              blocksNotifier.setEditing(true, id);
                            },
                          );
                        }).toList(),
                      ),

                      // 2.3) Union indicator
                      if (blocksNotifier.isAnyDragging() &&
                          blocksNotifier.isAnyCollision())
                        UnionIndicator(
                          context: context,
                          anotherBlock: blocksNotifier.getCollisionBlock(),
                          dragPosition: blocksNotifier.getDraggingPosition(),
                        ),

                      // 2.4) Trash widget
                      WidgetTrash(
                        key: WidgetTrash.globalKey,
                        initialPosition: trashInitialPosition,
                        distanceThreshold: 50,
                        outsideWidgetSize: 100,
                        isTrashVisible: false,
                      ),
                    ],
                  ),
                ),
              ),
              // 3) Xml input
              XmlInputWidget(
                onXmlSubmitted: (xml) {},
                hintText: 'Escribe algo...',
              ),
              // 4) Add block button
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build the dashed lines for all connections
  List<AnimatedDashedLine> _buildConnections(
    List<FlowConnectionModel> connections,
    List<FlowBlockState> blocks,
  ) {
    return connections.map((conn) {
      List<Offset> position = _getPosition(blocks, conn.flowIdA, conn.flowIdB);
      return _buildLine(position.first, position.last);
    }).toList();
  }

  // Helper: get start and end positions of a connection
  List<Offset> _getPosition(
      List<FlowBlockState> blocks, String firstIndex, String secondIndex) {
    final widgetA =
        blocks.firstWhere((element) => element.entity.id == firstIndex);
    final widgetB =
        blocks.firstWhere((element) => element.entity.id == secondIndex);

    final start = Offset(
      widgetA.position.dx + widgetA.entity.width / 2,
      widgetA.position.dy + widgetA.entity.height / 2,
    );
    final end = Offset(
      widgetB.position.dx + widgetB.entity.width / 2,
      widgetB.position.dy + widgetB.entity.height / 2,
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
}
