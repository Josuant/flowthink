import 'package:flow/features/flow/domain/entities/flow_connection.dart';
import 'package:flow/features/flow/domain/repositories/flow_connection_repository.dart';

class SaveFlowConnection {
  final FlowConnectionRepository _flowConnectionRepository;

  SaveFlowConnection(this._flowConnectionRepository);

  Future<void> call(FlowConnection flowConnection) async {
    return _flowConnectionRepository.saveFlowConnection(flowConnection);
  }
}
