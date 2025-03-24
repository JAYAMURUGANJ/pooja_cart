part of 'unit_selection_cubit.dart';

enum UnitSelectionStatus { unSelected, selected, error }

class UnitSelectionState {
  final UnitSelectionStatus status;
  final Unit? selectedUnit;
  final String? error;
  const UnitSelectionState({
    this.status = UnitSelectionStatus.unSelected,
    this.selectedUnit,
    this.error,
  });

  UnitSelectionState copyWith({
    UnitSelectionStatus? status,
    Unit? selectedUnit,
    String? error,
  }) {
    return UnitSelectionState(
      status: status ?? this.status,
      selectedUnit: selectedUnit ?? selectedUnit,
      error: error ?? this.error,
    );
  }
}
