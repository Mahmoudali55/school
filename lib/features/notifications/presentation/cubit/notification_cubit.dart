import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/notifications/data/repo/notification_repo.dart';

import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepo _notificationRepo;

  NotificationCubit(this._notificationRepo) : super(const NotificationState());

  Future<void> loadNotifications() async {
    emit(state.copyWith(isLoading: true));
    try {
      final notifications = await _notificationRepo.getNotifications();
      emit(state.copyWith(notifications: notifications, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void markAsRead(String id) {
    final updatedNotifications = state.notifications.map((n) {
      if (n.id == id) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    emit(state.copyWith(notifications: updatedNotifications));
  }
}
