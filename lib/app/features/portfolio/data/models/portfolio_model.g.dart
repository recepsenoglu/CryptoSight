// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PortfolioModelAdapter extends TypeAdapter<PortfolioModel> {
  @override
  final int typeId = 1;

  @override
  PortfolioModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PortfolioModel(
      name: fields[0] as String,
      createdAt: fields[1] as DateTime,
      transactions: (fields[2] as List).cast<TransactionModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, PortfolioModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.transactions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PortfolioModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
