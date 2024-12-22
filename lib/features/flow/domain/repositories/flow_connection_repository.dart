import 'package:flow/core/error/failures.dart';
import 'package:flow/features/flow/domain/entities/flow_connection.dart';
import 'package:flow/features/flow/utils/enums/flow_connection_direction.dart';
import 'package:fpdart/fpdart.dart';

abstract class FlowConnectionRepository {
  Future<void> saveFlowConnection(FlowConnection flowConnection);
  Future<Either<Failure, FlowConnection>> getFlowConnection(
      String flowIdA,
      String flowIdB,
      FlowConnectionDirection directionA,
      FlowConnectionDirection directionB);
  Future<void> deleteFlowConnection(flowIdA, flowIdB, directionA, directionB);
  Future<void> updateFlowConnection(FlowConnection flowConnection);
  Future<Either<Failure, List<FlowConnection>>> getAllFlowConnections();
  Future<Either<Failure, List<FlowConnection>>> getFlowConnectionsForBlock(
      String flowId);
}
