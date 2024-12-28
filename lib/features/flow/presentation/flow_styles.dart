import 'package:figma_squircle/figma_squircle.dart';
import 'package:flow/features/flow/utils/constants/flow_default_constants.dart';
import 'package:flutter/material.dart';

class FlowStyles {
  static List<BoxShadow> buildBoxShadows() {
    const baseColor = Color(0xFF9C79DC);
    return List.generate(5, (i) {
      return BoxShadow(
        color: baseColor.withOpacity([0.25, 0.21, 0.13, 0.04, 0.0][i]),
        blurRadius: [11.0, 20.0, 27.0, 32.0, 35.0][i],
        offset: Offset(
            [4.0, 14.0, 32.0, 57.0, 89.0][i], [4.0, 14.0, 32.0, 57.0, 89.0][i]),
      );
    });
  }

  static List<BoxShadow> buildSelectedBoxShadows() {
    const baseColor = Color(0xFF9C79DC);
    return List.generate(5, (i) {
      return BoxShadow(
        color: baseColor.withOpacity([0.3, 0.26, 0.15, 0.06, 0.01][i]),
        blurRadius: [3.0, 5.0, 7.0, 8.0, 8.0][i],
        offset: Offset(0, [1.0, 5.0, 11.0, 19.0, 30.0][i]),
      );
    });
  }

  static Decoration buldBoxDecoration(
      bool isUnion, bool isLongPressDown, bool isEditing, double cornerRadius) {
    return ShapeDecoration(
      shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: isLongPressDown
                ? FlowDefaultConstants.flowBlockSelectedCornerRadius
                : cornerRadius,
            cornerSmoothing: 1.0,
          ),
          side: BorderSide(
            color: isLongPressDown || isEditing
                ? Colors.purple
                : Colors.transparent,
            width: isLongPressDown || isEditing ? 2.0 : 0.0,
          )),
      gradient: isUnion
          ? const LinearGradient(
              begin: Alignment(-0.77, -0.64),
              end: Alignment(0.77, 0.64),
              colors: [Color(0xFF876DDC), Color(0xFFB19DF2)],
            )
          : const LinearGradient(
              begin: Alignment(0.71, -0.71),
              end: Alignment(-0.71, 0.71),
              colors: [Color(0xFFF2F2F2), Colors.white]),
      shadows: isUnion
          ? []
          : isLongPressDown
              ? FlowStyles.buildSelectedBoxShadows()
              : FlowStyles.buildBoxShadows(),
    );
  }
}
