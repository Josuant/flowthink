import 'dart:math';

import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

import 'enums/flow_block_enums.dart';

class FlowUtil {
  static Offset getCirclePosition(
      Offset position, double width, double height, double circleRadius) {
    // Calcula la posición actual del círculo pequeño
    final circleAlignment = determineAlignment(position, width, height);
    final circleOffset = getButtonOffset(circleAlignment, circleRadius);

    final alignmentOffset = Offset(
      (width / 2) * circleAlignment.x,
      (height / 2) * circleAlignment.y,
    );

    return Offset(width / 2, height / 2) + alignmentOffset + circleOffset;
  }

  static Alignment determineAlignment(
      Offset position, double width, double height) {
    // Normaliza la posición a un rango de [-1, 1]
    final normalizedX = (position.dx / width) * 2 - 1;
    final normalizedY = (position.dy / height) * 2 - 1;

    // Ajusta el peso del movimiento horizontal para que el vertical sea más dominante
    const horizontalBias =
        8.0; // Factor para reducir la influencia del eje vertical

    // Determina si el movimiento es más horizontal o vertical
    if (normalizedX.abs() * horizontalBias > normalizedY.abs()) {
      // Movimiento horizontal dominante
      if (normalizedX < 0) {
        return Alignment.centerLeft;
      } else {
        return Alignment.centerRight;
      }
    } else {
      // Movimiento vertical dominante
      if (normalizedY < 0) {
        return Alignment.topCenter;
      } else {
        return Alignment.bottomCenter;
      }
    }
  }

  static Offset getButtonOffset(
      Alignment buttonAlignment, double circleRadius) {
    // Calcula el desplazamiento basado en la alineación y el radio del círculo
    return Offset(
      buttonAlignment.x * circleRadius / 2,
      buttonAlignment.y * circleRadius / 2,
    );
  }

  static String generateXML(List<Map<String, dynamic>> widgetsData) {
    final buffer = StringBuffer();
    buffer.writeln('<Widgets>');

    for (var i = 0; i < widgetsData.length; i++) {
      final widget = widgetsData[i];
      buffer.writeln('  <Widget>');
      buffer.writeln('    <Id>${widget['id']}</Id>');
      buffer.writeln('    <Text>${widget['text']}</Text>');
      buffer.writeln('    <Type>${widget['type']}</Type>');
      buffer.writeln('    <Position>');
      buffer.writeln('      <X>${widget['position'].dx}</X>');
      buffer.writeln('      <Y>${widget['position'].dy}</Y>');
      buffer.writeln('    </Position>');
      buffer.writeln(
          '    <Connections>${widget['connections'].join(',')}</Connections>');
      buffer.writeln('  </Widget>');
    }

    buffer.writeln('</Widgets>');
    return buffer.toString();
  }

  static List<Map<String, dynamic>> parseXmlToWidgets(String xml) {
    final document = XmlDocument.parse(xml); // Analiza el XML
    final widgets = <Map<String, dynamic>>[];

    final widgetElements = document.findAllElements('Widget');
    for (var widgetElement in widgetElements) {
      // Extraer los valores del XML
      final id = int.parse(widgetElement.findElements('Id').first.innerText);
      final text = widgetElement.findElements('Text').first.innerText;
      final type = widgetElement.findElements('Type').first.innerText;
      final positionElement = widgetElement.findElements('Position').single;
      final positionX =
          double.parse(positionElement.findElements('X').first.innerText);
      final positionY =
          double.parse(positionElement.findElements('Y').first.innerText);
      final connections = widgetElement
          .findElements('Connections')
          .first
          .innerText
          .split(',')
          .where((s) => s.isNotEmpty)
          .map((s) => int.parse(s))
          .toList();

      // Crear el mapa para el widget
      widgets.add({
        'id': id,
        'text': text,
        'type': stringToEnum(type) ?? '',
        'position': Offset(positionX, positionY),
        'connections': connections,
        'width': 150.0, // Agrega valores predeterminados si es necesario
        'height': 60.0,
        'cornerRadius': 10.0,
        'circleRadius': 5.0,
        'isDeleted': false,
      });
    }

    return widgets;
  }

  static FlowBlockType? stringToEnum(String input) {
    return FlowBlockType.values.firstWhere((e) => e.toString() == input);
  }

  static Direction getRandomDirection({Direction? exclude}) {
    List<Direction> directions = Direction.values.toList();
    if (exclude != null) {
      directions.remove(exclude);
    }
    return directions[Random().nextInt(directions.length)];
  }

  static Direction getReverseDirection(Direction direction) {
    switch (direction) {
      case Direction.up:
        return Direction.down;
      case Direction.down:
        return Direction.up;
      case Direction.left:
        return Direction.right;
      case Direction.right:
        return Direction.left;
    }
  }

  static Direction getDirectionFromPositions(
      Offset positionA, Offset positionB) {
    double dx = positionA.dx - positionB.dx;
    double dy = positionA.dy - positionB.dy;

    if (dx.abs() > dy.abs()) {
      return dx > 0 ? Direction.left : Direction.right;
    } else {
      return dy > 0 ? Direction.up : Direction.down;
    }
  }
}
