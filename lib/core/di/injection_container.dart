import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecase.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/checkin/presentation/controllers/checkin_controller.dart';
import '../../features/checkin/domain/entities/capital_entity.dart';
import '../../features/checkin/domain/repositories/checkin_repository.dart';
import '../../features/checkin/data/repositories/checkin_repository_impl.dart';
import '../../features/checkin/domain/usecases/get_checkin_status_usecase.dart';
import '../services/location_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Core Services
  sl.registerLazySingleton<ILocationService>(() => LocationService());

  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => AuthUseCase(sl()));
  sl.registerFactory(() => AuthController(sl()));

  // Checkin
  sl.registerLazySingleton<CheckinRepository>(() => CheckinRepositoryImpl());
  sl.registerLazySingleton(() => const GetCheckinStatusUseCase());
  
  sl.registerFactoryParam<CheckinController, CapitalEntity, void>(
    (destination, _) => CheckinController(
      destination: destination,
      locationService: sl(),
      getCheckinStatusUseCase: sl(),
    ),
  );
}
