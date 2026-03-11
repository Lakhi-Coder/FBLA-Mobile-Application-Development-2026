import 'package:fbla_connect/entities/responsive/media_query.dart';
import 'package:fbla_connect/entities/widgets/glassmorphism/glass_container.dart';
import 'package:flutter/material.dart';


class DecorativeDisplay extends StatelessWidget {
  const DecorativeDisplay({
    super.key,
    required this.child, 
    required this.contentHeight,
  });

  final Widget child; 
  final double contentHeight; 

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RotatedBox(
          quarterTurns: 20,
          child: Container(
            height: double.infinity,
            width: double.infinity, 
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(200)), 
            ),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0), 
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(0), 
                  bottomRight: Radius.circular(0), 
                ),
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.white],
                ),
              ),
              child: Image(
                fit: BoxFit.cover, 
                image: AssetImage( 
                   getScreenSize(context) == 'mobile'? 'images/main_images/initial/mobile_fbla_app_image.png'
                  :getScreenSize(context) == 'tablet'? 'images/main_images/initial/tablet_fbla_app_image.png'
                  :'images/main_images/initial/desktop_fbla_app_image.png' 
                ),
              ),
            ),
          ),
        ),
    
        Align(
          alignment: getScreenSize(context) == 'mobile'? Alignment.bottomCenter: Alignment.centerLeft,
          child: SizedBox(
            width: getScreenSize(context) == 'mobile'? null: getScreenSize(context) == 'tablet'? 300: 360,
            height: contentHeight, 
            child: GlassContainer(
              blur: 15,
              opacity: 0.15,
              borderRadius: [0, 0, 0, 0], 
              borderColor: Colors.white.withAlpha(36), 
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: getScreenSize(context) == 'desktop'? 360: double.infinity,
                    maxHeight: getScreenSize(context) == 'mobile'? double.infinity: 300, 
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}