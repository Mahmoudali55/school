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

  sl.registerLazySingleton<ProfileRepo>(() => ProfileRepo());
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl()));

  sl.registerLazySingleton<SettingsRepo>(() => SettingsRepo());
  sl.registerFactory<SettingsCubit>(() => SettingsCubit(sl()));

  sl.registerLazySingleton<UniformRepo>(() => UniformRepo());
  sl.registerFactory<UniformCubit>(() => UniformCubit(sl()));

  sl.registerLazySingleton<LeaveRepo>(() => LeaveRepo());
  sl.registerFactory<LeaveCubit>(() => LeaveCubit(sl()));

  // Face Recognition & Attendance Services
  sl.registerLazySingleton<FaceDetectionService>(() => FaceDetectionService());
  sl.registerLazySingleton<CameraService>(() => CameraService());

  // Face Recognition & Attendance Repositories
  sl.registerLazySingleton<FaceRecognitionRepo>(() => FaceRecognitionRepo());
  sl.registerLazySingleton<AttendanceRepo>(() => AttendanceRepo());

  // Face Recognition & Attendance Cubits
  sl.registerFactory<FaceRecognitionCubit>(
    () => FaceRecognitionCubit(
      cameraService: sl(),
      faceDetectionService: sl(),
      faceRecognitionRepo: sl(),
    ),
  );
  sl.registerFactory<AttendanceCubit>(() => AttendanceCubit(attendanceRepo: sl()));
}
