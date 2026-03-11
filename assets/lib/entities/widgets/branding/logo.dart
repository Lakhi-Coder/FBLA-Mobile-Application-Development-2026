import 'package:fbla_connect/entities/responsive/section_alignment.dart';
import 'package:flutter/material.dart';


class CustomLogo extends StatelessWidget {
  const CustomLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset( 
      'images/brand_icons/FBLA_Logo_Horizontal_color-HiRes.png', 
      height: adaptiveNumberSizing(52), 
    );
  }
}