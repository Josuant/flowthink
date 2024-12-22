import 'package:flow/features/flow/data/models/flow_block_model.dart';
import 'package:hive/hive.dart';

class FlowBlockLocalDatasource {
  final Box<FlowBlockModel> _flowBlockBox;

  FlowBlockLocalDatasource(this._flowBlockBox);

  Future<void> saveFlowBlock(FlowBlockModel block) async {
    await _flowBlockBox.add(block);
  }

  Future<FlowBlockModel?> getFlowBlock(String id) async {
    return _flowBlockBox.get(id);
  }

  Future<List<FlowBlockModel>> getAllFlowBlocks() async {
    return _flowBlockBox.values.toList();
  }

  Future<void> deleteFlowBlock(String id) async {
    return _flowBlockBox.delete(id);
  }

  Future<void> updateFlowBlock(FlowBlockModel block) async {
    return _flowBlockBox.put(block.id, block);
  }
}
