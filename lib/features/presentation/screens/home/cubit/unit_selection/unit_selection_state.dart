part of 'unit_selection_cubit.dart';

enum UnitSelectionStatus { unSelected, selected, error }

class UnitSelectionState {
  final UnitSelectionStatus status;
  final Map<int, Unit> selectedUnits;
  final String? error;

  const UnitSelectionState({
    this.status = UnitSelectionStatus.unSelected,
    this.selectedUnits = const {},
    this.error,
  });

  UnitSelectionState copyWith({
    UnitSelectionStatus? status,
    Map<int, Unit>? selectedUnits,
    String? error,
  }) {
    return UnitSelectionState(
      status: status ?? this.status,
      selectedUnits: selectedUnits ?? this.selectedUnits,
      error: error ?? this.error,
    );
  }
}
