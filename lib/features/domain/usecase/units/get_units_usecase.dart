// lib/features/posts/domain/usecases/create_post.dart
import 'package:dartz/dartz.dart';
import 'package:pooja_cart/features/domain/entities/unit/unit_response.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../data/remote/model/request/common_request_model.dart';
import '../../repository/units_repository.dart';

class GetUnitsUseCase
    implements UseCase<List<UnitResponse>, CommonRequestModel> {
  final UnitsRepository repository;

  GetUnitsUseCase(this.repository);

  @override
  Future<Either<Failure, List<UnitResponse>>> call(
    CommonRequestModel params,
  ) async {
    return await repository.getUnit(params);
  }
}
