import 'package:bloc/bloc.dart';

import '../../../../../../domain/entities/product/product_response.dart';

class AddUnitsCubit extends Cubit<List<ProductUnit>> {
  AddUnitsCubit() : super([]);

  void addUnit(ProductUnit unit) {
    final updatedUnits = List<ProductUnit>.from(state);
    updatedUnits.add(unit);
    emit(updatedUnits);
  }

  void removeUnit(ProductUnit unit) {
    final updatedUnits = List<ProductUnit>.from(state);
    updatedUnits.remove(unit);
    emit(updatedUnits);
  }

  void clearUnits() {
    state.clear();
    emit([]);
  }

  List<ProductUnit> getUnits() {
    return state;
  }
}
