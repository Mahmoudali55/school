import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class ParentClassScreen extends StatefulWidget {
  const ParentClassScreen({super.key});

  @override
  State<ParentClassScreen> createState() => _ParentClassScreenState();
}

class _ParentClassScreenState extends State<ParentClassScreen> {
  int selectedIndex = 0;

  final children = [
    {'name'.tr(): 'أحمد محمد'.tr(), 'grade'.tr(): 'الصف العاشر'.tr()},
    {'name'.tr(): 'سارة محمد'.tr(), 'grade'.tr(): 'الصف الثامن'.tr()},
    {'name'.tr(): 'فاطمة محمد'.tr(), 'grade'.tr(): 'الصف السادس'.tr()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          AppLocalKay.classes.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: AppColor.whiteColor(context),
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildParentInfoCard(),

              const SizedBox(height: 16),

              _buildChildrenSelection(),

              const SizedBox(height: 16),

              _buildQuickStats(),

              const SizedBox(height: 16),

              Expanded(child: _buildTabsSection()),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------ Parent Info Card ------------------
  Widget _buildParentInfoCard() {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.person, size: 40, color: Colors.blue[700]),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أ. محمد أحمد'.tr(),
                    style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ولي أمر الطالب'.tr(),
                    style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '+966 50 123 4567'.tr(),
                        style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {},
              icon: Icon(Icons.message, color: Colors.blue[700]),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ Children Chips ------------------
  Widget _buildChildrenSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.select_child.tr(),
          style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: children.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) {
              final c = children[index];
              final selected = selectedIndex == index;
              return GestureDetector(
                onTap: () => setState(() => selectedIndex = index),
                child: _childChip(
                  name: c['name'.tr()]!,
                  grade: c['grade'.tr()]!,
                  isSelected: selected,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _childChip({required String name, required String grade, required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? Colors.blue[50] : AppColor.whiteColor(context),
        border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Icon(Icons.person, color: Colors.blue[700]),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.bodySmall(context).copyWith(
                    color: isSelected ? Colors.blue[700] : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  grade,
                  style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ Quick Stats ------------------
  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            AppLocalKay.checkin.tr(),
            '95%'.tr(),
            Icons.check,
            AppColor.secondAppColor(context),
            AppLocalKay.this_month.tr(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            AppLocalKay.grades.tr(),
            '88%'.tr(),
            Icons.grade,
            AppColor.primaryColor(context),
            AppLocalKay.gpas.tr(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            AppLocalKay.todostitle.tr(),
            '3'.tr(),
            Icons.assignment,
            AppColor.accentColor(context),
            AppLocalKay.pending.tr(),
          ),
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color, String sub) {
    return Card(
      elevation: 1.3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTextStyle.titleMedium(
                context,
              ).copyWith(color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey)),
            Text(
              sub,
              style: AppTextStyle.bodySmall(context).copyWith(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ Tabs ------------------
  Widget _buildTabsSection() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              labelColor: AppColor.whiteColor(context),
              unselectedLabelColor: Colors.black54,
              indicator: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
              tabs: [
                Tab(text: AppLocalKay.scheduls.tr()),
                Tab(text: AppLocalKay.grades.tr()),
                Tab(text: AppLocalKay.checkin.tr()),
                Tab(text: AppLocalKay.todostitle.tr()),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              children: [
                Center(child: Text('📆 شاشة الجدول'.tr())),
                Center(child: Text('📊 شاشة الدرجات'.tr())),
                Center(child: Text('📁 شاشة الحضور'.tr())),
                Center(child: Text('📝 شاشة الواجبات'.tr())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
