// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FarmerHiveModelAdapter extends TypeAdapter<FarmerHiveModel> {
  @override
  final int typeId = 0;

  @override
  FarmerHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FarmerHiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      phone: fields[2] as String,
      sector: fields[3] as String,
      cell: fields[4] as String,
      village: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FarmerHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.sector)
      ..writeByte(4)
      ..write(obj.cell)
      ..writeByte(5)
      ..write(obj.village);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FarmerHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
