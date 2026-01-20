enum AssignmentStatus { pending, submitted, graded, late }

class AssignmentModel {
  final String id;
  final String title;
  final String subject;
  final String description;
  final DateTime dueDate;
  final AssignmentStatus status;
  final double? grade;

  AssignmentModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.dueDate,
    this.status = AssignmentStatus.pending,
    this.grade,
  });
}
