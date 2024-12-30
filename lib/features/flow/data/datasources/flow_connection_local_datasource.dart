import 'package:flow/features/flow/data/models/flow_connection_model.dart';
import 'package:flow/features/flow/utils/enums/flow_block_enums.dart';
import 'package:hive/hive.dart';

class FlowConnectionLocalDatasource {
  final Box<FlowConnectionModel> _flowConnectionBox;

  FlowConnectionLocalDatasource(this._flowConnectionBox);

  Future<void> saveFlowConnection(FlowConnectionModel block) async {
    await _flowConnectionBox.add(block);
  }

  Future<FlowConnectionModel?> getFlowConnection(
      String flowIdA,
      String flowIdB,
      FlowConnectionDirection directionA,
      FlowConnectionDirection directionB) async {
    return _flowConnectionBox.get([flowIdA, flowIdB, directionA, directionB]);
  }

  Future<List<FlowConnectionModel>> getAllFlowConnections() async {
    return _flowConnectionBox.values.toList();
  }

  Future<void> deleteFlowConnection(
      String flowIdA,
      String flowIdB,
      FlowConnectionDirection directionA,
      FlowConnectionDirection directionB) async {
    return _flowConnectionBox
        .delete([flowIdA, flowIdB, directionA, directionB]);
  }

  Future<void> updateFlowConnection(FlowConnectionModel connection) async {
    return _flowConnectionBox.put([
      connection.flowIdA,
      connection.flowIdB,
      connection.flowConnectionDirectionA,
      connection.flowConnectionDirectionB
    ], connection);
  }

  List<FlowConnectionModel> getFlowConnectionsForBlock(String flowId) {
    return _flowConnectionBox.values
        .where((connection) =>
            connection.flowIdA == flowId || connection.flowIdB == flowId)
        .toList();
  }
}
