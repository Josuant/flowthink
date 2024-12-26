import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedDashedLine extends StatefulWidget {
  final Offset start;
  final Offset end;
  final Color color;
  final bool isPreview;

  const AnimatedDashedLine({
    super.key,
    required this.start,
    required this.end,
    required this.color,
    required this.isPreview,
  });

  @override
  _AnimatedDashedLineState createState() => _AnimatedDashedLineState();
}

class _AnimatedDashedLineState extends State<AnimatedDashedLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _startAnimation;
  late Animation<Color?> _colorAnimation;

  Offset? _previousStart;
  Color? _previousColor;

  Offset _currentEnd = Offset.zero;

  @override
  void initState() {
    super.initState();

    _previousStart = widget.start;
    _previousColor = widget.color;
    _currentEnd = widget.end; // Inicializar end

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Duración de 300 ms
    );

    _initializeAnimations();
    _controller.forward();
  }

  void _initializeAnimations() {
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Modifica la curva según sea necesario
    );

    _startAnimation = Tween<Offset>(
      begin: _previousStart,
      end: widget.start,
    ).animate(curve);

    _colorAnimation = ColorTween(
      begin: _previousColor,
      end: widget.color,
    ).animate(curve);
  }

  @override
  void didUpdateWidget(covariant AnimatedDashedLine oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool needsAnimation = false;

    if (widget.start != oldWidget.start || widget.color != oldWidget.color) {
      _previousStart = _startAnimation.value;
      _previousColor = _colorAnimation.value ?? widget.color;
      needsAnimation = true;
    }

    if (widget.end != oldWidget.end) {
      // Actualiza end inmediatamente sin animación
      _currentEnd = widget.end;
    }

    if (needsAnimation) {
      _controller.reset();
      _initializeAnimations();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: DashedLinePainter(
            start: widget.isPreview ? _startAnimation.value : widget.start,
            end: _currentEnd,
            color: _colorAnimation.value ?? widget.color,
            isDotted: widget.isPreview,
          ),
          child: Container(),
        );
      },
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;
  final bool isDotted;

  DashedLinePainter({
    required this.start,
    required this.end,
    required this.color,
    required this.isDotted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..strokeWidth = 3.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0;

    // Dibujar la sombra
    drawCustomLine(canvas, start, end, shadowPaint, isDotted);

    // Dibujar la línea normal
    drawCustomLine(canvas, start, end, paint, isDotted);
  }

  void drawCustomLine(Canvas canvas, Offset currentStart, Offset currentEnd,
      Paint paint, bool isDotted) {
    // Calcula la diferencia en las coordenadas X e Y
    double deltaX = currentEnd.dx - currentStart.dx;
    double deltaY = currentEnd.dy - currentStart.dy;

    // Determina si la línea es horizontal o vertical
    bool isHorizontal = deltaY == 0;
    bool isVertical = deltaX == 0;

    // Umbral para determinar si la inclinación es significativa
    double inclinationThreshold = 0.3;

    // Radio para las esquinas redondeadas
    double cornerRadius = 25.0;

    bool hypotenuseGreaterThanRadius =
        math.sqrt(deltaX * deltaX + deltaY * deltaY) > cornerRadius + 10;

    // Si la línea tiene una inclinación significativa, dibuja con esquina redondeada
    if (!isHorizontal &&
        !isVertical &&
        hypotenuseGreaterThanRadius &&
        (deltaX.abs() / deltaY.abs()).abs() > inclinationThreshold) {
      // Define el punto de esquina antes de la curva
      Offset cornerPoint = Offset(currentEnd.dx, currentStart.dy);

      // Ajusta el punto para empezar la esquina redondeada
      double dx = deltaX > 0 ? -cornerRadius : cornerRadius;
      double dy = deltaY > 0 ? -cornerRadius : cornerRadius;

      Offset preCornerPointH = Offset(cornerPoint.dx + dx, currentStart.dy);
      Offset preCornerPointV = Offset(currentEnd.dx, cornerPoint.dy - dy);

      // Dibuja la primera línea horizontal hasta antes de la curva
      drawLine(canvas, currentStart, preCornerPointH, paint, 10, isDotted);

      int segments = 20; // Número de segmentos para aproximar la curva
      double angleStep = (math.pi * 1.5) / segments;

      for (int i = 6; i < segments - 6; i++) {
        double startAngle = i * angleStep;
        double endAngle = (i + 1) * angleStep;

        double directionX = (deltaX < 0 ? 1 : -1);
        double directionY = (deltaY < 0 ? 1 : -1);

        // Calcula los puntos inicial y final de cada segmento del arco
        double startX =
            cornerPoint.dx + cornerRadius * math.cos(startAngle) * directionX;
        double startY =
            cornerPoint.dy + cornerRadius * math.sin(startAngle) * directionY;

        double endX =
            cornerPoint.dx + cornerRadius * math.cos(endAngle) * directionX;
        double endY =
            cornerPoint.dy + cornerRadius * math.sin(endAngle) * directionY;

        Offset arcStart = Offset(startX + cornerRadius * directionX,
            startY - cornerRadius * directionY);

        Offset arcEnd = Offset(
            endX + cornerRadius * directionX, endY - cornerRadius * directionY);

        // Dibuja el punto de esquina antes de la curva
        //canvas.drawCircle(arcStart, paint.strokeWidth, paint);
        // Dibuja cada segmento del arco como una línea punteada
        drawLine(canvas, arcStart, arcEnd, paint, 5, isDotted);
      }

      // Dibuja la última línea recta desde el punto de la curva hasta el final
      drawLine(canvas, preCornerPointV, currentEnd, paint, 10, isDotted);
    } else {
      // Si la línea es horizontal o vertical, dibuja una sola línea recta
      drawLine(canvas, currentStart, currentEnd, paint, 10, isDotted);
    }
  }

  void drawLine(Canvas canvas, Offset start, Offset end, Paint paint,
      double dotSpacing, bool isDotted) {
    if (start.dx.isNaN || start.dy.isNaN || end.dx.isNaN || end.dy.isNaN) {
      return; // Evita que se dibuje si hay valores inválidos
    }
    if (isDotted) {
      // Lógica para una línea punteada
      double totalDistance = (end - start).distance;
      int dotCount = (totalDistance / dotSpacing).floor();
      Offset direction = (end - start) / totalDistance;

      for (int i = 0; i <= dotCount; i++) {
        if (direction.dx.isNaN || direction.dy.isNaN) {
          return; // Evita que se dibuje si hay valores inválidos
        }
        Offset position = start + direction * (i * dotSpacing);
        if (position.dx.isNaN || position.dy.isNaN) {
          return; // Evita que se dibuje si hay valores inválidos
        }
        canvas.drawCircle(
            position, paint.strokeWidth / 2, paint); // Dibuja puntos pequeños
      }
    } else {
      // Lógica para una línea continua
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) {
    return oldDelegate.start != start ||
        oldDelegate.end != end ||
        oldDelegate.color != color;
  }
}
