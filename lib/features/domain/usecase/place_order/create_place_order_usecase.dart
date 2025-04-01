// lib/features/posts/domain/usecases/create_post.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../data/remote/model/request/common_request_model.dart';
import '../../entities/place_order/place_order_response.dart';
import '../../repository/place_order_repository.dart';

class CreatePlaceOrderUseCase
    implements UseCase<PlaceOrderResponse, CommonRequestModel> {
  final PlaceOrderRepository repository;

  CreatePlaceOrderUseCase(this.repository);

  @override
  Future<Either<Failure, PlaceOrderResponse>> call(
    CommonRequestModel params,
  ) async {
    return await repository.createPlaceOrder(params);
  }
}
