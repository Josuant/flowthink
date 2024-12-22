import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'grid_manager.dart';

class GridDisplay extends StatelessWidget {
  const GridDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final gridManager = Provider.of<GridManager>(context);

    return CustomPaint(
      painter: GridPainter(gridManager.points),
    );
  }
}

class GridPainter extends CustomPainter {
  final List<Offset> points;

  GridPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE6E8F4)
      ..style = PaintingStyle.fill;

    for (var point in points) {
      canvas.drawCircle(point, 2, paint); // Dibuja los puntos de la cuadrícula
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
