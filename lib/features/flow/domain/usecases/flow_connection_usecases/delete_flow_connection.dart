import 'package:flow/features/flow/domain/repositories/flow_connection_repository.dart';
import 'package:flow/features/flow/utils/enums/flow_connection_direction.dart';

class DeleteFlowConnection {
  final FlowConnectionRepository _flowConnectionRepository;

  DeleteFlowConnection(this._flowConnectionRepository);

  Future<void> call(
      String flowIdA,
      String flowIdB,
      FlowConnectionDirection directionA,
      FlowConnectionDirection directionB) async {
    return _flowConnectionRepository.deleteFlowConnection(
        flowIdA, flowIdB, directionA, directionB);
  }
}
