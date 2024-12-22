import 'package:flutter/material.dart';

class XmlViewerWidget extends StatelessWidget {
  final String xmlData;

  const XmlViewerWidget({super.key, required this.xmlData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: SelectableText(
          xmlData,
          style: const TextStyle(fontSize: 16, fontFamily: 'Courier'),
        ),
      ),
    );
  }
}
