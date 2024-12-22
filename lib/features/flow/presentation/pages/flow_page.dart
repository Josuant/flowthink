import 'package:flow/features/flow/presentation/widgets/widget_grid_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlowPage extends ConsumerWidget {
  const FlowPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We can read or watch providers here if needed.
    return const GridScreen();
  }
}
