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
      farmerPhoneNumber: fields[0] as String,
      quantity: fields[1] as double,
      price: fields[2] as double,
      date: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MilkRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.farmerPhoneNumber)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.date);
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
