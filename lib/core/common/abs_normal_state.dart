import 'package:equatable/equatable.dart';
import 'package:weather_app/core/constants/enum.dart';

import 'failure_state.dart';

abstract class AbsNormalState<T> extends Equatable {
  final T? data;
  final Failure? failure;
  final AbsNormalStatus absNormalStatus;

  const AbsNormalState({
    this.failure,
    this.data,
    required this.absNormalStatus,
  });

  AbsNormalState<T> copyWith({
    T? data,
    Failure? failure,
    AbsNormalStatus? absNormalStatus,
  });

  @override
  List<Object?> get props => [data, failure, absNormalStatus];
}

class AbsNormalStateImpl<T> extends AbsNormalState<T> {
  const AbsNormalStateImpl({
    super.failure,
    super.data,
    required super.absNormalStatus,
  });

  @override
  AbsNormalState<T> copyWith({
    T? data,
    Failure? failure,
    AbsNormalStatus? absNormalStatus,
  }) {
    return AbsNormalStateImpl<T>(
      failure: failure ?? this.failure,
      absNormalStatus: absNormalStatus ?? this.absNormalStatus,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [data, failure, absNormalStatus];
}

class AbsNormalLoadingState<T> extends AbsNormalStateImpl<T> {
  const AbsNormalLoadingState()
    : super(absNormalStatus: AbsNormalStatus.LOADING);
}

class AbsNormalSuccessState<T> extends AbsNormalStateImpl<T> {
  const AbsNormalSuccessState({required T data})
    : super(data: data, absNormalStatus: AbsNormalStatus.SUCCESS);
}

class AbsNormalFailureState<T> extends AbsNormalStateImpl<T> {
  const AbsNormalFailureState({required Failure failure})
    : super(failure: failure, absNormalStatus: AbsNormalStatus.ERROR);
}

class AbsNormalInitialState<T> extends AbsNormalStateImpl<T> {
  const AbsNormalInitialState()
    : super(absNormalStatus: AbsNormalStatus.INITIAL);
}
