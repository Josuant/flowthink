part of 'package:flow/features/flow/presentation/providers/grid_screen_notifier.dart';

class GridScreenState {
  // Basic data
  bool isOnAnimation;
  int animationDurationMS;
  TransformationController transformationController;

  GridScreenState({
    required this.isOnAnimation,
    required this.animationDurationMS,
    required this.transformationController,
  });

  factory GridScreenState.initial() {
    return GridScreenState(
      isOnAnimation: false,
      animationDurationMS: 500,
      transformationController: TransformationController(),
    );
  }

  GridScreenState copyWith({
    bool? isOnAnimation,
    int? animationDurationMS,
  }) {
    return GridScreenState(
      isOnAnimation: isOnAnimation ?? this.isOnAnimation,
      animationDurationMS: animationDurationMS ?? this.animationDurationMS,
      transformationController: transformationController,
    );
  }
}
