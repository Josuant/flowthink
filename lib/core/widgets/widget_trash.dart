import 'dart:ui';
import 'package:flutter/material.dart';

import '../../features/flow/presentation/flow_styles.dart';

class WidgetTrash extends StatefulWidget {
  static final GlobalKey<_WidgetTrashState> globalKey = GlobalKey();

  const WidgetTrash({
    super.key,
    required this.widgetSize,
    required this.expandedSize,
    required this.initialPosition,
    required this.distanceThreshold,
    required this.outsideWidgetSize,
    required this.isTrashVisible,
  });

  final double widgetSize;
  final double expandedSize;
  final Offset initialPosition;
  final double distanceThreshold;
  final double outsideWidgetSize;
  final bool isTrashVisible;

  @override
  _WidgetTrashState createState() => _WidgetTrashState();
}

class _WidgetTrashState extends State<WidgetTrash> {
  late Offset _currentPosition;
  late Rect _influenceZone;
  bool _isNear = false;
  bool get isNear => _isNear;

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.isTrashVisible
        ? widget.initialPosition
        : Offset(widget.initialPosition.dx,
            widget.initialPosition.dy + 100); // Oculto
    _updateInfluenceZone();
  }

  void _updateInfluenceZone() {
    _influenceZone = Rect.fromLTWH(
      widget.initialPosition.dx - widget.distanceThreshold,
      widget.initialPosition.dy - widget.distanceThreshold,
      widget.expandedSize + widget.distanceThreshold,
      widget.expandedSize / 2 + widget.distanceThreshold,
    );
  }

  @override
  void didUpdateWidget(covariant WidgetTrash oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateInfluenceZone();
  }

  /// Método público para recibir avisos de otros widgets
  void notifyProximity(Offset touchPosition) {
    if (!mounted || !widget.isTrashVisible) {
      return; // Evitar si no está montado o visible
    }
    setState(() {
      _isNear = _influenceZone.contains(touchPosition);
      if (_isNear) {
        _currentPosition = touchPosition -
            Offset(
              widget.expandedSize / 2,
              widget.expandedSize / 4 - widget.outsideWidgetSize / 2,
            );
      } else {
        _currentPosition = widget.initialPosition;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Offset targetPosition = widget.isTrashVisible
        ? _currentPosition
        : Offset(widget.initialPosition.dx, widget.initialPosition.dy + 20);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 600),
      left: targetPosition.dx,
      top: targetPosition.dy,
      curve: Curves.elasticOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 600),
        opacity: widget.isTrashVisible ? 1.0 : 0.0,
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
                  width: _isNear ? widget.expandedSize : widget.widgetSize,
                  height:
                      (_isNear ? widget.expandedSize : widget.widgetSize) / 2,
                ),
              ),
            ),
            // Contenido del widget
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _isNear ? widget.expandedSize : widget.widgetSize,
              height: (_isNear ? widget.expandedSize : widget.widgetSize) / 2,
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
