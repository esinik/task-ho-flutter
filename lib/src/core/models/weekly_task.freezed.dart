// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeeklyNote _$WeeklyNoteFromJson(Map<String, dynamic> json) {
  return _WeeklyNote.fromJson(json);
}

/// @nodoc
mixin _$WeeklyNote {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;

  /// Serializes this WeeklyNote to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeeklyNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeeklyNoteCopyWith<WeeklyNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyNoteCopyWith<$Res> {
  factory $WeeklyNoteCopyWith(
          WeeklyNote value, $Res Function(WeeklyNote) then) =
      _$WeeklyNoteCopyWithImpl<$Res, WeeklyNote>;
  @useResult
  $Res call({String id, String title, String notes, bool isCompleted});
}

/// @nodoc
class _$WeeklyNoteCopyWithImpl<$Res, $Val extends WeeklyNote>
    implements $WeeklyNoteCopyWith<$Res> {
  _$WeeklyNoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeeklyNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? notes = null,
    Object? isCompleted = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyNoteImplCopyWith<$Res>
    implements $WeeklyNoteCopyWith<$Res> {
  factory _$$WeeklyNoteImplCopyWith(
          _$WeeklyNoteImpl value, $Res Function(_$WeeklyNoteImpl) then) =
      __$$WeeklyNoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, String notes, bool isCompleted});
}

/// @nodoc
class __$$WeeklyNoteImplCopyWithImpl<$Res>
    extends _$WeeklyNoteCopyWithImpl<$Res, _$WeeklyNoteImpl>
    implements _$$WeeklyNoteImplCopyWith<$Res> {
  __$$WeeklyNoteImplCopyWithImpl(
      _$WeeklyNoteImpl _value, $Res Function(_$WeeklyNoteImpl) _then)
      : super(_value, _then);

  /// Create a copy of WeeklyNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? notes = null,
    Object? isCompleted = null,
  }) {
    return _then(_$WeeklyNoteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklyNoteImpl implements _WeeklyNote {
  const _$WeeklyNoteImpl(
      {required this.id,
      required this.title,
      this.notes = '',
      this.isCompleted = false});

  factory _$WeeklyNoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyNoteImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey()
  final bool isCompleted;

  @override
  String toString() {
    return 'WeeklyNote(id: $id, title: $title, notes: $notes, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyNoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, notes, isCompleted);

  /// Create a copy of WeeklyNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyNoteImplCopyWith<_$WeeklyNoteImpl> get copyWith =>
      __$$WeeklyNoteImplCopyWithImpl<_$WeeklyNoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyNoteImplToJson(
      this,
    );
  }
}

abstract class _WeeklyNote implements WeeklyNote {
  const factory _WeeklyNote(
      {required final String id,
      required final String title,
      final String notes,
      final bool isCompleted}) = _$WeeklyNoteImpl;

  factory _WeeklyNote.fromJson(Map<String, dynamic> json) =
      _$WeeklyNoteImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get notes;
  @override
  bool get isCompleted;

  /// Create a copy of WeeklyNote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklyNoteImplCopyWith<_$WeeklyNoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WeeklyCalendarData {
  String get startDate =>
      throw _privateConstructorUsedError; // YYYY-MM-DD (Monday)
  String get endDate =>
      throw _privateConstructorUsedError; // YYYY-MM-DD (Sunday)
  Map<String, Map<String, List<WeeklyNote>>> get notes =>
      throw _privateConstructorUsedError;

  /// Create a copy of WeeklyCalendarData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeeklyCalendarDataCopyWith<WeeklyCalendarData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyCalendarDataCopyWith<$Res> {
  factory $WeeklyCalendarDataCopyWith(
          WeeklyCalendarData value, $Res Function(WeeklyCalendarData) then) =
      _$WeeklyCalendarDataCopyWithImpl<$Res, WeeklyCalendarData>;
  @useResult
  $Res call(
      {String startDate,
      String endDate,
      Map<String, Map<String, List<WeeklyNote>>> notes});
}

/// @nodoc
class _$WeeklyCalendarDataCopyWithImpl<$Res, $Val extends WeeklyCalendarData>
    implements $WeeklyCalendarDataCopyWith<$Res> {
  _$WeeklyCalendarDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeeklyCalendarData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? notes = null,
  }) {
    return _then(_value.copyWith(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, List<WeeklyNote>>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyCalendarDataImplCopyWith<$Res>
    implements $WeeklyCalendarDataCopyWith<$Res> {
  factory _$$WeeklyCalendarDataImplCopyWith(_$WeeklyCalendarDataImpl value,
          $Res Function(_$WeeklyCalendarDataImpl) then) =
      __$$WeeklyCalendarDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String startDate,
      String endDate,
      Map<String, Map<String, List<WeeklyNote>>> notes});
}

/// @nodoc
class __$$WeeklyCalendarDataImplCopyWithImpl<$Res>
    extends _$WeeklyCalendarDataCopyWithImpl<$Res, _$WeeklyCalendarDataImpl>
    implements _$$WeeklyCalendarDataImplCopyWith<$Res> {
  __$$WeeklyCalendarDataImplCopyWithImpl(_$WeeklyCalendarDataImpl _value,
      $Res Function(_$WeeklyCalendarDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of WeeklyCalendarData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? notes = null,
  }) {
    return _then(_$WeeklyCalendarDataImpl(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, List<WeeklyNote>>>,
    ));
  }
}

/// @nodoc

class _$WeeklyCalendarDataImpl implements _WeeklyCalendarData {
  const _$WeeklyCalendarDataImpl(
      {required this.startDate,
      required this.endDate,
      required final Map<String, Map<String, List<WeeklyNote>>> notes})
      : _notes = notes;

  @override
  final String startDate;
// YYYY-MM-DD (Monday)
  @override
  final String endDate;
// YYYY-MM-DD (Sunday)
  final Map<String, Map<String, List<WeeklyNote>>> _notes;
// YYYY-MM-DD (Sunday)
  @override
  Map<String, Map<String, List<WeeklyNote>>> get notes {
    if (_notes is EqualUnmodifiableMapView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_notes);
  }

  @override
  String toString() {
    return 'WeeklyCalendarData(startDate: $startDate, endDate: $endDate, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyCalendarDataImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(other._notes, _notes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate,
      const DeepCollectionEquality().hash(_notes));

  /// Create a copy of WeeklyCalendarData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyCalendarDataImplCopyWith<_$WeeklyCalendarDataImpl> get copyWith =>
      __$$WeeklyCalendarDataImplCopyWithImpl<_$WeeklyCalendarDataImpl>(
          this, _$identity);
}

abstract class _WeeklyCalendarData implements WeeklyCalendarData {
  const factory _WeeklyCalendarData(
          {required final String startDate,
          required final String endDate,
          required final Map<String, Map<String, List<WeeklyNote>>> notes}) =
      _$WeeklyCalendarDataImpl;

  @override
  String get startDate; // YYYY-MM-DD (Monday)
  @override
  String get endDate; // YYYY-MM-DD (Sunday)
  @override
  Map<String, Map<String, List<WeeklyNote>>> get notes;

  /// Create a copy of WeeklyCalendarData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklyCalendarDataImplCopyWith<_$WeeklyCalendarDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
