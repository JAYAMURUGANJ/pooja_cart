import 'package:dartz/dartz.dart';
import 'package:pooja_cart/features/domain/entities/admin/admin_dashboard/admin_dashboard_response.dart';

import '../../../../core/errors/failures.dart';
import '../../../data/remote/model/request/common_request_model.dart';

abstract class AdminDashboardRepository {
  Future<Either<Failure, AdminDashboardResponse>> getDashboardData(
    CommonRequestModel getRequest,
  );
}
