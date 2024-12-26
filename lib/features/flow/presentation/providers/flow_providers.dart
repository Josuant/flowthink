// flow_providers.dart
import 'package:flow/features/flow/domain/entities/flow_block_state.dart';
import 'package:flow/features/flow/domain/entities/flow_connection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'flow_blocks_notifier.dart';
import 'flow_connections_notifier.dart';

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
