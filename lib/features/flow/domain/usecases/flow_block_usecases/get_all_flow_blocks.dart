import 'package:flow/core/error/failures.dart';
import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:flow/features/flow/domain/repositories/flow_block_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllFlowBlocks {
  final FlowBlockRepository flowBlockRepository;

  GetAllFlowBlocks(this.flowBlockRepository);

  Future<Either<Failure, List<FlowBlock>>> call() async {
    return flowBlockRepository.getAllFlowBlocks();
  }
}
