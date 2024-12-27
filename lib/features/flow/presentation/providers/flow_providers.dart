// flow_providers.dart
import 'package:flow/features/flow/domain/entities/flow_block_state.dart';
import 'package:flow/features/flow/domain/entities/flow_connection.dart';
import 'package:flow/features/flow/domain/entities/trash_state.dart';
import 'package:flow/features/flow/presentation/notifiers/trash_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/flow_blocks_notifier.dart';
import '../notifiers/flow_connections_notifier.dart';

// A provider for the list of FlowBlockState
final flowBlocksProvider =
    StateNotifierProvider<FlowBlocksNotifier, List<FlowBlockState>>(
  (ref) => FlowBlocksNotifier(),
);

// A provider for the list of FlowConnectionModel
final flowConnectionsProvider =
    StateNotifierProvider<FlowConnectionsNotifier, List<FlowConnection>>(
  (ref) => FlowConnectionsNotifier(),
);

// A provider for the TrashState
final trashProvider = StateNotifierProvider<TrashNotifier, TrashState>(
  (ref) => TrashNotifier(),
);
