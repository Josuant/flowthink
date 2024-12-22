import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:flow/features/flow/domain/repositories/flow_block_repository.dart';

class SaveFlowBlock {
  final FlowBlockRepository flowBlockRepository;

  SaveFlowBlock(this.flowBlockRepository);

  Future<void> call(FlowBlock flowBlock) async {
    return flowBlockRepository.saveFlowBlock(flowBlock);
  }
}
