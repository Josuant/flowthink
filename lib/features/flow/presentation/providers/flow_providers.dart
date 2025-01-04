// flow_providers.dart
import 'dart:io';

import 'package:flow/features/ai/data/datasources/ia_service.dart';
import 'package:flow/features/ai/data/repositories/gemini_repository.dart';
import 'package:flow/features/ai/presentation/notifiers/ai_notifier.dart';
import 'package:flow/features/flow/domain/entities/action_state.dart';
import 'package:flow/features/flow/domain/entities/flow_block_state.dart';
import 'package:flow/features/flow/domain/entities/flow_connection.dart';
import 'package:flow/features/flow/domain/entities/trash_state.dart';
import 'package:flow/features/flow/presentation/notifiers/action_notifier.dart';
import 'package:flow/features/flow/presentation/notifiers/trash_notifier.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

// A provider for the ActionState
final actionProvider = StateNotifierProvider<ActionNotifier, ActionState>(
    (ref) => ActionNotifier());

final iaProvider = StateNotifierProvider<IANotifier, AsyncValue<String>>((ref) {
  final iaRepository = ref.watch(iaRepositoryProvider);
  return IANotifier(iaRepository);
});

final iaRepositoryProvider = Provider<GeminiRepository>((ref) {
  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final iaService = GeminiService(apiKey);
  return GeminiRepository(iaService);
});
