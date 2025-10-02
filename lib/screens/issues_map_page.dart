import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../services/dummy_data_service.dart';
import '../constants/app_colors.dart';

class IssuesMapPage extends StatefulWidget {
  const IssuesMapPage({super.key, this.centerOnUser = false});

  final bool centerOnUser;

  @override
  State<IssuesMapPage> createState() => _IssuesMapPageState();
}

class _IssuesMapPageState extends State<IssuesMapPage> {
  final List<Map<String, dynamic>> _complaints =
      DummyDataService.getActiveComplaints();
  Map<String, dynamic>? _selectedComplaint;
  final MapController _mapController = MapController();
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Permissions are denied, don't try to fetch location
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _userLocation = LatLng(pos.latitude, pos.longitude);
      });

      // If the caller requested centering on user, move the map once we have the location
      if (widget.centerOnUser && _userLocation != null) {
        // Delay slightly to ensure map has been built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            _mapController.move(_userLocation!, 16);
          } catch (_) {
            // Ignore map controller errors during tests or early lifecycle
          }
        });
      }
    } catch (e) {
      // Ignore errors for now; user can still use the app
    }
  }

  IconData _iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'roads':
        return Icons.construction; // pothole / roads
      case 'waste management':
        return Icons.delete; // trash/drain
      case 'electricity':
        return Icons.lightbulb; // streetlight
      case 'water':
        return Icons.water; // water issues
      case 'safety':
        return Icons.warning; // safety
      default:
        return Icons.location_on;
    }
  }

  Color _colorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'roads':
        return Colors.deepOrange;
      case 'waste management':
        return Colors.brown;
      case 'electricity':
        return Colors.amber.shade700;
      case 'water':
        return Colors.blue;
      case 'safety':
        return Colors.redAccent;
      default:
        return AppColors.notificationBadge;
    }
  }

  @override
  Widget build(BuildContext context) {
    final center = LatLng(_complaints[0]['lat'], _complaints[0]['lon']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Issues Map'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: center,
              zoom: 15,
              onTap: (_, __) => setState(() => _selectedComplaint = null),
            ),
            // Attribution: keep a lightweight attribution overlay instead of
            // using the package-specific AttributionWidget to avoid API mismatches.
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.citizen_issue_app',
              ),
              MarkerLayer(
                markers: _complaints.map((c) {
                  final lat = c['lat'] as double;
                  final lon = c['lon'] as double;
                  final category = (c['category'] ?? '') as String;
                  final iconData = _iconForCategory(category);
                  final bgColor = _colorForCategory(category);

                  return Marker(
                    point: LatLng(lat, lon),
                    width: 56,
                    height: 56,
                    builder: (ctx) => GestureDetector(
                      onTap: () => setState(() => _selectedComplaint = c),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(iconData, color: Colors.white, size: 24),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              // User location marker (if available)
              if (_userLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _userLocation!,
                      width: 40,
                      height: 40,
                      builder: (ctx) => Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Lightweight on-top attribution
          Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '© OpenStreetMap contributors',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),

          if (_selectedComplaint != null)
            _buildBottomCard(context, _selectedComplaint!),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_userLocation == null) {
            await _determinePosition();
            if (_userLocation == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Unable to get location')),
              );
              return;
            }
          }
          _mapController.move(_userLocation!, 16);
        },
        label: const Text('Locate me'),
        icon: const Icon(Icons.my_location),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  Widget _buildBottomCard(
    BuildContext context,
    Map<String, dynamic> complaint,
  ) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 24,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    complaint['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    complaint['timeAgo'],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                complaint['description'],
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      complaint['category'],
                      style: const TextStyle(color: AppColors.ecoText),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                    ),
                    onPressed: () {
                      // Placeholder for navigation to complaint details
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Open complaint details (not implemented)',
                          ),
                        ),
                      );
                    },
                    child: const Text('View'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
