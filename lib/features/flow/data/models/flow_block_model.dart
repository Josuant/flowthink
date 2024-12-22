import 'package:flow/features/flow/domain/entities/flow_block.dart';
import 'package:flow/features/flow/utils/enums/flow_block_type.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

part 'flow_block_model.g.dart';

@HiveType(typeId: 0)
class FlowBlockModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final FlowBlockType type;
  @HiveField(3)
  final Offset position;
  @HiveField(4)
  final double width;
  @HiveField(5)
  final double height;
  @HiveField(6)
  final double circleRadius;
  @HiveField(7)
  final double cornerRadius;
  @HiveField(8)
  final Color backgroundColor;
  @HiveField(9)
  final Color textColor;
  @HiveField(10)
  final Icon icon;
  @HiveField(11)
  final bool isSelected;
  @HiveField(12)
  final bool isHovered;
  @HiveField(13)
  final bool isEditing;
  @HiveField(14)
  final bool isDragging;
  @HiveField(15)
  final bool isAnimating;
  @HiveField(16)
  final bool isLocked;
  @HiveField(17)
  final bool isExpanded;
  @HiveField(18)
  final List<String> tags;

  FlowBlockModel({
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

  // Conversion from Entity to Model
  static FlowBlockModel fromEntity(FlowBlock entity) {
    return FlowBlockModel(
      id: entity.id,
      text: entity.text,
      type: entity.type,
      position: entity.position,
      width: entity.width,
      height: entity.height,
      circleRadius: entity.circleRadius,
      cornerRadius: entity.cornerRadius,
      backgroundColor: entity.backgroundColor,
      textColor: entity.textColor,
      icon: entity.icon,
      isSelected: entity.isSelected,
      isHovered: entity.isHovered,
      isEditing: entity.isEditing,
      isDragging: entity.isDragging,
      isAnimating: entity.isAnimating,
      isLocked: entity.isLocked,
      isExpanded: entity.isExpanded,
      tags: entity.tags,
    );
  }

  // Conversion from Model to Entity
  FlowBlock toEntity() {
    return FlowBlock(
      id: id,
      text: text,
      type: type,
      position: position,
      width: width,
      height: height,
      circleRadius: circleRadius,
      cornerRadius: cornerRadius,
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: icon,
      isSelected: isSelected,
      isHovered: isHovered,
      isEditing: isEditing,
      isDragging: isDragging,
      isAnimating: isAnimating,
      isLocked: isLocked,
      isExpanded: isExpanded,
      tags: tags,
    );
  }
}
