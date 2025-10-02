import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ReportDetailScreen extends StatelessWidget {
  final String department;
  final int received;
  final int resolved;
  final int inProgress;
  final int pending;

  const ReportDetailScreen({
    super.key,
    required this.department,
    required this.received,
    required this.resolved,
    required this.inProgress,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$department Report'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total complaints received',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              '$received',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            _statRow('Resolved', resolved, Colors.green),
            const SizedBox(height: 8),
            _statRow('In Progress', inProgress, Colors.orange),
            const SizedBox(height: 8),
            _statRow('Pending', pending, Colors.red),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            // Pie chart visualization
            Center(
              child: SizedBox(
                width: 180,
                height: 180,
                child: PieChart(
                  values: [
                    resolved.toDouble(),
                    inProgress.toDouble(),
                    pending.toDouble(),
                  ],
                  colors: const [Colors.green, Colors.orange, Colors.red],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('Details', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'This section can include charts, timelines, or links to complaint lists.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _statRow(String label, int value, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
        Text('$value', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class PieChart extends StatelessWidget {
  final List<double> values;
  final List<Color> colors;

  const PieChart({super.key, required this.values, required this.colors});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PiePainter(values: values, colors: colors),
      child: const SizedBox.expand(),
    );
  }
}

class _PiePainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  _PiePainter({required this.values, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold(0.0, (a, b) => a + b);
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = min(size.width, size.height) / 2;

    double startRads = -pi / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < values.length; i++) {
      final sweepRads = (values[i] / (total == 0 ? 1 : total)) * 2 * pi;
      paint.color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startRads,
        sweepRads,
        true,
        paint,
      );
      startRads += sweepRads;
    }

    // Draw inner circle to create donut
    final holePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.55, holePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
