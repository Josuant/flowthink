import 'dart:ui';

class TrashState {
  final bool isVisible;
  final bool isBlockNear;
  final double widgetSize;
  final double expandedSize;
  final Offset initialPosition;
  final double distanceThreshold;
  final double outsideWidgetSize;
  final Offset currentPosition;

  const TrashState({
    required this.isVisible,
    required this.isBlockNear,
    required this.initialPosition,
    required this.currentPosition,
    this.widgetSize = 58,
    this.expandedSize = 68,
    this.distanceThreshold = 30.0,
    this.outsideWidgetSize = 100.0,
  });

  TrashState copyWith({
    bool? isVisible,
    bool? isBlockNear,
    Offset? initialPosition,
    double? distanceThreshold,
    double? outsideWidgetSize,
    Offset? currentPosition,
  }) {
    return TrashState(
      isVisible: isVisible ?? this.isVisible,
      isBlockNear: isBlockNear ?? this.isBlockNear,
      initialPosition: initialPosition ?? this.initialPosition,
      distanceThreshold: distanceThreshold ?? this.distanceThreshold,
      outsideWidgetSize: outsideWidgetSize ?? this.outsideWidgetSize,
      currentPosition: currentPosition ?? this.currentPosition,
    );
  }

  factory TrashState.initial() {
    return const TrashState(
      isVisible: false,
      isBlockNear: false,
      initialPosition: Offset.zero,
      currentPosition: Offset.zero,
    );
  }
}
