import 'package:flow/core/error/failures.dart';
import 'package:flow/features/flow/domain/entities/flow_connection.dart';
import 'package:flow/features/flow/domain/repositories/flow_connection_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllFlowConnections {
  final FlowConnectionRepository _flowConnectionRepository;

  GetAllFlowConnections(this._flowConnectionRepository);

  Future<Either<Failure, List<FlowConnection>>> call() async {
    return _flowConnectionRepository.getAllFlowConnections();
  }
}
