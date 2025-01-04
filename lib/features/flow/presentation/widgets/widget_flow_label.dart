import 'package:flow/features/flow/presentation/flow_styles.dart';
import 'package:flow/features/flow/presentation/widgets/widget_backdrop.dart';
import 'package:flow/features/flow/presentation/widgets/widget_flow_block.dart';
import 'package:flutter/material.dart';

class FlowLabelWidget extends FlowBlockWidget {
  const FlowLabelWidget({super.key, required super.state});

  @override
  Widget buildAnimatedContainer() {
    return BackdropWidget(
        width: state.entity.width,
        height: state.entity.height,
        borderRadius: 8,
        widget: buildContent());
  }

  buildContent() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      width: state.entity.width,
      height: state.entity.height,
      decoration: FlowStyles.buldLabelDecoration(
        false,
        state.isLongPressDown,
      ),
      padding:
          EdgeInsets.symmetric(horizontal: state.entity.width / 6, vertical: 4),
      alignment: Alignment.center,
      child: IntrinsicWidth(
        child: IntrinsicHeight(
          child: state.isEditing ? buildTextField() : buildText(),
        ),
      ),
    );
  }
}
