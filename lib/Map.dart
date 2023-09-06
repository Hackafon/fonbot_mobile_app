
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;

class MiniMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: CustomPaint(
        painter: MiniMapPainter(), // Use a CustomPainter to draw the content
      ),
    );
  }
}



class MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawCircle(center, radius, paint);

    // Draw distance indicators
    final startPoint = vector.Vector2(center.dx , center.dy - radius);
    final endPoint = vector.Vector2(center.dx , center.dy - radius - 15);



    for (double i = 0; i < 4; i++) {
      final indicatorRotation = vector.Matrix2.rotation(
        vector.radians(90 * i + 45),
      );

      final rotatedEndPoint = startPoint +
          indicatorRotation.transform(
            endPoint - startPoint,
          );

      canvas.drawLine(
        Offset(startPoint.x, startPoint.y),
        Offset(rotatedEndPoint.x, rotatedEndPoint.y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}