import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/voice_recorder_widget.dart';
import 'home_screen.dart';
import 'issues_map_page.dart';

class ComplaintDetailsPage extends StatefulWidget {
  final String imagePath;
  final String location;

  const ComplaintDetailsPage({
    super.key,
    required this.imagePath,
    required this.location,
  });

  @override
  State<ComplaintDetailsPage> createState() => _ComplaintDetailsPageState();
}

class _ComplaintDetailsPageState extends State<ComplaintDetailsPage> {
  bool _remainAnonymous = false;
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _aiClassifiedTags = [
    'Roads',
    'Water',
    'Electricity',
    'Waste Management',
    'Public Transport',
    'Safety',
    'Environment',
    'Infrastructure',
  ];
  String _selectedTag = 'Roads';
  bool _isSubmitting = false;
  int _currentIndex = 2; // Camera tab is index 2
  String? _voiceRecordingPath;

  @override
  void initState() {
    super.initState();
    // Simulate AI classification - select a random tag
    _selectedTag = _aiClassifiedTags[0];
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.successGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your complaint has been recorded.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitComplaint() async {
    if (_descriptionController.text.trim().isEmpty &&
        _voiceRecordingPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please add a text description or record a voice message for your complaint.',
          ),
          backgroundColor: AppColors.warningOrange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
    });

    _showSuccessDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // Modern gradient header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 48,
              left: 16,
              right: 24,
              bottom: 24,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.darkGreen, AppColors.primaryGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Back',
                ),
                const SizedBox(width: 4),
                const Text(
                  'Report Issue',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo preview
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.file(
                        File(widget.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Location info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.primaryGreen,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.ecoText,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Remain Anonymous section
                  Row(
                    children: [
                      Checkbox(
                        value: _remainAnonymous,
                        onChanged: (val) {
                          setState(() {
                            _remainAnonymous = val ?? false;
                          });
                        },
                      ),
                      const Text(
                        'Remain Anonymous',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // AI Classified Tag Section
                  const Text(
                    'AI Classified Tag',
                    style: AppStyles.sectionTitle,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: AppStyles.cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Category',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryText,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showTagSelectionDialog();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Change',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightGreen,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedTag,
                            style: const TextStyle(
                              color: AppColors.ecoText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Description Section
                  const Text('Description', style: AppStyles.sectionTitle),
                  const SizedBox(height: 12),
                  Container(
                    decoration: AppStyles.cardDecoration,
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Describe the issue in detail...',
                        hintStyle: const TextStyle(
                          color: AppColors.lightText,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // OR divider
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColors.lightText.withOpacity(0.3),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: AppColors.lightText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColors.lightText.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Voice recording
                  VoiceRecorderWidget(
                    onVoiceRecorded: (path) {
                      setState(() {
                        _voiceRecordingPath = path;
                      });
                    },
                    onVoiceCleared: () {
                      setState(() {
                        _voiceRecordingPath = null;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitComplaint,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        shadowColor: AppColors.primaryGreen.withOpacity(0.15),
                      ),
                      child: _isSubmitting
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Submitting...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : const Text(
                              'Submit Complaint',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        transientIndices: const {1},
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => const IssuesMapPage()),
            );
            return;
          }
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          }
        },
      ),
    );
  }

  void _showTagSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Select Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _aiClassifiedTags.length,
              itemBuilder: (context, index) {
                final tag = _aiClassifiedTags[index];
                return ListTile(
                  title: Text(tag),
                  selected: tag == _selectedTag,
                  selectedTileColor: AppColors.lightGreen,
                  onTap: () {
                    setState(() {
                      _selectedTag = tag;
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
