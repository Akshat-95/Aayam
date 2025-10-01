class DummyDataService {
  // Returns a list of dummy active complaints with id, title, description, lat, lon, category
  static List<Map<String, dynamic>> getActiveComplaints() {
    return [
      {
        'id': 'c1',
        'title': 'Pothole on Main St',
        'description':
            'Large pothole near the market causing traffic disruptions.',
        'lat': 28.704060,
        'lon': 77.102493,
        'category': 'Roads',
        'timeAgo': '2 days ago',
      },
      {
        'id': 'c2',
        'title': 'Overflowing drain',
        'description': 'Drain overflowing near park causing bad smell.',
        'lat': 28.705000,
        'lon': 77.104000,
        'category': 'Waste Management',
        'timeAgo': '5 hours ago',
      },
      {
        'id': 'c3',
        'title': 'Broken streetlight',
        'description': 'Streetlight not working on Elm Road.',
        'lat': 28.703000,
        'lon': 77.100000,
        'category': 'Electricity',
        'timeAgo': '1 week ago',
      },
    ];
  }
}
