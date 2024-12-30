import 'package:flow/core/error/failures.dart';
import 'package:flow/features/flow/data/datasources/flow_connection_local_datasource.dart';
import 'package:flow/features/flow/data/models/flow_connection_model.dart';
import 'package:flow/features/flow/domain/entities/flow_connection.dart';
import 'package:flow/features/flow/domain/repositories/flow_connection_repository.dart';
import 'package:flow/features/flow/utils/enums/flow_block_enums.dart';
import 'package:fpdart/fpdart.dart';

class FlowConnectionRepositoryImpl implements FlowConnectionRepository {
  final FlowConnectionLocalDatasource _flowConnectionLocalDatasource;

  FlowConnectionRepositoryImpl(this._flowConnectionLocalDatasource);

  @override
  Future<void> deleteFlowConnection(flowIdA, flowIdB, directionA, directionB) {
    return _flowConnectionLocalDatasource.deleteFlowConnection(
        flowIdA, flowIdB, directionA, directionB);
  }

  @override
  Future<Either<Failure, List<FlowConnection>>> getAllFlowConnections() async {
    List<FlowConnectionModel> flowConnectionsModel =
        await _flowConnectionLocalDatasource.getAllFlowConnections();

    if (flowConnectionsModel.isEmpty) {
      return left(NoFlowDataError("No flow blocks were found"));
    }

    return right(
        flowConnectionsModel.map((model) => model.toEntity()).toList());
  }

  @override
  Future<Either<Failure, FlowConnection>> getFlowConnection(
      String flowIdA,
      String flowIdB,
      FlowConnectionDirection directionA,
      FlowConnectionDirection directionB) async {
    final model = await _flowConnectionLocalDatasource.getFlowConnection(
        flowIdA, flowIdB, directionA, directionB);
    if (model == null) {
      return left(NoFlowDataError("No flow blocks were found"));
    }
    return right(model.toEntity());
  }

  @override
  Future<Either<Failure, List<FlowConnection>>> getFlowConnectionsForBlock(
      String flowId) async {
    List<FlowConnectionModel> flowConnectionsModel =
        _flowConnectionLocalDatasource.getFlowConnectionsForBlock(flowId);

    if (flowConnectionsModel.isEmpty) {
      return left(NoFlowDataError("No flow connections found for flow"));
    }

    return right(
        flowConnectionsModel.map((model) => model.toEntity()).toList());
  }

  @override
  Future<void> saveFlowConnection(FlowConnection flowConnection) {
    return _flowConnectionLocalDatasource
        .saveFlowConnection(FlowConnectionModel.fromEntity(flowConnection));
  }

  @override
  Future<void> updateFlowConnection(FlowConnection flowConnection) {
    return _flowConnectionLocalDatasource
        .updateFlowConnection(FlowConnectionModel.fromEntity(flowConnection));
  }
}
