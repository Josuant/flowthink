import 'package:flutter/material.dart';

import '../../features/flow/presentation/flow_styles.dart';

class XmlInputWidget extends StatefulWidget {
  final Function(String) onXmlSubmitted;
  final String hintText;
  final IconData sendIcon;
  final Color sendButtonColor;
  final Color sendIconColor;
  final Color borderColor;
  final double borderRadius;
  final LinearGradient backgroundGradient;

  const XmlInputWidget({
    super.key,
    required this.onXmlSubmitted,
    required this.hintText,
    this.sendIcon = Icons.send,
    this.sendButtonColor = const Color(0xFF876DDC),
    this.sendIconColor = Colors.white,
    this.borderColor = const Color(0xFF876DDC),
    this.borderRadius = 22.0,
    this.backgroundGradient = const LinearGradient(
      begin: Alignment(0.71, -0.71),
      end: Alignment(-0.71, 0.71),
      colors: [Color(0xFFF2F2F2), Colors.white],
    ),
  });

  @override
  State<XmlInputWidget> createState() => _XmlInputWidgetState();
}

class _XmlInputWidgetState extends State<XmlInputWidget> {
  final TextEditingController _controller = TextEditingController();

  void _submitXml(String xml) {
    xml = _controller.text;
    if (xml.isNotEmpty) {
      widget.onXmlSubmitted(xml);
      _controller.clear(); // Limpiar el campo después de enviar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 35),
        padding: const EdgeInsets.all(15),
        decoration: ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.71, -0.71),
            end: Alignment(-0.71, 0.71),
            colors: [Color(0xFFF2F2F2), Colors.white],
          ),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2, color: Color(0xFF876DDC)),
            borderRadius: BorderRadius.circular(22),
          ),
          shadows: FlowStyles.buildBoxShadows(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Color(0xFF787878),
                  fontSize: 16.0,
                ),
                onSubmitted: (xml) => _submitXml(xml),
              ),
            )
          ],
        ),
      ),
    );
  }
}
