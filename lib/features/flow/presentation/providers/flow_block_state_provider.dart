import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:flow/features/flow/domain/entities/flow_block_state.dart';
import 'package:flow/features/flow/presentation/notifiers/flow_block_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

/// Family so each FlowContainer can have its own state.
final flowContainerProvider = StateNotifierProvider.family<FlowBlockNotifier,
    FlowBlockState, FlowBlockArgs>(
  (ref, args) {
    return FlowBlockNotifier(
      entity: args.entity,
      startEditing: args.startEditing,
      initialText: args.initialText,
      initialPosition: args.initialPosition,
    );
  },
);

/// Simple argument class to pass necessary initialization data.
class FlowBlockArgs {
  final FlowBlock entity;
  final bool startEditing;
  final String initialText;
  final Offset initialPosition;

  FlowBlockArgs({
    required this.entity,
    required this.startEditing,
    required this.initialText,
    required this.initialPosition,
  });
}
