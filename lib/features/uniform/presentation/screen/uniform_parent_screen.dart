import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

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
                  const Gap(24),
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
            const Gap(8),
            Text(
              AppLocalKay.measurements_hint.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const Gap(16),
            _buildInputField(context, AppLocalKay.height.tr(), Icons.height),
            const Gap(12),
            _buildInputField(context, AppLocalKay.weight.tr(), Icons.monitor_weight),
            const Gap(12),
            _buildInputField(context, AppLocalKay.typical_size.tr(), Icons.format_size),
            const Gap(20),
            CustomButton(text: AppLocalKay.save.tr(), onPressed: () {}, radius: 12.r),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context, String label, IconData icon) {
    return CustomFormField(
      title: label,
      prefixIcon: Icon(icon),

      fillColor: Colors.grey[50],
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
        const Gap(12),
        if (orders.isEmpty)
          const Center(
            child: Padding(padding: EdgeInsets.all(20), child: Text("No orders found")),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (context, index) => const Gap(12),
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildOrderCard(context, order);
            },
          ),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, UniformOrder order) {
    final statusColor = _getStatusColor(order.status, context);
    final statusText = _getStatusText(context, order.status);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text('${AppLocalKay.order_status.tr()}: $statusText'),
        subtitle: Text(
          'ID: ${order.id} | ${order.orderDate.toString().split(' ')[0]}',
          style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey.shade600),
        ),
        leading: Icon(Icons.shopping_bag, color: statusColor),
        children: order.items.map((item) {
          return ListTile(
            title: Text(item.name),
            subtitle: Text(
              '${AppLocalKay.category.tr()}: ${item.category} | Size: ${item.size}',
              style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey.shade600),
            ),
            trailing: Text(
              '${item.price} SAR',
              style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getStatusColor(UniformOrderStatus status, BuildContext context) {
    switch (status) {
      case UniformOrderStatus.pending:
        return AppColor.accentColor(context);
      case UniformOrderStatus.preparing:
        return AppColor.infoColor(context);
      case UniformOrderStatus.ready:
        return AppColor.successColor(context);
      case UniformOrderStatus.delivered:
        return AppColor.grey400Color(context);
    }
  }

  String _getStatusText(BuildContext context, UniformOrderStatus status) {
    switch (status) {
      case UniformOrderStatus.pending:
        return AppLocalKay.todo_notification.tr();
      case UniformOrderStatus.preparing:
        return AppLocalKay.preparing.tr();
      case UniformOrderStatus.ready:
        return AppLocalKay.ready_for_pickup.tr();
      case UniformOrderStatus.delivered:
        return AppLocalKay.delivered.tr();
    }
  }
}
