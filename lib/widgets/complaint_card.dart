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
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.surfaceColor, AppColors.lightGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkGreen.withOpacity(0.10),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  complaint.imageUrl,
                  width: 80,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 60,
                    color: AppColors.lightGreen,
                    child: const Icon(
                      Icons.error_outline,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            complaint.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.primaryText,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _statusBadge(complaint.status),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      complaint.category,
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(complaint.dateSubmitted),
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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

  Widget _statusBadge(ComplaintStatus status) {
    Color bg;
    final fg = Colors.white;
    switch (status) {
      case ComplaintStatus.pending:
        bg = Colors.orange;
        break;
      case ComplaintStatus.inProgress:
        bg = Colors.blue;
        break;
      case ComplaintStatus.workerAssigned:
        bg = Colors.purple;
        break;
      case ComplaintStatus.resolved:
      case ComplaintStatus.closed:
        bg = Colors.green;
        break;
    }
    final label = Complaint.statusToString(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(color: fg, fontSize: 12)),
    );
  }
}
