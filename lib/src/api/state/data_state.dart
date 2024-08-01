
import 'package:chat/src/api/failure/failure.dart';

abstract class DataState<T> {
  T? _data;
  Failure? _failure;

  DataState._({
    T? data,
    Failure? failure,
  })  : _data = data,
        _failure = failure;

  T get data => _data!;
  Failure get failure => _failure!;

  bool get isSuccess => _data != null;
  bool get isFailure => _failure != null;

  factory DataState.success(T data) = DataSuccess;
  factory DataState.failure(Failure failure) = DataFailure;
}

class DataSuccess<T> extends DataState<T> {
  DataSuccess(T data) : super._(data: data);
}

class DataFailure<T> extends DataState<T> {
  DataFailure(Failure failure) : super._(failure: failure);
}
