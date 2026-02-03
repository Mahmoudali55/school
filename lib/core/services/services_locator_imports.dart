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

  sl.registerLazySingleton<OnBoardingCubit>(() => OnBoardingCubit(repository: sl()));

  sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(sl()));
  sl.registerFactory<HomeCubit>(() => HomeCubit(sl(), sl()));

  sl.registerLazySingleton<ClassRepo>(() => ClassRepoImpl(sl()));
  sl.registerFactory<ClassCubit>(() => ClassCubit(sl()));

  sl.registerLazySingleton<CalendarRepo>(() => CalendarRepo());
  sl.registerFactory<CalendarCubit>(() => CalendarCubit(sl(), sl()));

  sl.registerLazySingleton<BusRepo>(() => BusRepoImpl(sl()));
  sl.registerFactory<BusCubit>(() => BusCubit(sl()));

  sl.registerLazySingleton<NotificationRepo>(() => NotificationRepo());
  sl.registerFactory<NotificationCubit>(() => NotificationCubit(sl()));

  sl.registerLazySingleton<ProfileRepo>(() => ProfileRepoImpl(sl()));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl()));

  sl.registerLazySingleton<SettingsRepo>(() => SettingsRepoImpl(sl()));
  sl.registerFactory<SettingsCubit>(() => SettingsCubit(sl()));

  sl.registerLazySingleton<UniformRepo>(() => UniformRepo());
  sl.registerFactory<UniformCubit>(() => UniformCubit(sl()));

  sl.registerLazySingleton<LeaveRepo>(() => LeaveRepo());
  sl.registerFactory<LeaveCubit>(() => LeaveCubit(sl()));

  sl.registerLazySingleton<PickUpRepo>(() => PickUpRepo());
  sl.registerFactory<PickUpCubit>(() => PickUpCubit(sl()));

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
