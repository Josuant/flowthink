import 'package:flow/features/flow/domain/entities/trash_state.dart';
import 'package:flow/features/flow/presentation/widgets/widget_backdrop.dart';
import 'package:flutter/material.dart';

import '../flow_styles.dart';

class WidgetTrash extends StatefulWidget {
  const WidgetTrash({
    super.key,
    required this.state,
  });

  final TrashState state;
  final double borderRadius = 58;

  @override
  WidgetTrashState createState() => WidgetTrashState();
}

class WidgetTrashState extends State<WidgetTrash> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.state.isBlockNear
        ? widget.state.expandedSize
        : widget.state.widgetSize;
    final height = (widget.state.isBlockNear
            ? widget.state.expandedSize
            : widget.state.widgetSize) /
        2;
    final Offset targetPosition = widget.state.isVisible
        ? widget.state.currentPosition
        : Offset(widget.state.initialPosition.dx,
            widget.state.initialPosition.dy + 20);

    return AnimatedPositioned(
        duration: const Duration(milliseconds: 600),
        left: targetPosition.dx,
        top: targetPosition.dy,
        curve: Curves.elasticOut,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 600),
          opacity: widget.state.isVisible ? 1.0 : 0.0,
          curve: Curves.elasticOut,
          child: BackdropWidget(
            widget: _buildTrashWidget(width, height),
            width: width,
            height: height,
            borderRadius: widget.borderRadius,
          ),
        ));
  }

  _buildTrashWidget(double width, double height) {
    return
        // Contenido del widget
        AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0x4CDC6D6F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        shadows: FlowStyles.buildBoxShadows(),
      ),
      child: const Icon(Icons.close, color: Color(0xFFDC6D6F)),
    );
  }
}
