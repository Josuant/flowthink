import 'package:flow/core/error/failures.dart';
import 'package:flow/features/flow/data/datasources/flow_block_local_datasource.dart';
import 'package:flow/features/flow/data/models/flow_block_model.dart';
import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:flow/features/flow/domain/repositories/flow_block_repository.dart';
import 'package:fpdart/fpdart.dart';

class FlowBlockRepositoryImpl implements FlowBlockRepository {
  final FlowBlockLocalDatasource _flowBlockLocalDatasource;

  FlowBlockRepositoryImpl(this._flowBlockLocalDatasource);

  @override
  Future<void> deleteFlowBlock(String id) {
    return _flowBlockLocalDatasource.deleteFlowBlock(id);
  }

  @override
  Future<Either<Failure, List<FlowBlock>>> getAllFlowBlocks() async {
    final List<FlowBlockModel> flowBlocks =
        await _flowBlockLocalDatasource.getAllFlowBlocks();
    if (flowBlocks.isEmpty) {
      return left(NoFlowDataError("No flow blocks were found"));
    }
    return right(flowBlocks.map((model) => model.toEntity()).toList());
  }

  @override
  Future<Either<Failure, FlowBlock>> getFlowBlock(String id) async {
    final flowBlock = await _flowBlockLocalDatasource.getFlowBlock(id);
    if (flowBlock == null) {
      return left(NoFlowDataError("No flow blocks were found"));
    }
    return right(flowBlock.toEntity());
  }

  @override
  Future<void> saveFlowBlock(FlowBlock flowBlock) {
    final FlowBlockModel flowBlockModel = FlowBlockModel.fromEntity(flowBlock);

    return _flowBlockLocalDatasource.saveFlowBlock(flowBlockModel);
  }

  @override
  Future<void> updateFlowBlock(FlowBlock flowBlock) {
    final FlowBlockModel flowBlockModel = FlowBlockModel.fromEntity(flowBlock);
    return _flowBlockLocalDatasource.updateFlowBlock(flowBlockModel);
  }
}
