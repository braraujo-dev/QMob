import 'package:alternative/features/settings/data/datasources/profile_remote_datasouurce.dart';
import 'package:alternative/features/settings/data/repositories/profile_repository_impl.dart';
import 'package:alternative/features/settings/domain/repositories/profile_repository.dart';
import 'package:alternative/features/settings/domain/usecases/get_profile_usecase.dart';
import 'package:alternative/features/settings/presentation/controllers/profile_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecase.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import '../../features/checkin/presentation/controllers/checkin_controller.dart';
import '../../features/checkin/domain/entities/capital_entity.dart';
import '../../features/checkin/domain/repositories/checkin_repository.dart';
import '../../features/checkin/data/repositories/checkin_repository_impl.dart';
import '../../features/checkin/domain/usecases/get_checkin_status_usecase.dart';
import '../../features/queue/domain/repositories/queue_repository.dart';
import '../../features/queue/data/repositories/queue_repository_impl.dart';
import '../../features/queue/domain/usecases/get_queue_usecase.dart';
import '../../features/queue/domain/usecases/perform_checkin_usecase.dart';
import '../../features/queue/domain/usecases/perform_checkout_usecase.dart';
import '../../features/queue/domain/usecases/is_user_in_queue_usecase.dart';
import '../../features/queue/presentation/controllers/queue_controller.dart';
import '../../features/queue/data/datasources/queue_remote_datasource.dart';
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
  sl.registerLazySingleton(() => SendPasswordResetEmailUseCase(sl()));
  sl.registerFactory(() => AuthController(authUseCase: sl(), sendPasswordResetEmailUseCase: sl()));

  // Checkin
  sl.registerLazySingleton<CheckinRepository>(() => CheckinRepositoryImpl());
  sl.registerLazySingleton(() => const GetCheckinStatusUseCase());

  sl.registerFactoryParam<CheckinController, CapitalEntity, void>(
    (destination, _) => CheckinController(
      destination: destination,
      locationService: sl(),
      getCheckinStatusUseCase: sl(),
      performCheckinUseCase: sl(),
      isUserInQueueUseCase: sl(),
    ),
  );

  // Queue
  sl.registerLazySingleton<QueueRemoteDataSource>(() => QueueRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<QueueRepository>(() => QueueRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => GetQueueUseCase(sl()));
  sl.registerLazySingleton(() => PerformCheckinUseCase(sl()));
  sl.registerLazySingleton(() => PerformCheckoutUseCase(sl()));
  sl.registerLazySingleton(() => IsUserInQueueUseCase(sl()));

  // Profile Feature
  sl.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));

  sl.registerFactory(
    () => ProfileController(getProfileUseCase: sl(), repository: sl(), supabase: sl()),
  );

  sl.registerFactory(() => QueueController(getQueueUseCase: sl(), performCheckoutUseCase: sl()));
}
