import 'package:flow/core/error/failures.dart';
import 'package:flow/features/flow/domain/entities/flow_connection.dart';
import 'package:flow/features/flow/domain/repositories/flow_connection_repository.dart';
import 'package:flow/features/flow/utils/enums/flow_block_enums.dart';
import 'package:fpdart/fpdart.dart';

class GetFlowConnection {
  final FlowConnectionRepository _flowConnectionRepository;

  GetFlowConnection(this._flowConnectionRepository);

  Future<Either<Failure, FlowConnection>> call(
      String flowIdA,
      String flowIdB,
      FlowConnectionDirection directionA,
      FlowConnectionDirection directionB) async {
    return _flowConnectionRepository.getFlowConnection(
        flowIdA, flowIdB, directionA, directionB);
  }
}
