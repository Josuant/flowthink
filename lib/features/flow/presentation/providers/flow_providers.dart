// flow_providers.dart
import 'package:flow/features/flow/data/models/flow_block_model.dart';
import 'package:flow/features/flow/data/models/flow_connection_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'flow_blocks_notifier.dart';
import 'flow_connections_notifier.dart';

// A provider for the list of FlowBlockModel
final flowBlocksProvider =
    StateNotifierProvider<FlowBlocksNotifier, List<FlowBlockModel>>(
  (ref) => FlowBlocksNotifier(),
);

// A provider for the list of FlowConnectionModel
final flowConnectionsProvider =
    StateNotifierProvider<FlowConnectionsNotifier, List<FlowConnectionModel>>(
  (ref) => FlowConnectionsNotifier(),
);
