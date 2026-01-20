import '../model/uniform_model.dart';

class UniformRepo {
  final List<UniformOrder> _dummyOrders = [
    UniformOrder(
      id: 'ORD-001',
      studentId: 'ST-101',
      studentName: 'أحمد محمد',
      studentGrade: 'الصف العاشر',
      items: [
        UniformItem(id: 'ITEM-1', name: 'قميص أبيض', category: 'Shirt', size: 'M', price: 45.0),
        UniformItem(id: 'ITEM-2', name: 'بنطلون كحلي', category: 'Pants', size: '32', price: 60.0),
      ],
      status: UniformOrderStatus.preparing,
      orderDate: DateTime.now().subtract(const Duration(days: 2)),
      sizeSnapshot: StudentSize(height: 165, weight: 60, typicalSize: 'M'),
    ),
    UniformOrder(
      id: 'ORD-002',
      studentId: 'ST-102',
      studentName: 'ليلى علي',
      studentGrade: 'الصف الرابع',
      items: [
        UniformItem(id: 'ITEM-3', name: 'فستان مدرسي', category: 'Dress', size: 'S', price: 80.0),
      ],
      status: UniformOrderStatus.pending,
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      sizeSnapshot: StudentSize(height: 130, weight: 35, typicalSize: 'S'),
    ),
  ];

  final List<SizeChart> _dummySizeCharts = [
    SizeChart(
      category: 'Shirt',
      measurementsBySize: {
        'S': {'Shoulder': 38, 'Chest': 86, 'Length': 65},
        'M': {'Shoulder': 42, 'Chest': 94, 'Length': 70},
        'L': {'Shoulder': 46, 'Chest': 102, 'Length': 75},
      },
    ),
    SizeChart(
      category: 'Pants',
      measurementsBySize: {
        '30': {'Waist': 76, 'Length': 100},
        '32': {'Waist': 81, 'Length': 102},
        '34': {'Waist': 86, 'Length': 104},
      },
    ),
  ];

  Future<List<UniformOrder>> getStudentOrders(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _dummyOrders.where((o) => o.studentId == studentId).toList();
  }

  Future<List<UniformOrder>> getAllOrders() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _dummyOrders;
  }

  Future<void> updateOrderStatus(String orderId, UniformOrderStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _dummyOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final oldOrder = _dummyOrders[index];
      _dummyOrders[index] = UniformOrder(
        id: oldOrder.id,
        studentId: oldOrder.studentId,
        studentName: oldOrder.studentName,
        studentGrade: oldOrder.studentGrade,
        items: oldOrder.items,
        status: newStatus,
        orderDate: oldOrder.orderDate,
        sizeSnapshot: oldOrder.sizeSnapshot,
      );
    }
  }

  Future<void> placeOrder(UniformOrder order) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _dummyOrders.add(order);
  }

  Future<List<SizeChart>> getSizeCharts() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _dummySizeCharts;
  }
}
