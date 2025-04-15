part of 'unit_filter_selection_cubit.dart';

enum UnitFilterSelectionStatus { unSelected, selected, error }

class UnitFilterSelectionState {
  final UnitFilterSelectionStatus status;
  final CategoryUnit? unitResponse;
  final String? error;
  const UnitFilterSelectionState({
    this.status = UnitFilterSelectionStatus.unSelected,
    this.unitResponse,
    this.error,
  });

  UnitFilterSelectionState copyWith({
    UnitFilterSelectionStatus? status,
    CategoryUnit? unitResponse,
    String? error,
  }) {
    return UnitFilterSelectionState(
      status: status ?? this.status,
      unitResponse: unitResponse ?? this.unitResponse,
      error: error ?? this.error,
    );
  }
}
