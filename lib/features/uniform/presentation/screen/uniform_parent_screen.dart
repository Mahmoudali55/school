import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';

import '../../../../core/utils/app_local_kay.dart';
import '../../data/model/uniform_model.dart';
import '../cubit/uniform_cubit.dart';

class UniformParentScreen extends StatelessWidget {
  const UniformParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(AppLocalKay.school_uniform.tr()),
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
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSizeInputSection(context),
                  const SizedBox(height: 24),
                  _buildOrderHistorySection(context, state.orders),
                ],
              ),
            );
          } else if (state is UniformError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSizeInputSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.straighten, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  AppLocalKay.student_sizes.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalKay.measurements_hint.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildInputField(context, AppLocalKay.height.tr(), Icons.height),
            const SizedBox(height: 12),
            _buildInputField(context, AppLocalKay.weight.tr(), Icons.monitor_weight),
            const SizedBox(height: 12),
            _buildInputField(context, AppLocalKay.typical_size.tr(), Icons.format_size),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(AppLocalKay.size_saved_success.tr())));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(AppLocalKay.update_sizes.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context, String label, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: label.contains('Size') ? TextInputType.text : TextInputType.number,
    );
  }

  Widget _buildOrderHistorySection(BuildContext context, List<UniformOrder> orders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.uniform_orders.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (orders.isEmpty)
          const Center(
            child: Padding(padding: EdgeInsets.all(20), child: Text("No orders found")),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildOrderCard(context, order);
            },
          ),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, UniformOrder order) {
    final statusColor = _getStatusColor(order.status);
    final statusText = _getStatusText(context, order.status);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text('${AppLocalKay.order_status.tr()}: $statusText'),
        subtitle: Text('ID: ${order.id} | ${order.orderDate.toString().split(' ')[0]}'),
        leading: Icon(Icons.shopping_bag, color: statusColor),
        children: order.items.map((item) {
          return ListTile(
            title: Text(item.name),
            subtitle: Text('${AppLocalKay.category.tr()}: ${item.category} | Size: ${item.size}'),
            trailing: Text(
              '${item.price} SAR',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getStatusColor(UniformOrderStatus status) {
    switch (status) {
      case UniformOrderStatus.pending:
        return Colors.orange;
      case UniformOrderStatus.preparing:
        return Colors.blue;
      case UniformOrderStatus.ready:
        return Colors.green;
      case UniformOrderStatus.delivered:
        return Colors.grey;
    }
  }

  String _getStatusText(BuildContext context, UniformOrderStatus status) {
    switch (status) {
      case UniformOrderStatus.pending:
        return AppLocalKay.todo_notification.tr(); // Fallback or add new key
      case UniformOrderStatus.preparing:
        return AppLocalKay.preparing.tr();
      case UniformOrderStatus.ready:
        return AppLocalKay.ready_for_pickup.tr();
      case UniformOrderStatus.delivered:
        return AppLocalKay.delivered.tr();
    }
  }
}
