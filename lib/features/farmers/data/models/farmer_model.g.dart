// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FarmerAdapter extends TypeAdapter<Farmer> {
  @override
  final int typeId = 0;

  @override
  Farmer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Farmer(
      id: fields[0] as String,
      name: fields[1] as String,
      phoneNumber: fields[2] as String,
      sector: fields[3] as String,
      cell: fields[4] as String,
      village: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Farmer obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phoneNumber)
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
      other is FarmerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
