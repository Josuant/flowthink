import 'package:flow/core/utils/constants/ui_constants.dart';
import 'package:flow/features/flow/utils/constants/flow_default_constants.dart';
import 'package:flow/features/flow/utils/enums/flow_block_enums.dart';
import 'package:flutter/material.dart';

/// Represents a block in a flow diagram.
///
/// This class encapsulates all the properties of a flow block, including its
/// position, dimensions, and visual characteristics.
///
/// Parameters:
/// - [id]: A unique identifier for the block.
/// - [text]: The text content of the block.
/// - [type]: The type of the flow block, defined by [FlowBlockType].
/// - [position]: The position of the block in the flow diagram, represented as an [Offset].
/// - [width]: The width of the block.
/// - [height]: The height of the block.
/// - [circleRadius]: The radius of any circular elements in the block, if applicable.
/// - [cornerRadius]: The radius of the block's corners, if it has rounded corners.
class FlowBlock {
  final String id;
  final String text;
  final FlowBlockType type;
  final Offset position;
  final double width;
  final double height;
  final double circleRadius;
  final double cornerRadius;
  final Color backgroundColor;
  final Color textColor;
  final Icon icon;
  final List<String> tags;

  FlowBlock({
    required this.id,
    required this.text,
    required this.type,
    required this.position,
    required this.width,
    required this.height,
    required this.circleRadius,
    required this.cornerRadius,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
    required this.tags,
  });

  static FlowBlock buildDefault(String text, Offset position, {String? id}) {
    return FlowBlock(
      id: id ?? UniqueKey().toString(),
      type: FlowBlockType.process,
      text: text,
      width: FlowDefaultConstants.flowBlockWidth,
      height: FlowDefaultConstants.flowBlockHeight,
      position: position,
      circleRadius: FlowDefaultConstants.flowBlockCircleRadius,
      cornerRadius: FlowDefaultConstants.flowBlockCornerRadius,
      backgroundColor: AppColors.lightColor,
      textColor: AppColors.darkColor,
      icon: const Icon(
        Icons.favorite,
        color: Colors.pink,
        size: 24.0,
        semanticLabel: 'Text to announce in accessibility modes',
      ),
      tags: [],
    );
  }
}
