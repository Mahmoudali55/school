import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/theme/cubit/app_theme_cubit.dart';
import 'service_initialize.dart';

void main() async {
  await ServiceInitialize.initialize();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'i18n',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      saveLocale: true,
      child: BlocProvider(
        create: (context) => AppThemeCubit()..initial(),
        child: const TempApp(),
      ),
    ),
  );
}
