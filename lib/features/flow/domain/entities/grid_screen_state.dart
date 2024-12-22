part of 'package:flow/features/flow/presentation/providers/grid_screen_notifier.dart';

class GridScreenState {
  // Basic data
  List<Map<String, dynamic>> widgetsData;
  final List<Map<String, dynamic>> activeWidgets;
  final List<ValueNotifier<bool>> editingNotifiers;
  final List<int> erasedWidgets;
  final ValueNotifier<bool> isOnAnimation;
  final double flowProcessWidth;
  final double flowProcessHeight;
  final double trashSize;
  final double trashExpandedSize;
  final int deletedDurationMS;
  final OpenAIService openAIService; // hypothetical service
  final List<String> messages;

  // Interaction states
  final int? collisionIndex;
  final bool isDragging;
  final Offset tapPosition;

  GridScreenState({
    required this.widgetsData,
    required this.activeWidgets,
    required this.editingNotifiers,
    required this.erasedWidgets,
    required this.isOnAnimation,
    required this.flowProcessWidth,
    required this.flowProcessHeight,
    required this.trashSize,
    required this.trashExpandedSize,
    required this.deletedDurationMS,
    required this.openAIService,
    required this.messages,
    required this.collisionIndex,
    required this.isDragging,
    required this.tapPosition,
  });

  factory GridScreenState.initial() {
    return GridScreenState(
      widgetsData: [],
      activeWidgets: [],
      editingNotifiers: [],
      erasedWidgets: [],
      isOnAnimation: ValueNotifier<bool>(false),
      flowProcessWidth: 150.0,
      flowProcessHeight: 60.0,
      trashSize: 70.0,
      trashExpandedSize: 140.0,
      deletedDurationMS: 200,
      openAIService: OpenAIService(apiKey: ''), // Example
      messages: [],
      collisionIndex: null,
      isDragging: false,
      tapPosition: Offset.zero,
    );
  }

  GridScreenState copyWith({
    List<Map<String, dynamic>>? widgetsData,
    List<Map<String, dynamic>>? activeWidgets,
    List<ValueNotifier<bool>>? editingNotifiers,
    List<int>? erasedWidgets,
    ValueNotifier<bool>? isOnAnimation,
    double? flowProcessWidth,
    double? flowProcessHeight,
    double? trashSize,
    double? trashExpandedSize,
    int? deletedDurationMS,
    OpenAIService? openAIService,
    List<String>? messages,
    int? collisionIndex,
    bool? isDragging,
    Offset? tapPosition,
  }) {
    return GridScreenState(
      widgetsData: widgetsData ?? this.widgetsData,
      activeWidgets: activeWidgets ?? this.activeWidgets,
      editingNotifiers: editingNotifiers ?? this.editingNotifiers,
      erasedWidgets: erasedWidgets ?? this.erasedWidgets,
      isOnAnimation: isOnAnimation ?? this.isOnAnimation,
      flowProcessWidth: flowProcessWidth ?? this.flowProcessWidth,
      flowProcessHeight: flowProcessHeight ?? this.flowProcessHeight,
      trashSize: trashSize ?? this.trashSize,
      trashExpandedSize: trashExpandedSize ?? this.trashExpandedSize,
      deletedDurationMS: deletedDurationMS ?? this.deletedDurationMS,
      openAIService: openAIService ?? this.openAIService,
      messages: messages ?? this.messages,
      collisionIndex: collisionIndex,
      isDragging: isDragging ?? this.isDragging,
      tapPosition: tapPosition ?? this.tapPosition,
    );
  }
}
