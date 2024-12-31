import 'package:flow/features/flow/presentation/widgets/widget_grid.dart';
import 'package:flow/features/flow/utils/flow_animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flow/core/widgets/animated_dashed_line.dart';
import 'package:flow/core/widgets/xml_input.dart';

import 'package:flow/features/flow/domain/entities/flow_block_state.dart';
import 'package:flow/features/flow/domain/entities/flow_connection.dart';
import 'package:flow/features/flow/domain/entities/trash_state.dart';

import 'package:flow/features/flow/presentation/widgets/widget_flow_block.dart';
import 'package:flow/features/flow/presentation/widgets/widget_flow_static_block.dart';
import 'package:flow/features/flow/presentation/widgets/widget_trash.dart';
import 'package:flow/features/flow/presentation/widgets/widget_union_indicator.dart';
import 'package:flow/features/flow/presentation/notifiers/grid_screen_notifier.dart';

import 'package:flow/features/flow/presentation/providers/flow_providers.dart';

class FlowPage extends ConsumerStatefulWidget {
  const FlowPage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<FlowPage> createState() => _FlowPageState();
}

class _FlowPageState extends ConsumerState<FlowPage>
    with TickerProviderStateMixin {
  late Size screenSize;
  late Offset trashInitialPosition;
  late GridScreenNotifierAnimator screenNotifier;

  @override
  void initState() {
    super.initState();
    screenNotifier = ref.read(gridScreenProvider.notifier);
    screenNotifier.setBlocksNotifier(ref.read(flowBlocksProvider.notifier));
    screenNotifier
        .setConnectionsNotifier(ref.read(flowConnectionsProvider.notifier));
    screenNotifier.setTrashNotifier(ref.read(trashProvider.notifier));
    screenNotifier.setTickerProvider(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenSize = MediaQuery.of(context).size;
    trashInitialPosition = Offset(
      screenSize.width / 2 - 50 / 2,
      screenSize.height - 250,
    );
    centerScreen(ref.read(gridScreenProvider));
  }

  @override
  Widget build(BuildContext context) {
    final screenState = ref.watch(gridScreenProvider);

    final blocks = ref.watch(flowBlocksProvider);

    final connections = ref.watch(flowConnectionsProvider);

    final TrashState trashState = ref.watch(trashProvider);

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
                transformationController: screenState.transformationController,
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
                      onTapDown: (position) => screenNotifier.tapOnScreen(),
                      onDoubleTapDown: (details) =>
                          screenNotifier.doubleTapOnScreen(details),
                      child: Stack(
                          children: _buildConnections(connections, blocks)),
                    ),
                    // 1.5) New Block line UI
                    if (screenState.blocksNotifier.isAnyPanUpdating() &&
                        !screenState.blocksNotifier
                            .isPanUpdatingTapPositionCollidingWithItself())
                      _buildLine(
                        screenState.blocksNotifier
                            .getPanUpdatingBlock()
                            .position,
                        screenState.blocksNotifier
                                .isPanUpdatingTapPositionColliding()
                            ? screenState.blocksNotifier
                                .getPanUpdatingCollidingBlock()
                                .position
                            : screenState.blocksNotifier.getPanningPosition(),
                        true,
                      ),

                    // 1.2) FlowBlocks
                    Stack(
                      children: blocks.map((block) {
                        final id = block.entity.id;
                        return FlowBlockWidget(
                          key: ValueKey(id),
                          state: block,
                          onDrag: (position) =>
                              screenNotifier.onDrag(position, id),
                          onDragEnd: (position) =>
                              screenNotifier.onDragEnd(id, position),
                          onEditing: (text) => screenNotifier.onEditing(id),
                          onEditingEnd: (text) {},
                          onDragStart: (position) => screenNotifier.onDragStart(
                              position, id, trashInitialPosition),
                          onEditingStart: () =>
                              screenNotifier.onEditingStart(id),
                          onLongPressDown: (position) =>
                              screenNotifier.onLongPressDown(id),
                          onPanUpdate: (position) =>
                              screenNotifier.onPanUpdate(id, position),
                          onPanEnd: (position) =>
                              screenNotifier.onPanEnd(id, position),
                        );
                      }).toList(),
                    ),

                    // 1.3) Union indicator
                    if (screenState.blocksNotifier.isAnyBlockColliding() &&
                        screenState.blocksNotifier.isAnyDragging())
                      UnionIndicator(
                        context: context,
                        anotherBlock: screenState.blocksNotifier
                            .getDraggingCollidingBlock(),
                        dragPosition:
                            screenState.blocksNotifier.getDraggingPosition(),
                      ),

                    // 1.5) New Block UI
                    if (screenState.blocksNotifier.isAnyPanUpdating())
                      WidgetFlowAnimatedBlock(
                        isUnion: false,
                        isLongPressDown: !screenState.blocksNotifier
                            .isPanUpdatingTapPositionColliding(),
                        isEditing: false,
                        opacity: screenState.blocksNotifier
                                    .isPanUpdatingTapPositionCollidingWithItself() ||
                                screenState.blocksNotifier
                                    .isPanUpdatingTapPositionColliding()
                            ? 0.3
                            : 1.0,
                        position:
                            screenState.blocksNotifier
                                    .isPanUpdatingTapPositionColliding()
                                ? screenState.blocksNotifier
                                    .getPanUpdatingCollidingBlock()
                                    .position
                                : screenState.blocksNotifier
                                    .getPanningPosition(),
                      )
                  ]),
                ),
              ),
              // 2) Xml input
              XmlInputWidget(
                onXmlSubmitted: (xml) {
                  FlowAnimator.executeList(xml, screenNotifier);
                },
                hintText: 'Escribe algo...',
              ),
              // 3) Simulate button
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

  void centerScreen(GridScreenState screenState) {
    screenState.transformationController.value = Matrix4.identity()
      ..translate(
          (-2000 + screenSize.width) / 2, (-2000 + screenSize.height) / 2)
      ..scale(1.0);
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
