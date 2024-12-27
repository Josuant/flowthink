// flow_connections_notifier.dart
import 'package:flow/features/flow/domain/entities/flow_connection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlowConnectionsNotifier extends StateNotifier<List<FlowConnection>> {
  FlowConnectionsNotifier() : super([]);

  void addConnection(FlowConnection connection) {
    state = [...state, connection];
  }

  void removeConnection(String idA, String idB) {
    state = state.where((c) {
      // Or any logic that identifies a connection
      return !((c.flowIdA == idA && c.flowIdB == idB) ||
          (c.flowIdA == idB && c.flowIdB == idA));
    }).toList();
  }

  void updateConnection(FlowConnection updatedConnection) {
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

  void mergeConnections(String flowBlockA, String flowBlockB,
      {bool allowSelfConnections = false}) {
    // Validación básica para evitar procesar datos inválidos
    if (flowBlockA == flowBlockB) return;

    // Filtra conexiones asociadas a B
    final connectionsB =
        state.where((c) => c.flowIdA == flowBlockB || c.flowIdB == flowBlockB);

    // Genera nuevas conexiones reemplazando B con A
    final newConnections = connectionsB
        .map((connection) {
          final updatedConnection = connection.flowIdA == flowBlockB
              ? connection.copyWith(flowIdA: flowBlockA)
              : connection.copyWith(flowIdB: flowBlockA);

          // Si no se permiten auto-conexiones, filtrarlas
          if (!allowSelfConnections &&
              updatedConnection.flowIdA == updatedConnection.flowIdB) {
            return null; // Retorna null si es una auto-conexión no permitida
          }
          return updatedConnection;
        })
        .whereType<FlowConnection>()
        .toList(); // Filtra nulls

    // Actualiza el estado eliminando conexiones de B y añadiendo las nuevas
    state = [
      ...state.where((c) => c.flowIdA != flowBlockB && c.flowIdB != flowBlockB),
      ...newConnections,
    ];
  }
}
