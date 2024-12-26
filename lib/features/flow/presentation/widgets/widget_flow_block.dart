import 'package:flow/features/flow/domain/entities/flow_block_state.dart';
import 'package:flow/features/flow/presentation/flow_styles.dart';
import 'package:flutter/material.dart';

class FlowBlockWidget extends StatelessWidget {
  final FlowBlockState state;
  final Function(Offset)? onLongPressDown;
  final Function(Offset)? onStartDrag;
  final Function(Offset)? onDrag;
  final Function(Offset)? onFinishDrag;
  final Function()? onStartEditing;
  final Function(String)? onEditing;
  final Function(String)? onFinishEditing;
  final Function(Offset)? onPanUpdate;
  final Function(Offset)? onPanEnd;

  const FlowBlockWidget({
    super.key,
    required this.state,
    this.onLongPressDown,
    this.onStartDrag,
    this.onDrag,
    this.onFinishDrag,
    this.onStartEditing,
    this.onEditing,
    this.onFinishEditing,
    this.onPanUpdate,
    this.onPanEnd,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: state.position.dx - state.entity.width / 2,
      top: state.position.dy - state.entity.height / 2,
      duration: const Duration(milliseconds: 50),
      child: _buildFlowContainerContent(),
    );
  }

  Widget _buildFlowContainerContent() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // AnimatedContainer
        _buildAnimatedContainer(),
        // Gesture detectors
        if (!state.isEditing) _buildGestureDetectors(),
      ],
    );
  }

  Widget _buildAnimatedContainer() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOut,
      width: state.entity.width,
      height: state.entity.height,
      decoration: FlowStyles.buldBoxDecoration(
        false,
        state.isLongPressDown,
        state.isEditing,
        state.entity.cornerRadius,
      ),
      padding:
          EdgeInsets.symmetric(horizontal: state.entity.width / 6, vertical: 4),
      alignment: Alignment.center,
      child: IntrinsicWidth(
        child: IntrinsicHeight(
          child: state.isEditing ? _buildTextField() : _buildText(),
        ),
      ),
    );
  }

  // ----------------- Text / TextField -----------------
  Widget _buildText() {
    return Text(
      state.textController.text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16.0,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: state.textController,
      onChanged: (text) => onEditing!(text),
      onSubmitted: (text) => onFinishEditing!(text),
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
  Widget _buildGestureDetectors() {
    return GestureDetector(
      onLongPressDown: (details) => onLongPressDown!(details.globalPosition),
      onLongPressStart: (details) => onStartDrag!(details.globalPosition),
      onLongPressMoveUpdate: (details) => onDrag!(details.globalPosition),
      onLongPressEnd: (details) => onFinishDrag!(details.globalPosition),
      onPanUpdate: (details) => onPanUpdate!(details.globalPosition),
      onPanEnd: (details) => onPanEnd!(details.globalPosition),
      onDoubleTap: () => onStartEditing!(),
      child: Container(
        width: (state.entity.width) + 10.0,
        height: state.entity.height + 10.0,
        color: Colors.transparent,
      ),
    );
  }
}
