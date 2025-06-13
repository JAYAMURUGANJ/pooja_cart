import 'package:dartz/dartz.dart';
import 'package:pooja_cart/core/errors/failures.dart';
import 'package:pooja_cart/features/data/remote/model/request/common_request_model.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../../domain/entities/admin/admin_report/admin_report_response.dart';
import '../../../domain/repository/admin/admin_report_repository.dart';
import '../../remote/datasources/admin/admin_report_remote_datasource.dart';

class AdminReportRepositoryImpl implements AdminReportRepository {
  final AdminReportRemoteDatasource remoteDataSource;
  final NetworkInfo networkInfo;
  AdminReportRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AdminReportResponse>> getReportData(
    CommonRequestModel getRequest,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getAdminReportData(getRequest);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
