import 'package:bloc/bloc.dart';

import '../../../../../domain/entities/category/category_response.dart';

part 'unit_filter_selection_state.dart';

class UnitFilterSelectionCubit extends Cubit<UnitFilterSelectionState> {
  UnitFilterSelectionCubit() : super(UnitFilterSelectionState());

  selectUnit(CategoryUnit unit) {
    emit(
      UnitFilterSelectionState().copyWith(
        status: UnitFilterSelectionStatus.selected,
        unitResponse: unit,
      ),
    );
  }

  resetUnitSelection() {
    emit(
      UnitFilterSelectionState().copyWith(
        status: UnitFilterSelectionStatus.unSelected,
        unitResponse: null,
      ),
    );
  }
}
