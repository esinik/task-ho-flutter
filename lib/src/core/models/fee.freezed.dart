// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fee.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Fee _$FeeFromJson(Map<String, dynamic> json) {
  return _Fee.fromJson(json);
}

/// @nodoc
mixin _$Fee {
  String? get id => throw _privateConstructorUsedError;
  String get customer => throw _privateConstructorUsedError;
  String get month => throw _privateConstructorUsedError; // YYYY-MM
  double get amount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError; // Açık / Ödendi
  String get note => throw _privateConstructorUsedError;

  /// Serializes this Fee to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Fee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeeCopyWith<Fee> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeeCopyWith<$Res> {
  factory $FeeCopyWith(Fee value, $Res Function(Fee) then) =
      _$FeeCopyWithImpl<$Res, Fee>;
  @useResult
  $Res call(
      {String? id,
      String customer,
      String month,
      double amount,
      String status,
      String note});
}

/// @nodoc
class _$FeeCopyWithImpl<$Res, $Val extends Fee> implements $FeeCopyWith<$Res> {
  _$FeeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Fee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? customer = null,
    Object? month = null,
    Object? amount = null,
    Object? status = null,
    Object? note = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeeImplCopyWith<$Res> implements $FeeCopyWith<$Res> {
  factory _$$FeeImplCopyWith(_$FeeImpl value, $Res Function(_$FeeImpl) then) =
      __$$FeeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String customer,
      String month,
      double amount,
      String status,
      String note});
}

/// @nodoc
class __$$FeeImplCopyWithImpl<$Res> extends _$FeeCopyWithImpl<$Res, _$FeeImpl>
    implements _$$FeeImplCopyWith<$Res> {
  __$$FeeImplCopyWithImpl(_$FeeImpl _value, $Res Function(_$FeeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Fee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? customer = null,
    Object? month = null,
    Object? amount = null,
    Object? status = null,
    Object? note = null,
  }) {
    return _then(_$FeeImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeeImpl implements _Fee {
  const _$FeeImpl(
      {this.id,
      required this.customer,
      required this.month,
      required this.amount,
      required this.status,
      this.note = ''});

  factory _$FeeImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeeImplFromJson(json);

  @override
  final String? id;
  @override
  final String customer;
  @override
  final String month;
// YYYY-MM
  @override
  final double amount;
  @override
  final String status;
// Açık / Ödendi
  @override
  @JsonKey()
  final String note;

  @override
  String toString() {
    return 'Fee(id: $id, customer: $customer, month: $month, amount: $amount, status: $status, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, customer, month, amount, status, note);

  /// Create a copy of Fee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeeImplCopyWith<_$FeeImpl> get copyWith =>
      __$$FeeImplCopyWithImpl<_$FeeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeeImplToJson(
      this,
    );
  }
}

abstract class _Fee implements Fee {
  const factory _Fee(
      {final String? id,
      required final String customer,
      required final String month,
      required final double amount,
      required final String status,
      final String note}) = _$FeeImpl;

  factory _Fee.fromJson(Map<String, dynamic> json) = _$FeeImpl.fromJson;

  @override
  String? get id;
  @override
  String get customer;
  @override
  String get month; // YYYY-MM
  @override
  double get amount;
  @override
  String get status; // Açık / Ödendi
  @override
  String get note;

  /// Create a copy of Fee
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeeImplCopyWith<_$FeeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
