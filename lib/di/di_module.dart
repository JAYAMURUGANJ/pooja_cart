import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pooja_cart/features/data/remote/datasources/category_remote_datasource.dart';
import 'package:pooja_cart/features/data/remote/datasources/place_order_datasource.dart';
import 'package:pooja_cart/features/data/remote/datasources/product_remote_datasource.dart';
import 'package:pooja_cart/features/data/remote/datasources/unit_remote_datasource.dart';
import 'package:pooja_cart/features/data/repository/place_order_repository_impl.dart';
import 'package:pooja_cart/features/data/repository/product_repository_impl.dart';
import 'package:pooja_cart/features/data/repository/units_repository_impl.dart';
import 'package:pooja_cart/features/domain/repository/category_repository.dart';
import 'package:pooja_cart/features/domain/repository/place_order_repository.dart';
import 'package:pooja_cart/features/domain/repository/product_repository.dart';
import 'package:pooja_cart/features/domain/repository/units_repository.dart';
import 'package:pooja_cart/features/domain/usecase/category/get_category_usecase.dart';
import 'package:pooja_cart/features/domain/usecase/place_order/create_place_order_usecase.dart';
import 'package:pooja_cart/features/domain/usecase/product/get_products_usecase.dart';
import 'package:pooja_cart/features/domain/usecase/units/get_units_usecase.dart';
import 'package:pooja_cart/features/presentation/screens/confirm_order/bloc/place_order/place_order_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/home/bloc/category/category_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/home/bloc/product/product_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/home/bloc/unit/unit_bloc.dart';

import '../core/network/dio_client.dart';
import '../core/network/network_info.dart';
import '../features/data/repository/category_repository_impl.dart';

final sl = GetIt.instance;

class DiModule {
  Future<void> init() async {
    // Bloc
    sl.registerFactory(() => UnitBloc(sl()));
    sl.registerFactory(() => ProductBloc(sl()));
    sl.registerFactory(() => CategoryBloc(sl()));
    sl.registerFactory(() => PlaceOrderBloc(sl()));

    // Use cases
    sl.registerLazySingleton(() => GetUnitsUseCase(sl()));
    sl.registerLazySingleton(() => GetProductUseCase(sl()));
    sl.registerLazySingleton(() => GetCategoryUseCase(sl()));
    sl.registerLazySingleton(() => CreatePlaceOrderUseCase(sl()));

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

    //! Core
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
    sl.registerLazySingleton(() => DioClient());
    sl.registerLazySingleton(() => InternetConnection());
  }
}
