enum UniformOrderStatus { pending, preparing, ready, delivered }

class StudentSize {
  final double height;
  final double weight;
  final String typicalSize; // e.g., "M", "L", "32"
  final Map<String, double>? detailedMeasurements; // e.g., {"shoulder": 40.0, "chest": 90.0}

  StudentSize({
    required this.height,
    required this.weight,
    required this.typicalSize,
    this.detailedMeasurements,
  });

  Map<String, dynamic> toJson() => {
    'height': height,
    'weight': weight,
    'typicalSize': typicalSize,
    'detailedMeasurements': detailedMeasurements,
  };

  factory StudentSize.fromJson(Map<String, dynamic> json) => StudentSize(
    height: json['height'],
    weight: json['weight'],
    typicalSize: json['typicalSize'],
    detailedMeasurements: (json['detailedMeasurements'] as Map?)?.cast<String, double>(),
  );
}

class UniformOrder {
  final String id;
  final String studentId;
  final String studentName;
  final String studentGrade;
  final List<UniformItem> items;
  final UniformOrderStatus status;
  final DateTime orderDate;
  final StudentSize sizeSnapshot;

  UniformOrder({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentGrade,
    required this.items,
    required this.status,
    required this.orderDate,
    required this.sizeSnapshot,
  });
}

class UniformItem {
  final String id;
  final String name;
  final String category; // e.g., "Shirt", "Pants", "Jacket"
  final String size;
  final double price;
  final String? imageUrl;

  UniformItem({
    required this.id,
    required this.name,
    required this.category,
    required this.size,
    required this.price,
    this.imageUrl,
  });
}

class SizeChart {
  final String category;
  final Map<String, Map<String, double>>
  measurementsBySize; // "M" -> {"shoulder": 42, "length": 70}

  SizeChart({required this.category, required this.measurementsBySize});
}
