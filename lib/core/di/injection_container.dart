import 'package:qmob/features/home/data/datasources/driver_remote_datasource.dart';
import 'package:qmob/features/home/data/repositories/driver_repository_impl.dart';
import 'package:qmob/features/home/domain/repositories/driver_repository.dart';
import 'package:qmob/features/home/domain/usecases/delete_driver_usecase.dart';
import 'package:qmob/features/home/domain/usecases/get_capitals_usecase.dart';
import 'package:qmob/features/home/domain/usecases/get_driver_list_usecase.dart';
import 'package:qmob/features/home/domain/usecases/register_driver_usecase.dart';
import 'package:qmob/features/home/presentation/controllers/driver_register_controller.dart';
import 'package:qmob/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:qmob/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:qmob/features/profile/domain/repositories/profile_repository.dart';
import 'package:qmob/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:qmob/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:qmob/features/profile/presentation/controllers/profile_controller.dart';
import 'package:qmob/features/historic/data/datasources/historic_remote_datasource.dart';
import 'package:qmob/features/historic/data/repositories/historic_repository_impl.dart';
import 'package:qmob/features/historic/domain/repositories/historic_repository.dart';
import 'package:qmob/features/historic/domain/usecases/get_historic_usecase.dart';
import 'package:qmob/features/historic/domain/usecases/add_historic_usecase.dart';
import 'package:qmob/features/historic/presentation/controllers/historic_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecase.dart';
import '../../features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/checkin/presentation/controllers/checkin_controller.dart';
import '../../features/checkin/domain/repositories/checkin_repository.dart';
import '../../features/checkin/data/repositories/checkin_repository_impl.dart';
import '../../features/checkin/data/datasources/checkin_remote_datasource.dart';
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
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  sl.registerLazySingleton<ILocationService>(() => LocationService());

  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => AuthUseCase(sl()));
  sl.registerLazySingleton(() => SendPasswordResetEmailUseCase(sl()));
  sl.registerFactory(() => AuthController(authUseCase: sl(), sendPasswordResetEmailUseCase: sl()));

  // Queue
  sl.registerLazySingleton<QueueRemoteDataSource>(() => QueueRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<QueueRepository>(() => QueueRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => GetQueueUseCase(sl()));
  sl.registerLazySingleton(() => PerformCheckinUseCase(sl()));
  sl.registerLazySingleton(() => PerformCheckoutUseCase(sl()));
  sl.registerLazySingleton(() => IsUserInQueueUseCase(sl()));

  // Historic
  sl.registerLazySingleton<HistoricRemoteDataSource>(() => HistoricRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<HistoricRepository>(() => HistoricRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => GetHistoricUseCase(sl()));
  sl.registerLazySingleton(() => AddHistoricUseCase(sl()));
  sl.registerFactory(
    () => HistoricController(
      getHistoricUseCase: sl(),
      historicRepository: sl(),
      supabaseClient: sl(),
    ),
  );

  // Checkin
  sl.registerLazySingleton<CheckinRemoteDataSource>(() => CheckinRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<CheckinRepository>(() => CheckinRepositoryImpl(sl()));
  sl.registerLazySingleton(() => const GetCheckinStatusUseCase());
  sl.registerLazySingleton(() => GetCapitalsUseCase(sl()));

  sl.registerFactory(
    () => CheckinController(
      locationService: sl(),
      getCheckinStatusUseCase: sl(),
      performCheckinUseCase: sl(),
      authUseCase: sl(),
      checkinRepository: sl(),
      queueRepository: sl(),
      addHistoricUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => QueueController(
      getQueueUseCase: sl(),
      performCheckoutUseCase: sl(),
      queueRepository: sl(),
      addHistoricUseCase: sl(),
    ),
  );

  // Profile
  sl.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerFactory(
    () => ProfileController(
      getProfileUseCase: sl(),
      updateProfileUseCase: sl(),
      supabaseClient: sl(),
    ),
  );

  // Driver
  sl.registerLazySingleton<DriverRemoteDataSource>(() => DriverRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<DriverRepository>(() => DriverRepositoryImpl(sl()));
  sl.registerLazySingleton(() => RegisterDriverUseCase(sl()));
  sl.registerLazySingleton(() => GetDriversUseCase(sl()));
  sl.registerLazySingleton(() => DeleteDriverUseCase(sl()));

  sl.registerFactory(
    () => DriverRegisterController(
      registerDriverUseCase: sl(),
      getDriversUseCase: sl(),
      getCapitalsUseCase: sl(),
      deleteDriverUseCase: sl(),
    ),
  );
}
