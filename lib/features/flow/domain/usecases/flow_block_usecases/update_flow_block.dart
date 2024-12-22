import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:flow/features/flow/domain/repositories/flow_block_repository.dart';

class UpdateFlowBlock {
  final FlowBlockRepository flowBlockRepository;

  UpdateFlowBlock(this.flowBlockRepository);

  Future<void> call(FlowBlock flowBlock) async {
    return flowBlockRepository.updateFlowBlock(flowBlock);
  }
}
