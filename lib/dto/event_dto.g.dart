// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventDtoAdapter extends TypeAdapter<EventDto> {
  @override
  final int typeId = 2;

  @override
  EventDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventDto(
      fields[0] as String,
      (fields[1] as List).cast<String>(),
      fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, EventDto obj) {
    writer
      ..writeByte(3)
      ..writeByte(2)
      ..write(obj.colum)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.users);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
