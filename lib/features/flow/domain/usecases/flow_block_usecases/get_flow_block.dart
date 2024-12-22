import 'package:flow/core/error/failures.dart';
import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:flow/features/flow/domain/repositories/flow_block_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetFlowBlock {
  final FlowBlockRepository flowBlockRepository;

  GetFlowBlock(this.flowBlockRepository);

  Future<Either<Failure, FlowBlock>> call(String id) async {
    return flowBlockRepository.getFlowBlock(id);
  }
}
