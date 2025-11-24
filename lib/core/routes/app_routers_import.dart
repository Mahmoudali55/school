import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/features/auth/presentation/view/screen/forget_password_screen.dart';
import 'package:my_template/features/auth/presentation/view/screen/login_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/assignments_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/digital_library_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/grades_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/schedule_screen.dart';
import 'package:my_template/features/home/presentation/view/screen/home_screen.dart';
import 'package:my_template/features/layout/presentation/screen/layout_screen.dart';
import 'package:my_template/features/notifications/presentation/screen/notifications_partent_screen.dart';
import 'package:my_template/features/notifications/presentation/screen/notifications_screen.dart';
import 'package:my_template/features/on_boarding/presentation/view/cubit/on_boarding_cubit.dart';
import 'package:my_template/features/on_boarding/presentation/view/screen/on_boarding_screen.dart';
import 'package:my_template/features/profile/presentation/screen/profile_screen.dart';
import 'package:my_template/features/select_interface/data/model/user_type_model.dart';
import 'package:my_template/features/select_interface/presentation/cubit/select_interface_cubit.dart';
import 'package:my_template/features/select_interface/presentation/screen/select_interface_screen.dart';

import '../../features/auth/presentation/view/cubit/auth_cubit.dart';
import '../../features/splash/presentation/view/screen/splash_screen.dart' show SplashScreen;
import '../services/services_locator.dart';

part 'app_routers.dart';
