import 'package:flow/core/error/failures.dart';
import 'package:flow/features/flow/domain/entities/flow_connection.dart';
import 'package:flow/features/flow/domain/repositories/flow_connection_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetFlowConnectionsForBlock {
  final FlowConnectionRepository _flowConnectionRepository;

  GetFlowConnectionsForBlock(this._flowConnectionRepository);

  Future<Either<Failure, List<FlowConnection>>> call(String flowId) async {
    return _flowConnectionRepository.getFlowConnectionsForBlock(flowId);
  }
}
