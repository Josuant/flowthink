import 'dart:ui';
import 'package:flow/features/flow/domain/entities/trash_state.dart';
import 'package:flutter/material.dart';

import '../flow_styles.dart';

class WidgetTrash extends StatefulWidget {
  const WidgetTrash({
    super.key,
    required this.state,
  });

  final TrashState state;

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
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Fondo desenfocado limitado al área del widget
            ClipRRect(
              borderRadius: BorderRadius.circular(58),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1), // Color translúcido
                  ),
                  width: widget.state.isBlockNear
                      ? widget.state.expandedSize
                      : widget.state.widgetSize,
                  height: (widget.state.isBlockNear
                          ? widget.state.expandedSize
                          : widget.state.widgetSize) /
                      2,
                ),
              ),
            ),
            // Contenido del widget
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.state.isBlockNear
                  ? widget.state.expandedSize
                  : widget.state.widgetSize,
              height: (widget.state.isBlockNear
                      ? widget.state.expandedSize
                      : widget.state.widgetSize) /
                  2,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0x4CDC6D6F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(58),
                ),
                shadows: FlowStyles.buildBoxShadows(),
              ),
              child: const Icon(Icons.close, color: Color(0xFFDC6D6F)),
            ),
          ],
        ),
      ),
    );
  }
}
