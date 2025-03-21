part of 'unit_bloc.dart';

class UnitEvent {}

class GetUnitsEvent extends UnitEvent {
  final CommonRequestModel requestData;
  GetUnitsEvent(this.requestData);
}

class CreateUnitEvent extends UnitEvent {
  final CommonRequestModel requestData;
  CreateUnitEvent(this.requestData);
}

class UpdateUnitEvent extends UnitEvent {
  final CommonRequestModel requestData;
  UpdateUnitEvent(this.requestData);
}

class DeleteUnitEvent extends UnitEvent {
  final CommonRequestModel requestData;
  DeleteUnitEvent(this.requestData);
}
