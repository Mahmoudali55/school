part of 'app_routers_import.dart';

class AppRouters {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    dynamic args;
    if (settings.arguments != null) args = settings.arguments;
    switch (settings.name) {
      case RoutesName.splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case RoutesName.homeScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RoutesName.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(value: sl<AuthCubit>(), child: const LoginScreen()),
        );
      case RoutesName.registerScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(value: sl<AuthCubit>(), child: const RegisterScreen()),
        );

      case RoutesName.onBoardingScreen:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(create: (context) => sl<OnBoardingCubit>(), child: OnBoardingScreen()),
        );

      // case RoutesName.forgetPasswordScreen:
      //   return MaterialPageRoute(
      //     builder: (_) =>
      //         BlocProvider(create: (context) => sl<AuthCubit>(), child: ForgetPasswordScreen()),
      //   );
      case RoutesName.layoutScreen:
        return MaterialPageRoute(builder: (_) => LayoutScreen(type: args));
      case RoutesName.notificationsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<NotificationCubit>()..loadNotifications(),
            child: NotificationsScreen(),
          ),
        );

      case RoutesName.notificationsParentScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<NotificationCubit>()..loadNotifications(),
            child: NotificationsParentScreen(),
          ),
        );
      case RoutesName.profileScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<ProfileCubit>()..loadStudentProfile(),
            child: ProfileScreen(),
          ),
        );
      case RoutesName.showStudentBalanceScreen:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(create: (context) => sl<HomeCubit>(), child: ShowStudentBalanceScreen()),
        );
      case RoutesName.digitalLibraryScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<HomeCubit>(),
            child: const DigitalLibraryScreen(),
          ),
        );
      case RoutesName.assignmentsScreen:
        int? code;
        String? date;
        if (args is Map<String, dynamic>) {
          code = args['code'];
          date = args['date'];
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<ClassCubit>(),
            child: AssignmentsScreen(code: code, hwDate: date),
          ),
        );
      case RoutesName.scheduleScreen:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(create: (context) => sl<ScheduleCubit>(), child: ScheduleScreen()),
        );
      case RoutesName.gradesScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(create: (context) => sl<HomeCubit>(), child: GradesScreen()),
        );
      case RoutesName.parentProfileScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<ProfileCubit>()..loadParentProfile(args),
            child: ParentProfileScreen(),
          ),
        );
      case RoutesName.messagesScreen:
        return MaterialPageRoute(builder: (_) => ChatsListScreen());
      case RoutesName.uniformParentScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<HomeCubit>(),
            child: const UniformParentScreen(),
          ),
        );
      case RoutesName.uniformAdminScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<HomeCubit>()..getUniform(),
            child: const UniformAdminScreen(),
          ),
        );
      case RoutesName.leaveParentScreen:
        final argsMap = args as Map<String, dynamic>;
        final studentId = argsMap['studentId'] as String;
        final homeCubit = argsMap['homeCubit'] as HomeCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: homeCubit,
            child: LeaveParentScreen(studentId: studentId),
          ),
        );
      case RoutesName.leaveAdminScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<HomeCubit>()..getPermissions(),
            child: const LeaveAdminScreen(),
          ),
        );
      case RoutesName.pickupAdminScreen:
        return MaterialPageRoute(
          builder: (context) =>
              BlocProvider(create: (context) => sl<HomeCubit>(), child: const PickUpAdminScreen()),
        );
      case RoutesName.studentAIAssistantScreen:
        return MaterialPageRoute(builder: (_) => const StudentAIAssistantScreen());
      case RoutesName.teacherScreen:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(create: (context) => sl<HomeCubit>(), child: const TeacherScreen()),
        );
      case RoutesName.adminScheduleGeneratorScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<ScheduleCubit>(),
            child: const AdminScheduleGeneratorScreen(),
          ),
        );
      case RoutesName.admissionRequestScreen:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider.value(value: sl<AuthCubit>(), child: const AdmissionRequestScreen()),
        );
      default:
        return null;
    }
  }
}
