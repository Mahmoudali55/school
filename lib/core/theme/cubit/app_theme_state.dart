part of 'app_theme_cubit.dart';

abstract class AppThemeState {
  const AppThemeState();
}

class AppThemeInitial extends AppThemeState {
  const AppThemeInitial();
}

class AppThemeLoading extends AppThemeState {
  const AppThemeLoading();
}

class AppThemeUpdated extends AppThemeState {
  final ThemeEnum theme;

  const AppThemeUpdated({required this.theme});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppThemeUpdated && other.theme == theme;
  }

  @override
  int get hashCode => theme.hashCode;

  @override
  String toString() => 'AppThemeUpdated(theme: $theme)';
}

class AppThemeError extends AppThemeState {
  final String error;

  const AppThemeError({required this.error});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppThemeError && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'AppThemeError(error: $error)';
}
