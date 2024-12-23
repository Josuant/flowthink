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
      tags: tags,
    );
  }

  // CopyWith method
  FlowBlockModel copyWith({
    String? id,
    String? text,
    FlowBlockType? type,
    Offset? position,
    double? width,
    double? height,
    double? circleRadius,
    double? cornerRadius,
    Color? backgroundColor,
    Color? textColor,
    Icon? icon,
    List<String>? tags,
  }) {
    return FlowBlockModel(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      position: position ?? this.position,
      width: width ?? this.width,
      height: height ?? this.height,
      circleRadius: circleRadius ?? this.circleRadius,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      icon: icon ?? this.icon,
      tags: tags ?? this.tags,
    );
  }
}
