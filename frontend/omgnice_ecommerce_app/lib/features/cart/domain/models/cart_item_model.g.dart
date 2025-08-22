// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemModelAdapter extends TypeAdapter<CartItemModel> {
  @override
  final int typeId = 0;

  @override
  CartItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemModel(
      cartItemId: fields[0] as int?,
      nameProduct: fields[1] as String?,
      productId: fields[2] as int?,
      variantId: fields[3] as int?,
      imageProduct: fields[4] as String?,
      variantName: fields[5] as String?,
      price: fields[6] as num?,
      discountPrice: fields[7] as num?,
      quantity: fields[8] as int?,
      note: fields[9] as String?,
      category_id: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, CartItemModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.cartItemId)
      ..writeByte(1)
      ..write(obj.nameProduct)
      ..writeByte(2)
      ..write(obj.productId)
      ..writeByte(3)
      ..write(obj.variantId)
      ..writeByte(4)
      ..write(obj.imageProduct)
      ..writeByte(5)
      ..write(obj.variantName)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.discountPrice)
      ..writeByte(8)
      ..write(obj.quantity)
      ..writeByte(9)
      ..write(obj.note)
      ..writeByte(10)
      ..write(obj.category_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
