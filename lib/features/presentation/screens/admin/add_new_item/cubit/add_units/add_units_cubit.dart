import 'package:bloc/bloc.dart';

import '../../../../../../domain/entities/product/product_response.dart';

class AddUnitsCubit extends Cubit<List<ProductUnitResponse>> {
  AddUnitsCubit() : super([]);

  void addUnit(ProductUnitResponse unit) {
    final updatedUnits = List<ProductUnitResponse>.from(state);
    updatedUnits.add(unit);
    emit(updatedUnits);
  }

  void removeUnit(ProductUnitResponse unit) {
    final updatedUnits = List<ProductUnitResponse>.from(state);
    updatedUnits.remove(unit);
    emit(updatedUnits);
  }

  void clearUnits() {
    state.clear();
    emit([]);
  }

  List<ProductUnitResponse> getUnits() {
    return state;
  }
}
