import 'package:flow/features/flow/domain/entities/flow_block_state.dart';
import 'package:flow/features/flow/presentation/providers/flow_block_notifier.dart';
import 'package:flow/features/flow/presentation/providers/flow_block_state_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../flow_styles.dart';
import '../../utils/enums/flow_block_type.dart';
import '../../utils/flow_util.dart';
import '../../../../core/widgets/animated_dashed_line.dart';

/// A ConsumerWidget that uses Riverpod's flowContainerProvider.
class FlowBlock extends ConsumerWidget {
  const FlowBlock({
    super.key,
    required this.width,
    required this.height,
    required this.position,
    this.cornerRadius = 0.0,
    this.animationDurationMs = 500,
    this.circleRadius = 10,
    required this.text,
    required this.type,
    required this.startEditing,
    required this.onCreateWidget,
  });

  final double width;
  final double height;
  final Offset position;
  final double cornerRadius;
  final int animationDurationMs;
  final double circleRadius;
  final String text;
  final bool startEditing;
  final FlowBlockType type;
  final Function(Offset, Offset) onCreateWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize or watch the provider using a family
    final flowBlockArgs = FlowBlockArgs(
      startEditing: startEditing,
      initialText: text,
      initialPosition: position,
    );
    final state = ref.watch(flowContainerProvider(flowBlockArgs));
    final notifier = ref.read(flowContainerProvider(flowBlockArgs).notifier);

