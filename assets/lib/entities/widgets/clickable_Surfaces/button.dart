import 'package:fbla_connect/entities/color_pallete.dart';
import 'package:fbla_connect/entities/responsive/section_alignment.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onClickContinue,
    this.width = double.infinity, 
    required this.onPressed, 
    this.text = 'Continue →', 
  });

  final WidgetStatesController onClickContinue;
  final double width;  
  final VoidCallback onPressed; 
  final String text; 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: Platform.isMacOS || Platform.isWindows || Platform.isLinux? 40: 52, 
      child: MouseRegion( 
        cursor: SystemMouseCursors.click,
        onEnter: (_) => onClickContinue.update(WidgetState.hovered, true), 
        onExit: (_) => onClickContinue.update(WidgetState.hovered, false),
        child: ValueListenableBuilder<Set<WidgetState>>(
          valueListenable: onClickContinue,
          builder: (context, states, _) {
            final isHovered = states.contains(WidgetState.hovered);
            return FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  isHovered ? tertiaryColor : Colors.transparent, 
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(300),
                    side: const BorderSide(
                      color: uniqueTertiaryColor,
                      width: 1.5,
                    ),
                  ),
                ),
                elevation: WidgetStateProperty.all(0),
                surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              onPressed: onPressed,
              child: Text( 
                text, 
                style: TextStyle(
                  color: uniqueTertiaryColor, 
                  fontWeight: FontWeight.w600,  
                  fontSize: adaptiveNumberSizing(18), 
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
