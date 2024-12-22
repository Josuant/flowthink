abstract class Failure {
  final String message;

  Failure(this.message);
}

class NoFlowDataError extends Failure {
  NoFlowDataError(super.message);
}
