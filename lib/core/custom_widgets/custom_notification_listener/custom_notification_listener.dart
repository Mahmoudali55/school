import 'package:flutter/material.dart';

import '../../enum/cubit_state.dart';


class CustomNotificationListener extends StatelessWidget {
  final Widget child;
  final VoidCallback onLoadMore;
  final bool isLastPage;
  final CubitStatus paginationStatus;

  const CustomNotificationListener({
    super.key,
    required this.child,
    required this.onLoadMore,
    required this.isLastPage,
    required this.paginationStatus,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final scrollPosition = notification.metrics.pixels;
        final maxScrollExtent = notification.metrics.maxScrollExtent;
        final scrollThreshold = maxScrollExtent * 0.7;

        if (scrollPosition >= scrollThreshold &&
            !isLastPage &&
            paginationStatus != CubitStatus.loading) {
          onLoadMore();
        }

        return true;
      },
      child: child,
    );
  }
}
