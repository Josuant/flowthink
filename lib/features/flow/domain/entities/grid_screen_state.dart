part of 'package:flow/features/flow/presentation/notifiers/grid_screen_notifier.dart';

class GridScreenState {
  bool isOnAnimation;
  int animationDurationMS;
  TransformationController transformationController;
  FlowBlocksNotifier blocksNotifier;
  FlowConnectionsNotifier connectionsNotifier;
  TrashNotifier trashNotifier;
  TickerProvider? tickerProvider;

  GridScreenState(
      {required this.isOnAnimation,
      required this.animationDurationMS,
      required this.transformationController,
      required this.blocksNotifier,
      required this.connectionsNotifier,
      required this.trashNotifier,
      required this.tickerProvider});

  factory GridScreenState.initial() {
    return GridScreenState(
        isOnAnimation: false,
        animationDurationMS: 500,
        transformationController: TransformationController(),
        blocksNotifier: FlowBlocksNotifier(),
        connectionsNotifier: FlowConnectionsNotifier(),
        trashNotifier: TrashNotifier(),
        tickerProvider: null);
  }

  GridScreenState copyWith({
    bool? isOnAnimation,
    int? animationDurationMS,
    TransformationController? transformationController,
    FlowBlocksNotifier? blocksNotifier,
    FlowConnectionsNotifier? connectionsNotifier,
    TrashNotifier? trashNotifier,
  }) {
    return GridScreenState(
      isOnAnimation: isOnAnimation ?? this.isOnAnimation,
      animationDurationMS: animationDurationMS ?? this.animationDurationMS,
      transformationController:
          transformationController ?? this.transformationController,
      blocksNotifier: blocksNotifier ?? this.blocksNotifier,
      connectionsNotifier: connectionsNotifier ?? this.connectionsNotifier,
      trashNotifier: trashNotifier ?? this.trashNotifier,
      tickerProvider: tickerProvider,
    );
  }
}
