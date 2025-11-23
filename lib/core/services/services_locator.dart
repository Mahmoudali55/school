import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_template/features/auth/data/repository/auth_repo.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_cubit.dart';
import 'package:my_template/features/on_boarding/data/repository/on_boarding_rep.dart';
import 'package:my_template/features/on_boarding/presentation/view/cubit/on_boarding_cubit.dart';
import 'package:my_template/features/select_interface/data/repo/user_type_repo.dart';
import 'package:my_template/features/select_interface/presentation/cubit/select_interface_cubit.dart';

import '../network/api_consumer.dart';
import '../network/app_interceptors.dart';
import '../network/dio_consumer.dart';


part 'services_locator_imports.dart';
