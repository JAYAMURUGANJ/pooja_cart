import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../data/remote/model/request/common_request_model.dart';
import '../entities/place_order/place_order_response.dart';

abstract class PlaceOrderRepository {
  Future<Either<Failure, List<PlaceOrderResponse>>> getPlaceOrder(
    CommonRequestModel getRequest,
  );
  Future<Either<Failure, PlaceOrderResponse>> createPlaceOrder(
    CommonRequestModel request,
  );
  Future<Either<Failure, PlaceOrderResponse>> updatePlaceOrder(
    CommonRequestModel request,
  );
  Future<Either<Failure, String>> deletePlaceOrder(CommonRequestModel request);
}
