// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milk_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MilkRecordAdapter extends TypeAdapter<MilkRecord> {
  @override
  final int typeId = 30;

  @override
  MilkRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MilkRecord(
      id: fields[0] as int,
      farmerId: fields[1] as int,
      farmerName: fields[2] as String,
      farmerPhone: fields[3] as String,
      liters: fields[4] as double,
      pricePerLiter: fields[5] as double,
      recordedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MilkRecord obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.farmerId)
      ..writeByte(2)
      ..write(obj.farmerName)
      ..writeByte(3)
      ..write(obj.farmerPhone)
      ..writeByte(4)
      ..write(obj.liters)
      ..writeByte(5)
      ..write(obj.pricePerLiter)
      ..writeByte(6)
      ..write(obj.recordedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MilkRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
