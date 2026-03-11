import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget? child;
  final double blur;
  final double opacity;
  final List<double>? borderRadius; 
  final double borderWidth;
  final Color borderColor;

  const GlassContainer({
    super.key,
    this.child,
    this.blur = 10,
    required this.borderRadius, 
    this.opacity = 0.2,
    this.borderWidth = 1.5, 
    this.borderColor = Colors.white24,
  });


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius![0]),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(borderRadius![0]), 
              bottomRight: Radius.circular(borderRadius![1]), 
              topLeft: Radius.circular(borderRadius![2]), 
              topRight: Radius.circular(borderRadius![3]), 
            ),
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