    if (state.isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.setEditing(false);
        notifier.setLongPressDown(false);
      });
    }

    // Also handle the animation finishing logic
    if (state.isAnimating && state.globalPosition != position) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.setLongPressDown(false);
      });
    }

    return Stack(
      children: [
        _buildAnimatedPositioned(context, state, notifier),
      ],
    );
  }

  // ----------------- Main AnimatedPositioned -----------------
  Widget _buildAnimatedPositioned(
    BuildContext context,
    FlowBlockState state,
    FlowBlockNotifier notifier, // FlowContainerNotifier
  ) {
    return AnimatedPositioned(
      duration: state.isAnimating
          ? Duration(milliseconds: animationDurationMs)
          : Duration.zero,
      curve: Curves.easeInOut,
      width: width + 10.0, // Extra margin
      height: height + 10.0,
      left: state.isDragging ? _getDragPositionX(state) : _getPositionX(state),
      top: state.isDragging ? _getDragPositionY(state) : _getPositionY(state),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildFlowContainerContent(context, state, notifier),
            if (state.isLongPressDown &&
                state.tapPosition != null &&
                !_isInCancellation(state))
              _buildDashedLine(state),
            if (state.isLongPressDown && state.tapPosition != null)
              _buildAnimatedCircle(state),
            if (state.isLongPressDown && state.tapPosition != null)
              _buildFollowContainer(state),
          ],
        ),
      ),
    );
  }

  // ----------------- Container Content -----------------
  Widget _buildFlowContainerContent(
    BuildContext context,
    FlowBlockState state,
    FlowBlockNotifier notifier,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // The actual moving container with blur, text, etc.
        Stack(
          children: [
            _buildAnimatedContainer(context, state, notifier),
            _buildDragIndicator(),
          ],
        ),
        // Gesture detectors
        _buildGestureDetectors(context, state, notifier),
      ],
    );
  }

  Widget _buildAnimatedContainer(
      BuildContext context, FlowBlockState state, FlowBlockNotifier notifier) {
    return AnimatedContainer(
      duration: Duration(milliseconds: animationDurationMs),
      curve: Curves.easeOut,
      width: width,
      height: height,
      decoration: FlowStyles.buldBoxDecoration(
        false, // not hovered
        state.isLongPressDown,
        state.isEditing,
        cornerRadius,
      ),
      padding: EdgeInsets.symmetric(horizontal: width / 6, vertical: 4),
      alignment: Alignment.center,
      child: AnimatedContainer(
        alignment: Alignment.center,
        duration: Duration(milliseconds: animationDurationMs),
        curve: Curves.easeOut,
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: state.isEditing
                ? _buildTextField(state, notifier)
                : _buildText(state),
          ),
        ),
      ),
    );
  }

  Widget _buildDragIndicator() {
    return Positioned(
      left: 0,
      child: SizedBox(
        width: width / 6,
        height: height,
        child: const Icon(
          Icons.drag_indicator,
          color: Color(0xFF624EA0),
          size: 15,
        ),
      ),
    );
  }

  // ----------------- Text / TextField -----------------
  Widget _buildText(FlowBlockState state) {
    return Text(
      state.textController.text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16.0,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }

  Widget _buildTextField(FlowBlockState state, FlowBlockNotifier notifier) {
    return TextField(
      controller: state.textController,
      onChanged: (text) => state.textController.text = text,
      onSubmitted: (_) => notifier.setEditing(false),
      autofocus: true,
      textAlign: TextAlign.center,
      maxLines: null,
      decoration: const InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.all(8),
      ),
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }

  // ----------------- Gesture Detectors -----------------
  Widget _buildGestureDetectors(
    BuildContext context,
    FlowBlockState state,
    FlowBlockNotifier notifier,
  ) {
    return Row(
      children: [
        // Left side for dragging
        GestureDetector(
          onPanUpdate: (details) {
            notifier.setDragging(true);
            final tapPos = details.localPosition;
            notifier.setLongPress(false);
            notifier.setLongPressDown(false);
            // Notify external about drag
            notifier.setGlobalPosition(
              state.globalPosition.translate(
                tapPos.dx - 5,
                tapPos.dy - height / 2,
              ),
            );
          },
          onPanEnd: (details) {
            notifier.setDragging(false);
            notifier.updateGlobalPosition(details.localPosition, height);
            notifier.onFinishDrag(details.localPosition);
          },
          child: Container(
            width: width / 6,
            height: height + 10.0,
            color: Colors.transparent,
          ),
        ),
        // Right side for long press to create new widget or edit
        if (!state.isEditing)
          GestureDetector(
            onLongPressDown: (details) {
              notifier.setLongPressDown(true, details.localPosition);
            },
            onLongPress: () => notifier.setLongPress(true),
            onLongPressCancel: () => notifier.setLongPressDown(false),
            onPanUpdate: (details) {
              notifier.updateTapPosition(
                localPosition: details.localPosition,
                alignment: FlowUtil.determineAlignment(
                  details.localPosition,
                  width,
                  height,
                ),
              );
            },
            onPanEnd: (details) {
              notifier.setLongPressDown(false);
            },
            onLongPressEnd: (details) {
              // Create a new widget if inside valid region
              if (!_isInCancellation(state)) {
                final containerPos =
                    state.globalPosition + _getFollowContainerOffset(state);
                final circlePos = FlowUtil.getCirclePosition(
                  state.tapPosition!,
                  width,
                  height,
                  circleRadius,
                );
                onCreateWidget(containerPos, circlePos);
              }
            },
            child: Container(
              width: (width - width / 6) + 10.0,
              height: height + 10.0,
              color: Colors.transparent,
            ),
          ),
      ],
    );
  }

  // ----------------- Overlays (DashedLine, Circle, FollowContainer) -----------------
  Widget _buildDashedLine(FlowBlockState state) {
    return AnimatedDashedLine(
      isPreview: true,
      start: FlowUtil.getCirclePosition(
        state.tapPosition!,
        width,
        height,
        circleRadius,
      ),
      end: state.tapPosition!,
      color: Colors.purple.withAlpha(200),
    );
  }

  Widget _buildAnimatedCircle(FlowBlockState state) {
    return AnimatedAlign(
      alignment: state.buttonAlignment,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: TweenAnimationBuilder<Offset>(
        tween: Tween<Offset>(
          begin: Offset.zero,
          end: FlowUtil.getButtonOffset(state.buttonAlignment, circleRadius),
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        builder: (context, offset, child) {
          return Transform.translate(
            offset: offset,
            child: child,
          );
        },
        child: CircleAvatar(
          radius: state.isLongPress ? circleRadius - 4 : 0.0,
          backgroundColor: state.buttonAlignment == Alignment.center
              ? Colors.transparent
              : Colors.white,
          child: CircleAvatar(
            radius: state.isLongPress ? circleRadius : 0.0,
            backgroundColor: state.buttonAlignment == Alignment.center
                ? Colors.transparent
                : Colors.purple,
          ),
        ),
      ),
    );
  }

  Widget _buildFollowContainer(FlowBlockState state) {
    return Transform.translate(
      offset: _getFollowContainerOffset(state),
      child: Opacity(
        opacity: _isInCancellation(state) ? 0.3 : 1.0,
        child: Container(
          width: width,
          height: height,
          decoration: FlowStyles.buldBoxDecoration(
            false,
            state.isLongPressDown,
            state.isEditing,
            cornerRadius,
          ),
        ),
      ),
    );
  }

  // ----------------- Utility Methods -----------------
  bool _isInCancellation(FlowBlockState state) {
    if (state.tapPosition == null) return true;
    final Rect containerRect = Rect.fromLTWH(
      -width / 2,
      -height / 2,
      width * 2,
      height * 2,
    );
    return !containerRect.contains(state.tapPosition!);
  }

  Offset _getFollowContainerOffset(FlowBlockState state) {
    final tap = state.tapPosition ?? Offset.zero;
    return tap - Offset(width / 2, height / 2);
  }

  double _getPositionX(FlowBlockState state) {
    return state.isAnimating ? position.dx : state.globalPosition.dx;
  }

  double _getPositionY(FlowBlockState state) {
    return state.isAnimating ? position.dy : state.globalPosition.dy;
  }

  double _getDragPositionX(FlowBlockState state) {
    final tapPos = state.tapPosition ?? Offset.zero;
    return state.globalPosition.dx + tapPos.dx - 5;
  }

  double _getDragPositionY(FlowBlockState state) {
    final tapPos = state.tapPosition ?? Offset.zero;
    return state.globalPosition.dy + tapPos.dy - height / 2;
  }
}
