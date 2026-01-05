part of 'services_locator.dart';

final sl = GetIt.instance;
Future<void> initDependencies() async {
  sl.registerLazySingleton<InternetConnection>(() => InternetConnection());
  sl.registerLazySingleton<AppInterceptors>(() => AppInterceptors());
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerFactory<ApiConsumer>(() => DioConsumer(client: sl()));
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()));
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(sl()));
  sl.registerLazySingleton<OnBoardingRepository>(() => OnBoardingRepository());

  sl.registerLazySingleton<InterfaceRepository>(() => InterfaceRepository());
  sl.registerLazySingleton<InterfaceCubit>(() => InterfaceCubit(repository: sl()));
  sl.registerLazySingleton<OnBoardingCubit>(() => OnBoardingCubit(repository: sl()));

  sl.registerLazySingleton<HomeRepo>(() => HomeRepo());
  sl.registerFactory<HomeCubit>(() => HomeCubit(sl()));

  sl.registerLazySingleton<ClassRepo>(() => ClassRepo());
  sl.registerFactory<ClassCubit>(() => ClassCubit(sl()));

  sl.registerLazySingleton<CalendarRepo>(() => CalendarRepo());
  sl.registerFactory<CalendarCubit>(() => CalendarCubit(sl()));

  sl.registerLazySingleton<BusRepo>(() => BusRepo());
  sl.registerFactory<BusCubit>(() => BusCubit(sl()));

  sl.registerLazySingleton<NotificationRepo>(() => NotificationRepo());
  sl.registerFactory<NotificationCubit>(() => NotificationCubit(sl()));
}
