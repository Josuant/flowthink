import 'dart:ui';

import 'package:flow/features/flow/presentation/flow_styles.dart';
import 'package:flow/features/flow/utils/constants/flow_default_constants.dart';
import 'package:flutter/material.dart';

class WidgetFlowAnimatedBlock extends StatelessWidget {
  final bool isUnion;
  final bool isLongPressDown;
  final bool isEditing;
  final double opacity;
  final double blur;
  final double cornerRadius;
  final int msAnimationDuration;
  final double width;
  final double height;
  final Offset position;
  const WidgetFlowAnimatedBlock(
      {super.key,
      required this.isUnion,
      required this.isLongPressDown,
      required this.isEditing,
      required this.opacity,
      required this.position,
      this.width = FlowDefaultConstants.flowBlockWidth,
      this.height = FlowDefaultConstants.flowBlockHeight,
      this.cornerRadius = FlowDefaultConstants.flowBlockCornerRadius,
      this.msAnimationDuration = 200,
      this.blur = 0.0});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: position.dx - width / 2,
      top: position.dy - height / 2,
      duration: const Duration(milliseconds: 50),
      child: AnimatedOpacity(
          opacity: opacity,
          duration: Duration(milliseconds: msAnimationDuration),
          child: AnimatedContainer(
            width: width,
            height: height,
            duration: Duration(milliseconds: msAnimationDuration),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blur,
                sigmaY: blur,
              ),
              child: Container(
                decoration: FlowStyles.buldBoxDecoration(
                  isUnion,
                  isLongPressDown,
                  isEditing,
                  cornerRadius,
                ),
              ),
            ),
          )),
    );
  }
}
