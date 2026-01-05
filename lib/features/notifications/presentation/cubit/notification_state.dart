import 'package:equatable/equatable.dart';
import 'package:my_template/features/notifications/data/model/notification_model.dart';

class NotificationState extends Equatable {
  final bool isLoading;
  final List<NotificationModel> notifications;
  final String? error;

  const NotificationState({this.isLoading = false, this.notifications = const [], this.error});

  NotificationState copyWith({
    bool? isLoading,
    List<NotificationModel>? notifications,
    String? error,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, notifications, error];
}
