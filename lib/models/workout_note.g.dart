// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutNoteAdapter extends TypeAdapter<WorkoutNote> {
  @override
  final int typeId = 1;

  @override
  WorkoutNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutNote(
      workoutDate: fields[0] as DateTime,
      workoutTime: fields[1] as String,
      exercise: (fields[2] as List).cast<String>(),
      notes: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutNote obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.workoutDate)
      ..writeByte(1)
      ..write(obj.workoutTime)
      ..writeByte(2)
      ..write(obj.exercise)
      ..writeByte(3)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
