// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milk_record_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MilkRecordHiveModelAdapter extends TypeAdapter<MilkRecordHiveModel> {
  @override
  final int typeId = 1;

  @override
  MilkRecordHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MilkRecordHiveModel(
      // id: fields[0] as String,
      // farmerId: fields[1] as String,
      // farmerName: fields[2] as String,
      phone: fields[3] as String,
      quantity: fields[4] as double,
      price: fields[5] as double,
      date: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MilkRecordHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      // ..write(obj.id)
      // ..writeByte(1)
      // ..write(obj.farmerId)
      // ..writeByte(2)
      // ..write(obj.farmerName)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MilkRecordHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
