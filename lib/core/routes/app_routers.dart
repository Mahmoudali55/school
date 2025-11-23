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
          builder: (_) => BlocProvider(
            create: (context) => sl<AuthCubit>(),
            child: LoginScreen(selectedUserType: args as UserTypeModel),
          ),
        );

      case RoutesName.onBoardingScreen:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(create: (context) => sl<OnBoardingCubit>(), child: OnBoardingScreen()),
        );
      case RoutesName.selectInterfaceScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<InterfaceCubit>(),
            child: SelectInterfaceScreen(),
          ),
        );
      case RoutesName.forgetPasswordScreen:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(create: (context) => sl<AuthCubit>(), child: ForgetPasswordScreen()),
        );
      case RoutesName.layoutScreen:
        return MaterialPageRoute(builder: (_) => LayoutScreen(selectedUserType: args));
      case RoutesName.notificationsScreen:
        return MaterialPageRoute(builder: (_) => NotificationsScreen());

      case RoutesName.notificationsParentScreen:
        return MaterialPageRoute(builder: (_) => NotificationsParentScreen());
      default:
        return null;
    }
  }
}
