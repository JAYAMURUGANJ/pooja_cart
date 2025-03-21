import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../core/network/dio_client.dart';
import '../core/network/network_info.dart';

final sl = GetIt.instance;

class DiModule {
  Future<void> init() async {
    // Bloc
    // sl.registerFactory(() => AuthBloc(loginUseCase: sl(), logoutUseCase: sl()));

    // // // // Use cases
    // sl.registerLazySingleton(() => LoginUseCase(sl()));

    // // // Repository
    // sl.registerLazySingleton<AuthRepository>(
    //   () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    // );

    // // // // Data sources
    // sl.registerLazySingleton<AuthRemoteDataSource>(
    //   () => AuthRemoteDataSourceImpl(dioClient: sl()),
    // );

    //! Core
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
    sl.registerLazySingleton(() => DioClient());
    sl.registerLazySingleton(() => InternetConnection());
  }
}
