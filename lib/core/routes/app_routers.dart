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
          builder: (_) => BlocProvider(create: (context) => sl<AuthCubit>(), child: LoginScreen()),
        );
      case RoutesName.registerScreen:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(create: (context) => sl<AuthCubit>(), child: RegisterScreen()),
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
        return MaterialPageRoute(builder: (_) => DigitalLibraryScreen());
      case RoutesName.assignmentsScreen:
        return MaterialPageRoute(builder: (_) => AssignmentsScreen());
      case RoutesName.scheduleScreen:
        return MaterialPageRoute(builder: (_) => ScheduleScreen());
      case RoutesName.gradesScreen:
        return MaterialPageRoute(builder: (_) => GradesScreen());
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
            create: (context) => sl<UniformCubit>()..loadAdminData(),
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
            create: (context) => sl<LeaveCubit>()..fetchAllLeaves(),
            child: const LeaveAdminScreen(),
          ),
        );
      case RoutesName.pickupAdminScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<PickUpCubit>()..getPickUpRequests(),
            child: const PickUpAdminScreen(),
          ),
        );
      default:
        return null;
    }
  }
}
