import 'package:dartz/dartz.dart';
import 'package:pooja_cart/features/domain/entities/unit/unit_response.dart';

import '../../../core/errors/failures.dart';
import '../../data/remote/model/request/common_request_model.dart';

abstract class UnitsRepository {
  Future<Either<Failure, List<UnitResponse>>> getUnit(
    CommonRequestModel getRequest,
  );
  Future<Either<Failure, UnitResponse>> createUnit(CommonRequestModel request);
  Future<Either<Failure, UnitResponse>> updateUnit(CommonRequestModel request);
  Future<Either<Failure, String>> deleteUnit(CommonRequestModel request);
}
