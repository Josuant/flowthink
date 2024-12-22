import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/services/openai_service.dart';

import '../../utils/enums/flow_block_type.dart';
import '../../utils/flow_util.dart'; // For parseXmlToWidgets if needed

part 'package:flow/features/flow/domain/entities/grid_screen_state.dart'; // We'll define state in the same folder

// Provide easy access to the GridScreenNotifier
final gridScreenProvider =
    StateNotifierProvider<GridScreenNotifier, GridScreenState>(
  (ref) => GridScreenNotifier(),
);

class GridScreenNotifier extends StateNotifier<GridScreenState> {
  GridScreenNotifier() : super(GridScreenState.initial()) {
    // On init, add a default "Start Block"
    addWidget("Start Block", FlowBlockType.start, const Offset(100, 100));
    _updateActiveWidgets();
  }

  // --------------- Add your methods below ---------------

  void addWidget(String text, FlowBlockType type, Offset position) {
    final editingNotifier = ValueNotifier<bool>(false);
    final newWidgetData = {
      'id': state.widgetsData.length,
      'text': text,
      'type': type,
      'position': position,
      'width': state.flowProcessWidth,
      'height': state.flowProcessHeight,
      'cornerRadius': type == FlowBlockType.decision ? 0.0 : 15.0,
      'circleRadius': 10.0,
      'connections': <int>[],
      'isDeleted': false,
    };

    state.editingNotifiers.add(editingNotifier);
    state.widgetsData.add(newWidgetData);
    _updateActiveWidgets();
  }

  void _updateActiveWidgets() {
    final active = state.widgetsData
        .asMap()
        .entries
        .where((entry) => !state.erasedWidgets.contains(entry.key))
        .map((e) => e.value)
        .toList();

    state = state.copyWith(activeWidgets: active);
  }

  void addConnection(int firstIndex, int secondIndex) {
    final connections =
        List<int>.from(state.widgetsData[firstIndex]['connections']);
    connections.add(secondIndex);
    state.widgetsData[firstIndex]['connections'] = connections;
  }

  void detectCollision({
    required int draggingWidgetIndex,
    required Offset draggingWidgetPosition,
    required double draggingWidgetWidth,
    required double draggingWidgetHeight,
  }) {
    for (int i = 0; i < state.widgetsData.length; i++) {
      if (state.erasedWidgets.contains(i)) continue;
      if (i == draggingWidgetIndex) continue;

      final widgetData = state.widgetsData[i];
      final widgetPosition = widgetData['position'] as Offset;
      final widgetWidth = widgetData['width'] as double;
      final widgetHeight = widgetData['height'] as double;

      final leftA = widgetPosition.dx;
      final rightA = widgetPosition.dx + widgetWidth;
      final topA = widgetPosition.dy;
      final bottomA = widgetPosition.dy + widgetHeight;

      final leftB = draggingWidgetPosition.dx;
      final rightB = draggingWidgetPosition.dx + draggingWidgetWidth;
      final topB = draggingWidgetPosition.dy;
      final bottomB = draggingWidgetPosition.dy + draggingWidgetHeight;

      if (leftA < rightB &&
          rightA > leftB &&
          topA < bottomB &&
          bottomA > topB &&
          _isIndexValid(i)) {
        // collision found
        state = state.copyWith(collisionIndex: i);
        return;
      }
    }
    // if no collision
    state = state.copyWith(collisionIndex: null);
  }

  bool _isIndexValid(int index) {
    return index >= 0 &&
        index < state.widgetsData.length &&
        !state.erasedWidgets.contains(index);
  }

  void combineWidgets(int indexA, int indexB) {
    if (!_isIndexValid(indexA) || !_isIndexValid(indexB) || indexA == indexB) {
      return;
    }
    final widgetA = state.widgetsData[indexA];
    final widgetB = state.widgetsData[indexB];

    // Combine text
    widgetA['text'] = _combineWidgetTexts(
      widgetA['text'],
      widgetB['text'],
    );

    // Transfer connections
    final connectionsA = Set<int>.from(widgetA['connections']);
    final connectionsB = Set<int>.from(widgetB['connections']);
    widgetA['connections'] = connectionsA.union(connectionsB).toList();

    // Update references in other widgets
    for (var w in state.widgetsData) {
      final conns = w['connections'] as List<int>;
      if (conns.contains(widgetB['id'])) {
        conns.remove(widgetB['id']);
        if (!conns.contains(widgetA['id'])) {
          conns.add(widgetA['id']);
        }
      }
    }

    // Move A to B
    widgetA['position'] = widgetB['position'];
    // Mark B as erased
    state.erasedWidgets.add(widgetB['id']);

    _updateActiveWidgets();
  }

  String _combineWidgetTexts(String textA, String textB) {
    return '$textA + $textB';
  }

  void setWidgetDeleted(int id, bool isDeleted) {
    state.widgetsData[id]['isDeleted'] = isDeleted;
  }

  void removeWidget(int id) {
    state.erasedWidgets.add(id);
    _updateActiveWidgets();
  }

  void setDragging(bool dragging) {
    state = state.copyWith(isDragging: dragging);
  }

  void setTapPosition(Offset position) {
    state = state.copyWith(tapPosition: position);
  }

  void startAnimation(int durationMS) {
    state.isOnAnimation.value = true;
    Future.delayed(Duration(milliseconds: durationMS), () {
      state.isOnAnimation.value = false;
    });
  }

  void checkForDeletedWidgets() {
    int index = 0;
    state.widgetsData.removeWhere((_) {
      final shouldRemove = state.erasedWidgets.contains(index);
      index++;
      return shouldRemove;
    });
    state.erasedWidgets.clear();
    _updateActiveWidgets();
  }

  void updateFlow(String input) {
    // Example usage if you had an XML parser
    final parsed = FlowUtil.parseXmlToWidgets(input);
    state.widgetsData = parsed;
    state.editingNotifiers.clear();

    for (var _ in state.widgetsData) {
      state.editingNotifiers.add(ValueNotifier<bool>(false));
    }

    state.erasedWidgets.clear();
    _updateActiveWidgets();
    startAnimation(500);
  }

  // Example openAI usage
  void sendMessage(String text) {
    if (text.isNotEmpty) {
      state.messages.add('Tú: $text');
      state.openAIService.sendMessage(text);
    }
    // trigger rebuild
    state = state.copyWith(messages: state.messages);
  }

  void startRecording() async {
    await state.openAIService.startRecording();
  }

  void stopRecording() async {
    await state.openAIService.stopRecording();
  }
}
