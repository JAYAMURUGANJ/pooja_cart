part of 'unit_bloc.dart';

enum UnitStatus { intial, loading, loaded, error }

class UnitState {
  final UnitStatus status;
  final List<UnitResponse>? unitResponse;
  final String? errorMsg;

  const UnitState({
    this.status = UnitStatus.intial,
    this.unitResponse,
    this.errorMsg,
  });

  UnitState copyWith({
    UnitStatus? status,
    final List<UnitResponse>? unitResponse,
    String? errorMsg,
  }) {
    return UnitState(
      status: status ?? this.status,
      unitResponse: unitResponse ?? this.unitResponse,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
