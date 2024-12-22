// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flow_block_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlowBlockModelAdapter extends TypeAdapter<FlowBlockModel> {
  @override
  final int typeId = 0;

  @override
  FlowBlockModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlowBlockModel(
      id: fields[0] as String,
      text: fields[1] as String,
      type: fields[2] as FlowBlockType,
      position: fields[3] as Offset,
      width: fields[4] as double,
      height: fields[5] as double,
      circleRadius: fields[6] as double,
      cornerRadius: fields[7] as double,
      backgroundColor: fields[8] as Color,
      textColor: fields[9] as Color,
      icon: fields[10] as Icon,
      tags: (fields[11] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, FlowBlockModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.width)
      ..writeByte(5)
      ..write(obj.height)
      ..writeByte(6)
      ..write(obj.circleRadius)
      ..writeByte(7)
      ..write(obj.cornerRadius)
      ..writeByte(8)
      ..write(obj.backgroundColor)
      ..writeByte(9)
      ..write(obj.textColor)
      ..writeByte(10)
      ..write(obj.icon)
      ..writeByte(11)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlowBlockModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
