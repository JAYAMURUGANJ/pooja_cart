import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../data/remote/model/request/common_request_model.dart';
import '../entities/my_orders/my_orders_response.dart';

abstract class MyOrdersRepository {
  Future<Either<Failure, List<MyOrdersResponse>>> getMyOrdersById(
    CommonRequestModel getRequest,
  );
  Future<Either<Failure, List<MyOrdersResponse>>> getMyOrdersByMobile(
    CommonRequestModel getRequest,
  );
}
