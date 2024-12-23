part of 'package:flow/features/flow/presentation/providers/grid_screen_notifier.dart';

class GridScreenState {
  // Basic data
  bool isOnAnimation;
  int animationDurationMS;

  GridScreenState({
    required this.isOnAnimation,
    required this.animationDurationMS,
  });

  factory GridScreenState.initial() {
    return GridScreenState(
      isOnAnimation: false,
      animationDurationMS: 500,
    );
  }

  GridScreenState copyWith({
    bool? isOnAnimation,
    int? animationDurationMS,
  }) {
    return GridScreenState(
      isOnAnimation: isOnAnimation ?? this.isOnAnimation,
      animationDurationMS: animationDurationMS ?? this.animationDurationMS,
    );
  }
}
