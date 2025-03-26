// GENERATED CODE - DO NOT MODIFY BY HAND



// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************





import 'package:hive/hive.dart';
import 'package:smartstock/models/item_model.dart';

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 0;

  @override
  Item read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Item(
      itemName: fields[0] as String,
      quantity: fields[1] as String,
      purchaseDate: fields[2] as String,
      expiryDate: fields[3] as String,
      imagePath: fields[4] as String?,
      categoryType: fields[5] as String,
      itemType: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.itemName)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.purchaseDate)
      ..writeByte(3)
      ..write(obj.expiryDate)
      ..writeByte(4)
      ..write(obj.imagePath)
      ..writeByte(5)
      ..write(obj.categoryType)
      ..writeByte(6)
      ..write(obj.itemType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
