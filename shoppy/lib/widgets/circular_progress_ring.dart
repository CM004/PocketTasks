import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularProgressRing extends StatelessWidget {
  final int completed;
  final int total;
  final double size;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  const CircularProgressRing({
    super.key,
    required this.completed,
    required this.total,
    this.size = 60.0,
    this.progressColor = Colors.green,
    this.backgroundColor = Colors.grey,
    this.strokeWidth = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CircularProgressPainter(
          progress: total > 0 ? completed / total : 0.0,
          progressColor: progressColor,
          backgroundColor: backgroundColor,
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: Text(
            '$completed/$total',
            style: const TextStyle(
              color: const Color(0xFF6750A4),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final rect = Rect.fromCircle(center: center, radius: radius);
      final startAngle = -math.pi / 2; // Start from top
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
} 