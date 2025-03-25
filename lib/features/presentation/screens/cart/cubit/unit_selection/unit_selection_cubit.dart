import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/domain/entities/product/product_response.dart';

part 'unit_selection_state.dart';

class UnitSelectionCubit extends Cubit<UnitSelectionState> {
  UnitSelectionCubit() : super(UnitSelectionState());

  void initializeDefaultUnits(List<ProductResponse> products) {
    final Map<int, Unit> defaultUnits = {};

    for (var product in products) {
      final defaultUnit = product.units!.firstWhere(
        (unit) => unit.isDefault == 1,
        orElse: () => product.units!.first,
      );
      defaultUnits[product.id!] = defaultUnit;
    }
    emit(
      state.copyWith(
        status: UnitSelectionStatus.selected,
        selectedUnits: defaultUnits,
      ),
    );
  }

  void selectUnit(int productId, Unit unit) {
    final updatedSelections = Map<int, Unit>.from(state.selectedUnits);
    updatedSelections[productId] = unit;

    emit(
      state.copyWith(
        status: UnitSelectionStatus.selected,
        selectedUnits: updatedSelections,
      ),
    );
  }

  void resetUnitSelection(int productId) {
    final updatedSelections = Map<int, Unit>.from(state.selectedUnits);
    updatedSelections.remove(productId);

    emit(
      state.copyWith(
        status:
            updatedSelections.isEmpty
                ? UnitSelectionStatus.unSelected
                : state.status,
        selectedUnits: updatedSelections,
      ),
    );
  }
}
