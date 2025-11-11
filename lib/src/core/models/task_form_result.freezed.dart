// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_form_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskFormResult _$TaskFormResultFromJson(Map<String, dynamic> json) {
  return _TaskFormResult.fromJson(json);
}

/// @nodoc
mixin _$TaskFormResult {
  String? get id => throw _privateConstructorUsedError;
  String? get customer => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  TaskPriority get priority => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;

  /// Serializes this TaskFormResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskFormResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskFormResultCopyWith<TaskFormResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskFormResultCopyWith<$Res> {
  factory $TaskFormResultCopyWith(
          TaskFormResult value, $Res Function(TaskFormResult) then) =
      _$TaskFormResultCopyWithImpl<$Res, TaskFormResult>;
  @useResult
  $Res call(
      {String? id,
      String? customer,
      String title,
      DateTime? dueDate,
      TaskPriority priority,
      String? notes,
      bool isCompleted});
}

/// @nodoc
class _$TaskFormResultCopyWithImpl<$Res, $Val extends TaskFormResult>
    implements $TaskFormResultCopyWith<$Res> {
  _$TaskFormResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskFormResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? customer = freezed,
    Object? title = null,
    Object? dueDate = freezed,
    Object? priority = null,
    Object? notes = freezed,
    Object? isCompleted = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      customer: freezed == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskFormResultImplCopyWith<$Res>
    implements $TaskFormResultCopyWith<$Res> {
  factory _$$TaskFormResultImplCopyWith(_$TaskFormResultImpl value,
          $Res Function(_$TaskFormResultImpl) then) =
      __$$TaskFormResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? customer,
      String title,
      DateTime? dueDate,
      TaskPriority priority,
      String? notes,
      bool isCompleted});
}

/// @nodoc
class __$$TaskFormResultImplCopyWithImpl<$Res>
    extends _$TaskFormResultCopyWithImpl<$Res, _$TaskFormResultImpl>
    implements _$$TaskFormResultImplCopyWith<$Res> {
  __$$TaskFormResultImplCopyWithImpl(
      _$TaskFormResultImpl _value, $Res Function(_$TaskFormResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskFormResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? customer = freezed,
    Object? title = null,
    Object? dueDate = freezed,
    Object? priority = null,
    Object? notes = freezed,
    Object? isCompleted = null,
  }) {
    return _then(_$TaskFormResultImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      customer: freezed == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskFormResultImpl implements _TaskFormResult {
  const _$TaskFormResultImpl(
      {this.id,
      this.customer,
      required this.title,
      this.dueDate,
      required this.priority,
      this.notes,
      this.isCompleted = false});

  factory _$TaskFormResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskFormResultImplFromJson(json);

  @override
  final String? id;
  @override
  final String? customer;
  @override
  final String title;
  @override
  final DateTime? dueDate;
  @override
  final TaskPriority priority;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isCompleted;

  @override
  String toString() {
    return 'TaskFormResult(id: $id, customer: $customer, title: $title, dueDate: $dueDate, priority: $priority, notes: $notes, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskFormResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, customer, title, dueDate, priority, notes, isCompleted);

  /// Create a copy of TaskFormResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskFormResultImplCopyWith<_$TaskFormResultImpl> get copyWith =>
      __$$TaskFormResultImplCopyWithImpl<_$TaskFormResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskFormResultImplToJson(
      this,
    );
  }
}

abstract class _TaskFormResult implements TaskFormResult {
  const factory _TaskFormResult(
      {final String? id,
      final String? customer,
      required final String title,
      final DateTime? dueDate,
      required final TaskPriority priority,
      final String? notes,
      final bool isCompleted}) = _$TaskFormResultImpl;

  factory _TaskFormResult.fromJson(Map<String, dynamic> json) =
      _$TaskFormResultImpl.fromJson;

  @override
  String? get id;
  @override
  String? get customer;
  @override
  String get title;
  @override
  DateTime? get dueDate;
  @override
  TaskPriority get priority;
  @override
  String? get notes;
  @override
  bool get isCompleted;

  /// Create a copy of TaskFormResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskFormResultImplCopyWith<_$TaskFormResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
