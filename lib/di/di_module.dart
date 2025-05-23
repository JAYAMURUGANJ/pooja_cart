import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pooja_cart/features/data/remote/datasources/admin/admin_orders_remote_datasource.dart';
import 'package:pooja_cart/features/data/remote/datasources/category_remote_datasource.dart';
import 'package:pooja_cart/features/data/remote/datasources/my_orders_remote_datasource.dart';
import 'package:pooja_cart/features/data/remote/datasources/place_order_datasource.dart';
import 'package:pooja_cart/features/data/remote/datasources/product_remote_datasource.dart';
import 'package:pooja_cart/features/data/remote/datasources/unit_remote_datasource.dart';
import 'package:pooja_cart/features/data/repository/my_orders_repository_impl.dart';
import 'package:pooja_cart/features/data/repository/place_order_repository_impl.dart';
import 'package:pooja_cart/features/data/repository/product_repository_impl.dart';
import 'package:pooja_cart/features/data/repository/units_repository_impl.dart';
import 'package:pooja_cart/features/domain/repository/admin/admin_dashboard_repository.dart';
import 'package:pooja_cart/features/domain/repository/admin/admin_orders_repository.dart';
import 'package:pooja_cart/features/domain/repository/category_repository.dart';
import 'package:pooja_cart/features/domain/repository/my_orders_repository.dart';
import 'package:pooja_cart/features/domain/repository/place_order_repository.dart';
import 'package:pooja_cart/features/domain/repository/product_repository.dart';
import 'package:pooja_cart/features/domain/repository/units_repository.dart';
import 'package:pooja_cart/features/domain/usecase/admin/admin_orders/get_admin_orders_usecase.dart';
import 'package:pooja_cart/features/domain/usecase/category/delete_category_usecase.dart';
import 'package:pooja_cart/features/domain/usecase/category/get_category_usecase.dart';
import 'package:pooja_cart/features/domain/usecase/my_orders/get_my_orders_by_id_usecase.dart';
import 'package:pooja_cart/features/domain/usecase/my_orders/get_my_orders_by_mobile_usecase.dart';
import 'package:pooja_cart/features/domain/usecase/place_order/create_place_order_usecase.dart';
import 'package:pooja_cart/features/domain/usecase/product/create_product_usecase.dart';
import 'package:pooja_cart/features/domain/usecase/product/get_products_usecase.dart';
import 'package:pooja_cart/features/domain/usecase/units/get_units_usecase.dart';
import 'package:pooja_cart/features/presentation/screens/admin/orders/bloc/admin_orders/admin_orders_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/customer/confirm_order/bloc/place_order/place_order_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/customer/home/bloc/category/category_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/customer/home/bloc/product/product_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/customer/home/bloc/unit/unit_bloc.dart';

import '../core/network/dio_client.dart';
import '../core/network/network_info.dart';
import '../features/data/remote/datasources/admin/admin_dashboard_remote_datasource.dart';
import '../features/data/repository/admin/admin_dashboard_repository_impl.dart';
import '../features/data/repository/admin/admin_orders_repository_impl.dart';
import '../features/data/repository/category_repository_impl.dart';
import '../features/domain/usecase/admin/admin_dashboard/get_admin_dashboard_data_usecase.dart';
import '../features/presentation/screens/admin/dashboard/bloc/admin_dashboard_data/admin_dashboard_data_bloc.dart';
import '../features/presentation/screens/customer/my_orders/bloc/my_orders/my_orders_bloc.dart';

final sl = GetIt.instance;

class DiModule {
  Future<void> init() async {
    // Bloc
    sl.registerFactory(() => UnitBloc(sl()));
    sl.registerFactory(() => ProductBloc(sl(), sl()));
    sl.registerFactory(() => CategoryBloc(sl(), sl()));
    sl.registerFactory(() => PlaceOrderBloc(sl()));
    sl.registerFactory(() => MyOrdersBloc(sl(), sl()));
    sl.registerFactory(() => AdminOrdersBloc(sl()));
    sl.registerFactory(() => AdminDashboardDataBloc(sl()));

    // Use cases
    sl.registerLazySingleton(() => GetUnitsUseCase(sl()));
    sl.registerLazySingleton(() => GetProductUseCase(sl()));
    sl.registerLazySingleton(() => CreateProductUseCase(sl()));
    sl.registerLazySingleton(() => GetCategoryUseCase(sl()));
    sl.registerLazySingleton(() => DeleteCategoryUseCase(sl()));
    sl.registerLazySingleton(() => CreatePlaceOrderUseCase(sl()));
    sl.registerLazySingleton(() => GetMyOrdersByIdUseCase(sl()));
    sl.registerLazySingleton(() => GetMyOrdersByMobileUseCase(sl()));
    sl.registerLazySingleton(() => GetAdminOrdersUseCase(sl()));
    sl.registerLazySingleton(() => GetAdminDashboardDataUseCase(sl()));

    // Repository
    sl.registerLazySingleton<UnitsRepository>(
      () => UnitsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerLazySingleton<PlaceOrderRepository>(
      () => PlaceOrderRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerLazySingleton<MyOrdersRepository>(
      () => MyOrdersRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerLazySingleton<AdminOrdersRepository>(
      () =>
          AdminOrdersRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
    sl.registerLazySingleton<AdminDashboardRepository>(
      () => AdminDashboardRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ),
    );

    // // // // Data sources
    sl.registerLazySingleton<UnitRemoteDatasource>(
      () => UnitRemoteDatasourceImpl(dioClient: sl()),
    );
    sl.registerLazySingleton<ProductRemoteDatasource>(
      () => ProductRemoteDatasourceImpl(dioClient: sl()),
    );
    sl.registerLazySingleton<CategoryRemoteDatasource>(
      () => CategoryRemoteDatasourceImpl(dioClient: sl()),
    );
    sl.registerLazySingleton<PlaceOrderRemoteDatasource>(
      () => PlaceOrderRemoteDatasourceImpl(dioClient: sl()),
    );
    sl.registerLazySingleton<MyOrdersRemoteDatasource>(
      () => MyOrdersRemoteDatasourceImpl(dioClient: sl()),
    );
    sl.registerLazySingleton<AdminOrdersRemoteDatasource>(
      () => AdminOrdersRemoteDatasourceImpl(dioClient: sl()),
    );
    sl.registerLazySingleton<AdminDashboardRemoteDatasource>(
      () => AdminDashboardRemoteDatasourceImpl(dioClient: sl()),
    );

    //! Core
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
    sl.registerLazySingleton(() => DioClient());
    sl.registerLazySingleton(() => InternetConnection());
  }
}
