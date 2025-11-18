// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeEnumAdapter extends TypeAdapter<ThemeEnum> {
  @override
  final int typeId = 3;

  @override
  ThemeEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ThemeEnum.light;
      case 1:
        return ThemeEnum.dark;
      default:
        return ThemeEnum.light;
    }
  }

  @override
  void write(BinaryWriter writer, ThemeEnum obj) {
    switch (obj) {
      case ThemeEnum.light:
        writer.writeByte(0);
        break;
      case ThemeEnum.dark:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
