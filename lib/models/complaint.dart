enum ComplaintStatus { pending, workerAssigned, inProgress, resolved, closed }

class Complaint {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final DateTime dateSubmitted;
  final ComplaintStatus status;
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

  // Helpers to interoperate with older string-based code
  static ComplaintStatus statusFromString(String s) {
    final lower = s.toLowerCase();
    if (lower == 'pending') return ComplaintStatus.pending;
    if (lower == 'worker assigned' ||
        lower == 'workerassigned' ||
        lower == 'worker_assigned')
      return ComplaintStatus.workerAssigned;
    if (lower == 'in progress' || lower == 'inprogress')
      return ComplaintStatus.inProgress;
    if (lower == 'resolved' || lower == 'completed')
      return ComplaintStatus.resolved;
    if (lower == 'closed') return ComplaintStatus.closed;
    return ComplaintStatus.pending;
  }

  static String statusToString(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.pending:
        return 'Pending';
      case ComplaintStatus.workerAssigned:
        return 'Worker Assigned';
      case ComplaintStatus.inProgress:
        return 'In Progress';
      case ComplaintStatus.resolved:
        return 'Resolved';
      case ComplaintStatus.closed:
        return 'Closed';
    }
  }
}
