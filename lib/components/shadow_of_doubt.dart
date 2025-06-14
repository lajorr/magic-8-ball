import 'dart:math' as math;

import 'package:flutter/material.dart';

class ShadowOfDoubt extends StatelessWidget {
  const ShadowOfDoubt({super.key, required this.diameter});

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()..rotateX(math.pi / 2.1),
      origin: Offset(0, diameter),
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(blurRadius: 25, color: Colors.grey.withAlpha(153)),
          ],

          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
