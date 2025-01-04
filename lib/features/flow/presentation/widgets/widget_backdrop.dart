import 'dart:ui';

import 'package:flutter/material.dart';

class BackdropWidget extends StatelessWidget {
  const BackdropWidget({
    super.key,
    required this.widget,
    required this.width,
    required this.height,
    required this.borderRadius,
    this.blurEffect = 2.0,
  });

  final Widget widget;
  final double width;
  final double height;
  final double borderRadius;
  final double blurEffect;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Fondo desenfocado limitado al área del widget
        ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurEffect, sigmaY: blurEffect),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1), // Color translúcido
              ),
              width: width,
              height: height,
            ),
          ),
        ),
        widget,
      ],
    );
  }
}
