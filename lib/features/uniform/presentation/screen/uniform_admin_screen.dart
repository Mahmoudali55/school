import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';

import '../../../../core/utils/app_local_kay.dart';
import '../../data/model/uniform_model.dart';
import '../cubit/uniform_cubit.dart';

class UniformAdminScreen extends StatelessWidget {
  const UniformAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(AppLocalKay.uniform_orders.tr()),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<UniformCubit, UniformState>(
        builder: (context, state) {
          if (state is UniformLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UniformLoaded) {
            return _buildOrdersList(context, state.orders);
          } else if (state is UniformError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, List<UniformOrder> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text("No incoming orders"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.studentName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    _buildStatusChip(context, order.status),
                  ],
                ),
                Text(order.studentGrade, style: TextStyle(color: Colors.grey[600])),
                const Divider(height: 24),
                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${item.name} (${item.size})'),
                        Text(
                          '${item.price} SAR',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppLocalKay.order_status.tr()}:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _buildStatusDropdown(context, order),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(BuildContext context, UniformOrderStatus status) {
    Color color;
    String text;
    switch (status) {
      case UniformOrderStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case UniformOrderStatus.preparing:
        color = Colors.blue;
        text = AppLocalKay.preparing.tr();
        break;
      case UniformOrderStatus.ready:
        color = Colors.green;
        text = AppLocalKay.ready_for_pickup.tr();
        break;
      case UniformOrderStatus.delivered:
        color = Colors.grey;
        text = AppLocalKay.delivered.tr();
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildStatusDropdown(BuildContext context, UniformOrder order) {
    return DropdownButton<UniformOrderStatus>(
      value: order.status,
      underline: const SizedBox.shrink(),
      items: UniformOrderStatus.values.map((status) {
        return DropdownMenuItem(value: status, child: Text(_getStatusString(context, status)));
      }).toList(),
      onChanged: (newStatus) {
        if (newStatus != null) {
          context.read<UniformCubit>().updateOrderStatus(order.id, newStatus);
        }
      },
    );
  }

  String _getStatusString(BuildContext context, UniformOrderStatus status) {
    switch (status) {
      case UniformOrderStatus.pending:
        return 'Pending';
      case UniformOrderStatus.preparing:
        return AppLocalKay.preparing.tr();
      case UniformOrderStatus.ready:
        return AppLocalKay.ready_for_pickup.tr();
      case UniformOrderStatus.delivered:
        return AppLocalKay.delivered.tr();
    }
  }
}
