import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';

class ParentClassScreen extends StatefulWidget {
  const ParentClassScreen({super.key});

  @override
  State<ParentClassScreen> createState() => _ParentClassScreenState();
}

class _ParentClassScreenState extends State<ParentClassScreen> {
  int selectedIndex = 0;

  final children = [
    {"name": "أحمد محمد", "grade": "الصف العاشر"},
    {"name": "سارة محمد", "grade": "الصف الثامن"},
    {"name": "فاطمة محمد", "grade": "الصف السادس"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("الفصول", style: TextStyle(fontWeight: FontWeight.bold)),
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
              backgroundColor: Colors.purple[100],
              child: Icon(Icons.person, size: 40, color: Colors.purple[700]),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'أ. محمد أحمد',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('ولي أمر الطالب', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '+966 50 123 4567',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {},
              icon: Icon(Icons.message, color: Colors.purple[700]),
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
        const Text(
          "اختر الابن / الابنة",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                child: _childChip(name: c["name"]!, grade: c["grade"]!, isSelected: selected),
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
        color: isSelected ? Colors.purple[50] : AppColor.whiteColor(context),
        border: Border.all(color: isSelected ? Colors.purple : Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.purple[100],
            child: Icon(Icons.person, color: Colors.purple[700]),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: isSelected ? Colors.purple[700] : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(grade, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
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
        Expanded(child: _statCard("الحضور", "95%", Icons.check, Colors.green, "هذا الشهر")),
        const SizedBox(width: 10),
        Expanded(child: _statCard("الدرجات", "88%", Icons.grade, Colors.blue, "المعدل العام")),
        const SizedBox(width: 10),
        Expanded(child: _statCard("الواجبات", "3", Icons.assignment, Colors.orange, "معلقة")),
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
              style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 10)),
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
              indicator: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(8),
              ),
              tabs: const [
                Tab(text: "الجدول"),
                Tab(text: "الدرجات"),
                Tab(text: "الحضور"),
                Tab(text: "الواجبات"),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Expanded(
            child: TabBarView(
              children: [
                Center(child: Text("📆 شاشة الجدول")),
                Center(child: Text("📊 شاشة الدرجات")),
                Center(child: Text("📁 شاشة الحضور")),
                Center(child: Text("📝 شاشة الواجبات")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
