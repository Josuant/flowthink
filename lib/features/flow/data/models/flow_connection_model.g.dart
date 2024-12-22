// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flow_connection_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlowConnectionModelAdapter extends TypeAdapter<FlowConnectionModel> {
  @override
  final int typeId = 0;

  @override
  FlowConnectionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlowConnectionModel(
      flowIdA: fields[0] as String,
      flowIdB: fields[1] as String,
      flowConnectionDirectionA: fields[2] as FlowConnectionDirection,
      flowConnectionDirectionB: fields[3] as FlowConnectionDirection,
      color: fields[4] as Color,
      isDotted: fields[5] as bool,
      thickness: fields[6] as double,
      cornerRadius: fields[7] as double,
      label: fields[8] as String,
      labelPostion: fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, FlowConnectionModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.flowIdA)
      ..writeByte(1)
      ..write(obj.flowIdB)
      ..writeByte(2)
      ..write(obj.flowConnectionDirectionA)
      ..writeByte(3)
      ..write(obj.flowConnectionDirectionB)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.isDotted)
      ..writeByte(6)
      ..write(obj.thickness)
      ..writeByte(7)
      ..write(obj.cornerRadius)
      ..writeByte(8)
      ..write(obj.label)
      ..writeByte(9)
      ..write(obj.labelPostion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlowConnectionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
