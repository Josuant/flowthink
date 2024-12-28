import 'dart:convert';
import 'dart:math';

import 'package:flow/features/flow/domain/entities/action_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActionNotifier extends StateNotifier<ActionState> {
  ActionNotifier() : super(ActionState());

  Future<void> executeActions(List<Map<String, dynamic>> actions) async {
    for (var action in actions) {
      state = ActionState(isExecuting: true, currentAction: action['type']);
      await _simulateAction(action);
      await Future.delayed(const Duration(milliseconds: 100));
    }
    state = ActionState(isExecuting: false, currentAction: null);
  }

  Future<void> _simulateAction(Map<String, dynamic> action) async {
    switch (action['type']) {
      case 'tap':
        await simulateTap(action['x'], action['y']); // Simular acción
        break;
      case 'double_tap':
        await simulateDoubleTap(action['x'], action['y']); // Simular acción
        break;
      case 'long_press':
        await simulateLongPress(
            action['x'], action['y'], action['duration'] ?? 1000);
        break;
      case 'swipe':
        await simulateSwipe(action['fromX'], action['fromY'], action['toX'],
            action['toY'], action['duration'] ?? 1000);
        break;
      case 'move':
        await simulateMove(action['fromX'], action['fromY'], action['toX'],
            action['toY'], action['duration'] ?? 1000);
        break;
      default:
        throw Exception('Unknown action type: ${action['type']}');
    }
  }

  Future<void> simulateTap(double x, double y) async {
    final gestureBinding = GestureBinding.instance;
    gestureBinding.handlePointerEvent(PointerDownEvent(position: Offset(x, y)));
    await Future.delayed(const Duration(milliseconds: 100));
    gestureBinding.handlePointerEvent(PointerUpEvent(position: Offset(x, y)));
    gestureBinding.gestureArena.release(1);
  }

  Future<void> simulateDoubleTap(double x, double y) async {
    simulateTap(x, y);
    await Future.delayed(const Duration(milliseconds: 100));
    simulateTap(x, y);
  }

  Future<void> simulateLongPress(double x, double y, int duration) async {
    final gestureBinding = GestureBinding.instance;
    gestureBinding.handlePointerEvent(PointerDownEvent(position: Offset(x, y)));
    await Future.delayed(Duration(milliseconds: duration));
    gestureBinding.handlePointerEvent(PointerUpEvent(position: Offset(x, y)));
  }

  Future<void> simulateSwipe(
      double fromX, double fromY, double toX, double toY, int duration) async {
    final gestureBinding = GestureBinding.instance;
    const steps = 10;
    final dx = (toX - fromX) / steps;
    final dy = (toY - fromY) / steps;
    final interval = Duration(milliseconds: (duration / steps).round());

    for (int i = 0; i <= steps; i++) {
      gestureBinding.handlePointerEvent(PointerMoveEvent(
        position: Offset(fromX + dx * i, fromY + dy * i),
      ));
      await Future.delayed(interval);
    }
    gestureBinding
        .handlePointerEvent(PointerUpEvent(position: Offset(toX, toY)));
  }

  Future<void> simulateMove(
      double fromX, double fromY, double toX, double toY, int duration) async {
    final gestureBinding = GestureBinding.instance;
    final distance = sqrt(pow(toX - fromX, 2) + pow(toY - fromY, 2));

    var steps = distance / 28; // 28 pixels per step
    final dx = (toX - fromX) / steps;
    final dy = (toY - fromY) / steps;

    // PointerDownEvent: inicia el movimiento
    gestureBinding.handlePointerEvent(
        PointerDownEvent(position: Offset(fromX, fromY), pointer: 1));
    await Future.delayed(Duration(milliseconds: 500));

    // Genera una lista de eventos
    List<PointerMoveEvent> events = [];
    for (int i = 1; i <= steps; i++) {
      events.add(
        PointerMoveEvent(
          position: Offset(fromX + dx * i, fromY + dy * i),
          pointer: 1,
        ),
      );
    }

    print(events);

    // Procesa los eventos a intervalos definidos
    for (var event in events) {
      gestureBinding.handlePointerEvent(event);
      await Future.delayed(Duration(milliseconds: 0));
    }

    // PointerUpEvent: finaliza el movimiento
    gestureBinding.handlePointerEvent(
        PointerUpEvent(position: Offset(toX, toY), pointer: 1));
  }

  static List<Map<String, dynamic>> jsonToActions(String jsonString) {
    return List<Map<String, dynamic>>.from(jsonDecode(jsonString));
  }
}
