import 'package:flutter/material.dart';

class GridManager extends ChangeNotifier {
  late List<Offset> _points;
  double cellWidth;
  double cellHeight;
  Size screenSize;

  GridManager({
    required this.cellWidth,
    required this.cellHeight,
    required this.screenSize,
  }) {
    _generateCellCenters();
  }

  /// Genera puntos centrados en una cuadrícula con el centro en la pantalla
  void _generateCellCenters() {
    List<Offset> points = [];

    double centerX = screenSize.width / 2;
    double centerY = screenSize.height / 2;

    int horizontalCells = (screenSize.width / cellWidth).ceil();
    int verticalCells = (screenSize.height / cellHeight).ceil();

    for (int i = -verticalCells; i <= verticalCells; i++) {
      for (int j = -horizontalCells; j <= horizontalCells; j++) {
        double x = centerX + j * cellWidth;
        double y = centerY + i * cellHeight;
        points.add(Offset(x, y));
      }
    }

    _points = points;
    notifyListeners();
  }

  /// Devuelve los puntos de la cuadrícula
  List<Offset> get points => _points;

  /// Encuentra el punto más cercano a una posición dada
  Offset getClosestPoint(Offset position) {
    double centerX = screenSize.width / 2;
    double centerY = screenSize.height / 2;

    int column = ((position.dx - centerX) / cellWidth).round();
    int row = ((position.dy - centerY) / cellHeight).round();

    double closestX = centerX + column * cellWidth;
    double closestY = centerY + row * cellHeight;

    return Offset(closestX, closestY);
  }

  /// Actualiza las dimensiones de la cuadrícula y regenera los puntos
  void updateGrid(
      Size newScreenSize, double newCellWidth, double newCellHeight) {
    screenSize = newScreenSize;
    cellWidth = newCellWidth;
    cellHeight = newCellHeight;
    _generateCellCenters();
  }
}
