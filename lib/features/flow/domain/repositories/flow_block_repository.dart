import 'package:flow/core/error/failures.dart';
import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:fpdart/fpdart.dart';

abstract class FlowBlockRepository {
  /// Retrieves a specific FlowBlock by its ID.
  ///
  /// [id] The unique identifier of the FlowBlock to retrieve.
  ///
  /// Returns a [Future] that completes with the [FlowBlock] matching the given ID.
  Future<Either<Failure, FlowBlock>> getFlowBlock(String id);

  /// Retrieves all available FlowBlocks.
  ///
  /// Returns a [Future] that completes with a [List] of all [FlowBlock] objects.
  Future<Either<Failure, List<FlowBlock>>> getAllFlowBlocks();

  /// Saves a new FlowBlock to the repository.
  ///
  /// [flowBlock] The FlowBlock object to be saved.
  ///
  /// Returns a [Future] that completes when the save operation is finished.
  Future<void> saveFlowBlock(FlowBlock flowBlock);

  /// Deletes a FlowBlock from the repository by its ID.
  ///
  /// [id] The unique identifier of the FlowBlock to delete.
  ///
  /// Returns a [Future] that completes when the delete operation is finished.
  Future<void> deleteFlowBlock(String id);

  /// Updates an existing FlowBlock in the repository.
  ///
  /// [flowBlock] The FlowBlock object with updated information.
  ///
  /// Returns a [Future] that completes when the update operation is finished.
  Future<void> updateFlowBlock(FlowBlock flowBlock);
}
