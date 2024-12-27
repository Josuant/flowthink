import 'package:flutter/material.dart';

class GridWidget extends StatelessWidget {
  const GridWidget({
    super.key,
    required this.size,
    this.cellWidth = 25.0,
    this.cellHeight = 25.0,
  });

  final Size size;
  final double cellWidth;
  final double cellHeight;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GridPainter(size, generateCellCenters(cellWidth, cellHeight),
          cellWidth, cellHeight),
    );
  }

  /// Genera puntos centrados en una cuadrícula con el centro en la pantalla
  List<Offset> generateCellCenters(double cellWidth, double cellHeight) {
    List<Offset> points = [];

    double centerX = size.width / 2;
    double centerY = size.height / 2;

    int horizontalCells = (size.width / cellWidth).ceil();
    int verticalCells = (size.height / cellHeight).ceil();

    for (int i = -verticalCells; i <= verticalCells; i++) {
      for (int j = -horizontalCells; j <= horizontalCells; j++) {
        double x = centerX + j * cellWidth;
        double y = centerY + i * cellHeight;
        points.add(Offset(x, y));
      }
    }
    return points;
  }
}

class GridPainter extends CustomPainter {
  List<Offset> points;
  Size size;
  double cellWidth;
  double cellHeight;

  GridPainter(this.size, this.points, this.cellWidth, this.cellHeight);

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

  /// Encuentra el punto más cercano a una posición dada
  Offset getClosestPoint(Offset position) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    int column = ((position.dx - centerX) / cellWidth).round();
    int row = ((position.dy - centerY) / cellHeight).round();

    double closestX = centerX + column * cellWidth;
    double closestY = centerY + row * cellHeight;

    return Offset(closestX, closestY);
  }
}
