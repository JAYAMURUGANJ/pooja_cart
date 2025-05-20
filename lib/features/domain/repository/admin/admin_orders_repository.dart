import 'package:dartz/dartz.dart';
import 'package:pooja_cart/features/domain/entities/admin/admin_orders/admin_orders_response.dart';

import '../../../../core/errors/failures.dart';
import '../../../data/remote/model/request/common_request_model.dart';

abstract class AdminOrdersRepository {
  Future<Either<Failure, List<AdminOrdersResponse>>> getAdminOrders(
    CommonRequestModel getRequest,
  );
  Future<Either<Failure, AdminOrdersResponse>> createAdminOrder(
    CommonRequestModel request,
  );
  Future<Either<Failure, AdminOrdersResponse>> updateAdminOrder(
    CommonRequestModel request,
  );
  Future<Either<Failure, String>> deleteAdminOrder(CommonRequestModel request);
}
