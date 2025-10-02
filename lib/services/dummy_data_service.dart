import '../models/complaint.dart';

class DummyDataService {
  static List<Complaint> getComplaints() {
    final now = DateTime.now();

    return [
      Complaint(
        id: '1',
        title: 'Pothole on Main Street',
        description: 'Large pothole causing vehicle damage near the bus stop.',
        category: 'Roads',
        location: 'Main Street, Bus Stop',
        dateSubmitted: now.subtract(const Duration(days: 6, hours: 3)),
        status: ComplaintStatus.pending,
        imageUrl:
            'https://images.unsplash.com/photo-1509395176047-4a66953fd231?w=1200',
        latitude: 28.7041,
        longitude: 77.1025,
      ),
      Complaint(
        id: '2',
        title: 'Broken Streetlight',
        description: 'Streetlight not working for several nights.',
        category: 'Street Lighting',
        location: 'Elm Street, Near Park',
        dateSubmitted: now.subtract(const Duration(days: 4, hours: 5)),
        status: ComplaintStatus.inProgress,
        imageUrl:
            'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200',
        latitude: 28.7050,
        longitude: 77.1040,
      ),
      Complaint(
        id: '3',
        title: 'Garbage Not Collected',
        description: 'Garbage pile-up outside the market for a week.',
        category: 'Sanitation',
        location: 'Market Road',
        dateSubmitted: now.subtract(const Duration(days: 3, hours: 1)),
        status: ComplaintStatus.workerAssigned,
        imageUrl:
            'https://images.unsplash.com/photo-1581579182429-2c6cf2b3b5a1?w=1200',
        latitude: 28.7060,
        longitude: 77.1035,
      ),
      Complaint(
        id: '4',
        title: 'Water Leakage',
        description: 'Continuous water leakage near the main pipeline.',
        category: 'Water Supply',
        location: 'Sunrise Colony',
        dateSubmitted: now.subtract(const Duration(days: 2, hours: 2)),
        status: ComplaintStatus.inProgress,
        imageUrl:
            'https://images.unsplash.com/photo-1565228392251-8a3f2f67f1b2?w=1200',
        latitude: 28.7070,
        longitude: 77.1050,
      ),
      Complaint(
        id: '5',
        title: 'Illegal Dumping',
        description: 'Someone dumping construction waste behind the mall.',
        category: 'Environment',
        location: 'Behind City Mall',
        dateSubmitted: now.subtract(const Duration(days: 1, hours: 7)),
        status: ComplaintStatus.pending,
        imageUrl:
            'https://images.unsplash.com/photo-1600180758890-86d0f1346f9e?w=1200',
        latitude: 28.7080,
        longitude: 77.1060,
      ),
      Complaint(
        id: '6',
        title: 'Fallen Tree',
        description: 'Tree fallen after storm blocking the lane.',
        category: 'Public Safety',
        location: 'Ring Road, Near Metro Station',
        dateSubmitted: now.subtract(const Duration(hours: 20)),
        status: ComplaintStatus.resolved,
        imageUrl:
            'https://images.unsplash.com/photo-1503264116251-35a269479413?w=1200',
        latitude: 28.7090,
        longitude: 77.1070,
      ),
      Complaint(
        id: '7',
        title: 'Noisy Construction',
        description: 'Construction work starting well before morning.',
        category: 'Noise',
        location: 'Green Avenue',
        dateSubmitted: now.subtract(const Duration(hours: 12)),
        status: ComplaintStatus.workerAssigned,
        imageUrl:
            'https://images.unsplash.com/photo-1516455207990-7a41ce80f7ee?w=1200',
        latitude: 28.7100,
        longitude: 77.1080,
      ),
      Complaint(
        id: '8',
        title: 'Blocked Drain',
        description: 'Drain blocked causing water logging after rains.',
        category: 'Sanitation',
        location: 'Maple Street',
        dateSubmitted: now.subtract(const Duration(hours: 6)),
        status: ComplaintStatus.inProgress,
        imageUrl:
            'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?w=1200',
        latitude: 28.7110,
        longitude: 77.1090,
      ),
      Complaint(
        id: '9',
        title: 'Traffic Signal Faulty',
        description: 'Traffic signal not changing at intersection.',
        category: 'Traffic',
        location: 'Crossroads',
        dateSubmitted: now.subtract(const Duration(hours: 2)),
        status: ComplaintStatus.pending,
        imageUrl:
            'https://images.unsplash.com/photo-1521791136064-7986c2920216?w=1200',
        latitude: 28.7120,
        longitude: 77.1100,
      ),
    ];
  }

  // Compatibility: return a list of maps for older callers (used by map page)
  static List<Map<String, dynamic>> getActiveComplaints() {
    return getComplaints().map((c) {
      return {
        'id': c.id,
        'title': c.title,
        'description': c.description,
        'lat': c.latitude,
        'lon': c.longitude,
        'category': c.category,
        'status': Complaint.statusToString(c.status),
        'timeAgo':
            '${DateTime.now().difference(c.dateSubmitted).inHours} hours ago',
      };
    }).toList();
  }
}
