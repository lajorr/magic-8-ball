import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:magic_8_ball/components/prediction.dart';
import 'package:magic_8_ball/components/shadow_of_doubt.dart';
import 'package:magic_8_ball/components/sphere_of_destiny.dart';
import 'package:magic_8_ball/components/window_of_opportunity.dart';


class Magic8Ball extends StatefulWidget {
  const Magic8Ball({super.key});

  @override
  State<Magic8Ball> createState() => _Magic8BallState();
}

class _Magic8BallState extends State<Magic8Ball>
    with SingleTickerProviderStateMixin {
  static const lightSource = Offset(0, -0.75);
  static const restPosition = Offset(0, -0.15);
  double wobble = 0.0;
  String prediction = 'The MAGIC\n8-Ball';
  Offset tapPosition = Offset.zero;

  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 1500),
    );
    controller.addListener(() => setState(() {}));

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.elasticIn,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _start(Offset offset, Size size) {
    controller.forward(from: 0);
    update(offset, size);
  }

  void update(Offset position, Size size) {
    Offset tapPosition = Offset(
      (2 * position.dx / size.width) - 1,
      (2 * position.dy / size.height) - 1,
    );
    if (tapPosition.distance > 0.85) {
      tapPosition = Offset.fromDirection(tapPosition.direction, 0.8);
    }
    setState(() => this.tapPosition = tapPosition);
  }

  void _end() {
    final rand = math.Random();
    wobble = rand.nextDouble() * (wobble.isNegative ? 0.5 : -0.5);
    prediction = predictions[rand.nextInt(predictions.length)];
    controller.reverse(from: 1);
  }

  @override
  Widget build(BuildContext context) {
    final size = Size.square(MediaQuery.of(context).size.shortestSide);
    final windowPosition = Offset.lerp(
      restPosition,
      tapPosition,
      animation.value,
    )!;
    return Stack(
      children: [
        ShadowOfDoubt(diameter: size.shortestSide),
        GestureDetector(
          onPanStart: (details) => _start(details.localPosition, size),
          onPanUpdate: (details) => update(details.localPosition, size),
          onPanEnd: (_) => _end(),
          child: SphereOfDestiny(
            lightSource: lightSource,
            diameter: size.shortestSide,
            child: Transform(
              origin: size.center(Offset.zero),
              transform: Matrix4.identity()
                ..translate(
                  windowPosition.dx * size.width / 2,
                  windowPosition.dy * size.height / 2,
                )
                ..rotateZ(windowPosition.direction)
                ..rotateY(windowPosition.distance * math.pi / 2)
                ..rotateZ(-windowPosition.direction)
                ..scale(0.5 - 0.15 * windowPosition.distance),
              child: WindowOfOpportunity(
                lightSource: lightSource - windowPosition,
                child: Opacity(
                  opacity: 1 - controller.value,
                  child: Transform.rotate(
                    angle: wobble,
                    child: Prediction(text: prediction),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
