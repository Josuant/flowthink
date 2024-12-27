import 'dart:ui';

import 'package:flow/features/flow/domain/entities/trash_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final trashNotifierProvider = StateNotifierProvider<TrashNotifier, TrashState>(
  (ref) => TrashNotifier(),
);

class TrashNotifier extends StateNotifier<TrashState> {
  TrashNotifier() : super(TrashState.initial());

  void setVisibility(bool isVisible) {
    state = state.copyWith(isVisible: isVisible);
  }

  void setBlockNear(bool isBlockNear) {
    state = state.copyWith(isBlockNear: isBlockNear);
  }

  void setInitialPosition(Offset initialPosition) {
    state = state.copyWith(initialPosition: initialPosition);
  }

  void setDistanceThreshold(double distanceThreshold) {
    state = state.copyWith(distanceThreshold: distanceThreshold);
  }

  void setOutsideWidgetSize(double outsideWidgetSize) {
    state = state.copyWith(outsideWidgetSize: outsideWidgetSize);
  }

  void setCurrentPosition(Offset currentPosition) {
    state = state.copyWith(currentPosition: currentPosition);
  }

  Rect _getInfluenceZone() {
    return Rect.fromLTWH(
      state.initialPosition.dx - state.distanceThreshold,
      state.initialPosition.dy - state.distanceThreshold,
      state.distanceThreshold + state.widgetSize + state.distanceThreshold,
      state.distanceThreshold + state.widgetSize / 2 + state.distanceThreshold,
    );
  }

  bool veryfyProximity(Offset touchPosition) {
    final influenceZone = _getInfluenceZone();
    final isBlockNear = influenceZone.contains(touchPosition);
    return isBlockNear;
  }

  void updateCurrentPosition(Offset touchPosition) {
    setBlockNear(veryfyProximity(touchPosition));
    if (state.isBlockNear) {
      var current = touchPosition -
          Offset(
            state.expandedSize / 2,
            state.expandedSize / 4,
          );
      setCurrentPosition(current);
    } else {
      setCurrentPosition(state.initialPosition);
    }
  }
}
