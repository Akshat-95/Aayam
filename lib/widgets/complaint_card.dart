import 'package:flutter/material.dart';
import '../models/complaint.dart';
import '../constants/app_colors.dart';

class ComplaintCard extends StatelessWidget {
  final Complaint complaint;
  final VoidCallback? onTap;

  const ComplaintCard({super.key, required this.complaint, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              complaint.imageUrl,
              width: 96,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 96,
                height: 64,
                color: AppColors.lightGreen,
                child: const Icon(
                  Icons.error_outline,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ),
          title: Text(
            complaint.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                complaint.category,
                style: const TextStyle(color: AppColors.secondaryText),
              ),
              const SizedBox(height: 6),
              Text(
                _formatDate(complaint.dateSubmitted),
                style: const TextStyle(color: AppColors.secondaryText),
              ),
            ],
          ),
          trailing: _statusBadge(complaint.status),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) {
      if (diff.inHours == 0) return '${diff.inMinutes}m ago';
      return '${diff.inHours}h ago';
    }
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color fg = Colors.white;
    switch (status.toLowerCase()) {
      case 'pending':
        bg = Colors.orange;
        break;
      case 'in progress':
        bg = Colors.blue;
        break;
      case 'worker assigned':
        bg = Colors.purple;
        break;
      case 'resolved':
      case 'completed':
        bg = Colors.green;
        break;
      default:
        bg = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: TextStyle(color: fg, fontSize: 12)),
    );
  }
}
