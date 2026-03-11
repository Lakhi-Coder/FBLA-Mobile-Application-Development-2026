import 'package:fbla_connect/entities/color_pallete.dart';
import 'package:fbla_connect/entities/responsive/media_query.dart';
import 'package:fbla_connect/entities/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key, 
    required this.hintText, 
    this.fillColor = const Color.fromARGB(183, 234, 10, 10),
    required this.controller, 
    this.desktopText = '',
    this.onSubmitted, 
  });

  final String hintText; 
  final Color fillColor; 
  final TextEditingController controller;  
  final String desktopText;
  final ValueChanged<String>? onSubmitted; 

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        getScreenSize(context) != 'mobile' ? CustomNormalText(text: hintText, fontSize: 16, color: proffessionalBlack, fontWeight: FontWeight.w400,) : const SizedBox(), 
        getScreenSize(context) != 'mobile' ? const SizedBox(height: 8,) : const SizedBox(), 
        TextField(
          style: TextStyle(color: tertiaryColor), 
          controller: controller, 
          onSubmitted: onSubmitted, 
          decoration: InputDecoration( 
            filled: true, 
            fillColor: fillColor,  
            hintText: getScreenSize(context) == 'mobile' ? hintText : desktopText, 
            hintFadeDuration: const Duration(milliseconds: 100),
            hintStyle: const TextStyle(color: Color.fromARGB(86, 37, 37, 37)), 
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(0, 178, 178, 178)
              )
            ), 
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100), 
              borderSide: BorderSide(
                color: tertiaryColor 
              )
            )
          ), 
        ),
      ],
    ); 
  }
}
