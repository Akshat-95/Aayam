class Complaint {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final DateTime dateSubmitted;
  final String
  status; // Pending, In Progress, Resolved, Closed, Worker Assigned
  final String imageUrl;
  final double latitude;
  final double longitude;
  final List<String> attachments;
  final String assignedWorkerId;

  Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.dateSubmitted,
    required this.status,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    this.attachments = const [],
    this.assignedWorkerId = '',
  });
}
