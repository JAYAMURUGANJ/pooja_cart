import 'package:bloc/bloc.dart';
import 'package:pooja_cart/features/domain/entities/unit/unit_response.dart';

import '../../../../../data/remote/model/common_request_model.dart';
import '../../../../../domain/usecase/units/get_units_usecase.dart';

part 'unit_event.dart';
part 'unit_state.dart';

class UnitBloc extends Bloc<UnitEvent, UnitState> {
  final GetUnitsUseCase _getUnitUseCase;
  UnitBloc(this._getUnitUseCase) : super(UnitState()) {
    on<GetUnitsEvent>(_getAllUnits);
  }
  _getAllUnits(GetUnitsEvent event, Emitter<UnitState> emit) async {
    try {
      emit(state.copyWith(status: UnitStatus.loading));

      final result = await _getUnitUseCase(event.requestData);
      emit(
        result.fold(
          (failure) => state.copyWith(
            status: UnitStatus.error,
            errorMsg: failure.message,
          ),
          (getUnitResponse) => state.copyWith(
            status: UnitStatus.loaded,
            unitResponse: getUnitResponse,
          ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: UnitStatus.error, errorMsg: e.toString()));
    }
  }
}
