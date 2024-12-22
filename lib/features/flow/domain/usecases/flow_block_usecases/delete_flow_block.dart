import 'package:flow/features/flow/domain/repositories/flow_block_repository.dart';

class DeleteFlowBlock {
  final FlowBlockRepository flowBlockRepository;

  DeleteFlowBlock(this.flowBlockRepository);

  Future<void> call(String id) async {
    return flowBlockRepository.deleteFlowBlock(id);
  }
}
