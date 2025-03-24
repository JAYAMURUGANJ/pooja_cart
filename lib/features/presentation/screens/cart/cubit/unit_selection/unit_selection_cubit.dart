import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/domain/entities/product/product_response.dart';

part 'unit_selection_state.dart';

class UnitSelectionCubit extends Cubit<UnitSelectionState> {
  UnitSelectionCubit() : super(UnitSelectionState());

  selectActivity(Unit unit) {
    emit(
      UnitSelectionState().copyWith(
        status: UnitSelectionStatus.selected,
        selectedUnit: unit,
      ),
    );
  }

  resetActivitySelection() {
    emit(
      UnitSelectionState().copyWith(
        status: UnitSelectionStatus.unSelected,
        selectedUnit: null,
      ),
    );
  }
}
