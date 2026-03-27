// lib/features/home/widgets/flip_card.dart

import 'dart:math';
import 'package:flutter/material.dart';

class FlipCard extends StatelessWidget {
  final Widget front;
  final Widget back;
  final bool isFlipped;
  final VoidCallback onTap;

  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: isFlipped ? pi : 0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          final isBack = value > (pi / 2);
          
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateY(value),
            alignment: Alignment.center,
            child: isBack
                ? Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: back,
                  )
                : front,
          );
        },
      ),
    );
  }
}
