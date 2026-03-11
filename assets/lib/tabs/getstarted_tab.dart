import 'package:fbla_connect/entities/color_pallete.dart';
import 'package:fbla_connect/entities/responsive/media_query.dart';
import 'package:fbla_connect/entities/responsive/section_alignment.dart';
import 'package:fbla_connect/entities/widgets/branding/logo.dart';
import 'package:fbla_connect/entities/widgets/clickable_Surfaces/button.dart';
import 'package:fbla_connect/entities/widgets/page_builders/initial_tab.dart';
import 'package:fbla_connect/tabs/login_tab.dart';
import 'package:flutter/material.dart';


            
class GetstartedTab extends StatelessWidget { 
  GetstartedTab({super.key}); 

  final WidgetStatesController onClickContinue = WidgetStatesController(); 

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      body: Stack(
        children: [
          DecorativeDisplay( 
            contentHeight: getScreenSize(context) == 'mobile'? adaptiveNumberSizing(320): double.infinity, 
            child: MainWidgetInteractiveChildren(onClickContinue: onClickContinue),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 20), 
              child: CustomLogo(), 
            ),
          ), 
        ],
      ),
    ); 
  }
}

class MainWidgetInteractiveChildren extends StatelessWidget {
  const MainWidgetInteractiveChildren({
    super.key,  
    required this.onClickContinue,
  });

  final WidgetStatesController onClickContinue; 

  @override
  Widget build(BuildContext context) { 
    return SizedBox(
      child: Padding(  
        padding:  EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_objects_rounded, 
                    color: uniqueTertiaryColor.withOpacity(0.9),
                    size: 32),
                const SizedBox(width: 10), 
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: adaptiveNumberSizing(28),
                    fontWeight: FontWeight.w600,
                    color: proffessionalBlack
                        .withAlpha(220)
                        .withBlue(110)
                        .withGreen(60),
                  ),
                ),
              ],
            ),
      
            const SizedBox(height: 6), 
      
            Text(
              "Let's Get Started!",
              style: TextStyle(
                fontSize: adaptiveNumberSizing(34),
                fontWeight: FontWeight.w700,
                color: uniqueTertiaryColor,
                decoration: TextDecoration.underline,
                decorationColor: uniqueTertiaryColor,
              ),
            ),
      
            const SizedBox(height: 20),
      
            SizedBox(
              width: 300,
              child: Text(
                "Explore your journey — discover, learn, and innovate with FBLA-powered tools.",
                style: TextStyle(
                  fontSize: adaptiveNumberSizing(18),
                  height: 1.4,
                  color: proffessionalBlack.withAlpha(150).withBlue(90).withGreen(44),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
      
            SizedBox(height: 20,), 
      
            Align(
              alignment: getScreenSize(context) == 'desktop'? Alignment.bottomLeft: Alignment.bottomCenter,
              child: SizedBox(child: CustomButton(onClickContinue: onClickContinue, width: getScreenSize(context) == 'mobile'? double.infinity: 300,onPressed: () {
                Navigator.of(context).push( 
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => LoginTab(),  
                    transitionDuration: Duration(seconds: 0), 
                  ), 
                ); 
              },)), 
            ) 
          ],
        ),
      ),
    );
  }
}

