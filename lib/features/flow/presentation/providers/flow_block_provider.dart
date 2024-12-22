import 'package:flow/features/flow/data/datasources/flow_block_local_datasource.dart';
import 'package:flow/features/flow/data/models/flow_block_model.dart';
import 'package:flow/features/flow/data/repositories/flow_block_repository_impl.dart';
import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:flow/features/flow/domain/repositories/flow_block_repository.dart';
import 'package:flow/features/flow/domain/usecases/flow_block_usecases/delete_flow_block.dart';
import 'package:flow/features/flow/domain/usecases/flow_block_usecases/get_all_flow_blocks.dart';
import 'package:flow/features/flow/domain/usecases/flow_block_usecases/get_flow_block.dart';
import 'package:flow/features/flow/domain/usecases/flow_block_usecases/save_flow_block.dart';
import 'package:flow/features/flow/domain/usecases/flow_block_usecases/update_flow_block.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final flowBlockLocalDatasourceProvider =
    Provider<FlowBlockLocalDatasource>((ref) {
  final Box<FlowBlockModel> flowBlockBox = Hive.box('flowBlocks');
  return FlowBlockLocalDatasource(flowBlockBox);
});

final flowBlockRepositoryProvider = Provider<FlowBlockRepository>((ref) {
  final localDataSource = ref.read(flowBlockLocalDatasourceProvider);
  return FlowBlockRepositoryImpl(localDataSource);
});

final getAllFlowBlocksProvider = Provider<GetAllFlowBlocks>((ref) {
  final repository = ref.read(flowBlockRepositoryProvider);
  return GetAllFlowBlocks(repository);
});

final saveFlowBlockProvider = Provider<SaveFlowBlock>((ref) {
  final repository = ref.read(flowBlockRepositoryProvider);
  return SaveFlowBlock(repository);
});

final deleteFlowBlockProvider = Provider<DeleteFlowBlock>((ref) {
  final repository = ref.read(flowBlockRepositoryProvider);
  return DeleteFlowBlock(repository);
});

final getFlowBlockProvider = Provider<GetFlowBlock>((ref) {
  final repository = ref.read(flowBlockRepositoryProvider);
  return GetFlowBlock(repository);
});

final updateFlowBlockProvider = Provider<UpdateFlowBlock>((ref) {
  final repository = ref.read(flowBlockRepositoryProvider);
  return UpdateFlowBlock(repository);
});

class FlowBlockListNotifier extends StateNotifier<List<FlowBlock>> {
  final GetAllFlowBlocks _getAllFlowBlocks;
  final SaveFlowBlock _saveFlowBlock;
  final DeleteFlowBlock _deleteFlowBlock;
  final UpdateFlowBlock _updateFlowBlock;

  FlowBlockListNotifier(super.state, this._getAllFlowBlocks,
      this._saveFlowBlock, this._deleteFlowBlock, this._updateFlowBlock);

  Future<void> getAllFlowBlocks() async {
    final flowBlocksOrFailure = await _getAllFlowBlocks();
    flowBlocksOrFailure.fold(
        (error) => state = [], (flowBlocks) => state = flowBlocks);
  }

  Future<void> saveFlowBlock(FlowBlock flowBlock) async {
    await _saveFlowBlock(flowBlock);
  }

  Future<void> deleteFlowBlock(String id) async {
    await _deleteFlowBlock(id);
  }

  Future<void> updateFlowBlock(FlowBlock flowBlock) async {
    await _updateFlowBlock(flowBlock);
  }
}
