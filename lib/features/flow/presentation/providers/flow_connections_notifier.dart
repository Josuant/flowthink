// flow_connections_notifier.dart
import 'package:flow/features/flow/data/models/flow_connection_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlowConnectionsNotifier extends StateNotifier<List<FlowConnectionModel>> {
  FlowConnectionsNotifier() : super([]);

  void addConnection(FlowConnectionModel connection) {
    state = [...state, connection];
  }

  void removeConnection(String idA, String idB) {
    state = state.where((c) {
      // Or any logic that identifies a connection
      return !((c.flowIdA == idA && c.flowIdB == idB) ||
          (c.flowIdA == idB && c.flowIdB == idA));
    }).toList();
  }

  void updateConnection(FlowConnectionModel updatedConnection) {
    state = state.map((c) {
      if (c.flowIdA == updatedConnection.flowIdA &&
          c.flowIdB == updatedConnection.flowIdB) {
        return updatedConnection;
      }
      return c;
    }).toList();
  }

  void removeConnectionsByBlockId(String blockId) {
    state = state.where((c) {
      return c.flowIdA != blockId && c.flowIdB != blockId;
    }).toList();
  }
}
