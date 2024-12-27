import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'package:flow/features/flow/domain/entities/grid_screen_state.dart'; // We'll define state in the same folder

final gridScreenProvider =
    StateNotifierProvider<GridScreenNotifier, GridScreenState>(
  (ref) => GridScreenNotifier(),
);

class GridScreenNotifier extends StateNotifier<GridScreenState> {
  GridScreenNotifier() : super(GridScreenState.initial());

  void startAnimation(int durationMS) {
    state.isOnAnimation = true;
    Future.delayed(Duration(milliseconds: durationMS), () {
      state.isOnAnimation = false;
    });
  }
}
