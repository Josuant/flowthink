import 'dart:ui';

import 'package:flow/features/flow/domain/entities/flow_connection.dart';
import 'package:flow/features/flow/utils/enums/flow_block_enums.dart';
import 'package:hive/hive.dart';

part 'flow_connection_model.g.dart';

@HiveType(typeId: 0)
class FlowConnectionModel {
  @HiveField(0)
  final String flowIdA;
  @HiveField(1)
  final String flowIdB;
  @HiveField(2)
  final FlowConnectionDirection flowConnectionDirectionA;
  @HiveField(3)
  final FlowConnectionDirection flowConnectionDirectionB;
  @HiveField(4)
  final Color color;
  @HiveField(5)
  final bool isDotted;
  @HiveField(6)
  final double thickness;
  @HiveField(7)
  final double cornerRadius;
  @HiveField(8)
  final String label;
  @HiveField(9)
  final double labelPostion;

  FlowConnectionModel({
    required this.flowIdA,
    required this.flowIdB,
    required this.flowConnectionDirectionA,
    required this.flowConnectionDirectionB,
    required this.color,
    required this.isDotted,
    required this.thickness,
    required this.cornerRadius,
    required this.label,
    required this.labelPostion,
  });

  // Conversion from Entity to Model
  static FlowConnectionModel fromEntity(FlowConnection entity) {
    return FlowConnectionModel(
      flowIdA: entity.flowIdA,
      flowIdB: entity.flowIdB,
      flowConnectionDirectionA: entity.flowConnectionDirectionA,
      flowConnectionDirectionB: entity.flowConnectionDirectionB,
      color: entity.color,
      isDotted: entity.isDotted,
      thickness: entity.thickness,
      cornerRadius: entity.cornerRadius,
      label: entity.label,
      labelPostion: entity.labelPosition,
    );
  }

  // Conversion from Model to Entity
  FlowConnection toEntity() {
    return FlowConnection(
      flowIdA: flowIdA,
      flowIdB: flowIdB,
      flowConnectionDirectionA: flowConnectionDirectionA,
      flowConnectionDirectionB: flowConnectionDirectionB,
      color: color,
      isDotted: isDotted,
      thickness: thickness,
      cornerRadius: cornerRadius,
      label: label,
      labelPosition: labelPostion,
    );
  }
}
