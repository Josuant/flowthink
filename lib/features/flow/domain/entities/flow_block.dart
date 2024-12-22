import 'package:flow/features/flow/utils/enums/flow_block_type.dart';
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
  final bool isSelected;
  final bool isHovered;
  final bool isEditing;
  final bool isDragging;
  final bool isAnimating;
  final bool isLocked;
  final bool isExpanded;
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
    required this.isSelected,
    required this.isHovered,
    required this.isEditing,
    required this.isDragging,
    required this.isAnimating,
    required this.isLocked,
    required this.isExpanded,
    required this.tags,
  });
}
