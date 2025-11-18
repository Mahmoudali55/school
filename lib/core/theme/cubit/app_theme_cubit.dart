import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cache/hive/hive_methods.dart';
import '../theme_enum.dart';

part 'app_theme_state.dart';

class AppThemeCubit extends Cubit<AppThemeState> {
  AppThemeCubit() : super(AppThemeInitial());
  void initial() {
    _theme = HiveMethods.getTheme();
    emit(AppThemeUpdate());
  }

  ThemeEnum _theme = ThemeEnum.light;
  set theme(ThemeEnum value) {
    _theme = value;
    HiveMethods.updateThem(_theme);
    emit(AppThemeUpdate());
  }

  ThemeEnum get theme => _theme;
}
