
import 'package:fbla_connect/entities/color_pallete.dart';
import 'package:fbla_connect/entities/responsive/media_query.dart';
import 'package:fbla_connect/entities/responsive/section_alignment.dart';
import 'package:fbla_connect/entities/widgets/branding/logo.dart';
import 'package:fbla_connect/entities/widgets/clickable_Surfaces/button.dart';
import 'package:fbla_connect/entities/widgets/custom_text.dart';
import 'package:fbla_connect/entities/widgets/glassmorphism/glass_container.dart';
import 'package:fbla_connect/services/authentication/authentication.dart';
import 'package:fbla_connect/tabs/home_tab.dart';
import 'package:fbla_connect/tabs/signup_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginTab extends StatelessWidget {
  LoginTab({super.key});

  final WidgetStatesController _loginController = WidgetStatesController(); 
  final TextEditingController _emailController = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController();

  AuthService authService = AuthService(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              getScreenSize(context) == 'mobile' 
                ? 'images/main_images/initial/mobile_fbla_app_image.png' 
                : getScreenSize(context) == 'tablet' 
                  ? 'images/main_images/initial/tablet_fbla_app_image.png'
                  : 'images/main_images/initial/desktop_fbla_app_image.png',
              fit: BoxFit.cover,
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: getScreenSize(context) == 'mobile' 
                ? double.infinity 
                : getScreenSize(context) == 'tablet' 
                  ? 300 
                  : 450,
              height: double.infinity, 
              child: GlassContainer(
                blur: 20,
                opacity: 0.15,
                borderRadius: [0, 0, 0, 0],
                borderColor: Colors.white.withAlpha(40),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 600, 
                    maxWidth: 680
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 32),
                    
                            _buildLoginForm(),
                    
                            _buildForgotPassword(),
                    
                            const SizedBox(height: 24),
                    
                            _buildLoginButton(context),
                    
                            const SizedBox(height: 24),
                    
                            _buildDivider(),
                    
                            const SizedBox(height: 24),
                    
                            _buildSignUpOption(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.verified_user_rounded,
              color: uniqueTertiaryColor.withAlpha(234),
              size: 32,
            ),
            const SizedBox(width: 12),
            Text(
              "Welcome Back!",
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
        const SizedBox(height: 8),
        Text(
          "Login to Your Account",
          style: TextStyle(
            fontSize: adaptiveNumberSizing(34),
            fontWeight: FontWeight.w700,
            color: uniqueTertiaryColor,
            decoration: TextDecoration.underline,
            decorationColor: uniqueTertiaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        GlassContainer(
          blur: 10,
          opacity: 0.1,
          borderRadius: [10, 10, 10, 10],
          borderColor: Colors.white.withAlpha(30),
          child: TextField(
            controller: _emailController,
            cursorColor: tertiaryColor.withAlpha(240).withBlue(100),
            style: TextStyle(
              color: proffessionalBlack.withAlpha(200),
              fontSize: adaptiveNumberSizing(16),
            ),
            decoration: InputDecoration(
              hintText: "Email Address",
              hintStyle: TextStyle(
                color: proffessionalBlack.withAlpha(150),
                fontSize: adaptiveNumberSizing(16),
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: uniqueTertiaryColor.withAlpha(204),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),

        const SizedBox(height: 16),

        GlassContainer(
          blur: 10,
          opacity: 0.1,
          borderRadius: [10, 10, 10, 10],
          borderColor: Colors.white.withAlpha(30),
          child: TextField(
            controller: _passwordController,
            cursorColor: tertiaryColor.withAlpha(240).withBlue(100),
            style: TextStyle(
              color: proffessionalBlack.withAlpha(200), 
              fontSize: adaptiveNumberSizing(16),
            ),
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              hintStyle: TextStyle(
                color: proffessionalBlack.withAlpha(150),
                fontSize: adaptiveNumberSizing(16),
              ),
              prefixIcon: Icon(
                Icons.lock_outline_rounded, 
                color: uniqueTertiaryColor.withAlpha(204), 
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPassword() {
    WidgetStatesController forgotPsswrdBtn = WidgetStatesController(); 
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        statesController: forgotPsswrdBtn,
        style: ButtonStyle(
          overlayColor: WidgetStatePropertyAll(Colors.transparent), 
        ),
        onPressed: () {

        },
        child: ValueListenableBuilder<Set<WidgetState>>( 
          valueListenable: forgotPsswrdBtn,
          builder: (context, states, child) {
            final isHovered = states.contains(WidgetState.hovered);
            return Text(
              "Forgot Password?",
              style: TextStyle(
                decoration: isHovered ? TextDecoration.underline : null,
                color: uniqueTertiaryColor.withAlpha(234), 
                fontSize: adaptiveNumberSizing(14),
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return CustomButton(
      onClickContinue: _loginController,
      text: 'Sign In',
      width: double.infinity,
      onPressed: () {
        _performLogin(context);
      },
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: proffessionalBlack.withAlpha(100), 
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16), 
          child: Text(
            "or",
            style: TextStyle(
              color: proffessionalBlack.withAlpha(150),
              fontSize: adaptiveNumberSizing(14),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: proffessionalBlack.withAlpha(100),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            color: proffessionalBlack.withAlpha(180), 
            fontSize: adaptiveNumberSizing(14),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push( 
              PageRouteBuilder( 
                pageBuilder: (context, animation, secondaryAnimation) => SignupTab(),   
                transitionDuration: Duration(seconds: 0), 
              ), 
            ); 
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
              color: uniqueTertiaryColor,
              fontSize: adaptiveNumberSizing(14), 
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _performLogin(BuildContext context) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim(); 

      if (email.isNotEmpty && password.isNotEmpty) { 
        await authService.signInWithEmail(email, password); 
        
        Navigator.of(context).pushReplacementNamed('/main');
        
      } else {
        print('Please fill in all fields');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red, 
            content: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
              },
              child: CustomNormalText(
                text: 'ERROR: Fill In All Fields', 
                fontSize: 18, 
                color: primaryColor,
              ),
            )
          )
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar( 
        SnackBar(
          backgroundColor: Colors.red,
          content: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: CustomNormalText(
              text: 'ERROR: ${e.message ?? e.code}', 
              fontSize: 18, 
              color: primaryColor,
            ),
          ),
        ), 
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red, 
          content: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
            },
            child: CustomNormalText( 
              text: 'ERROR: $e', 
              fontSize: 18, 
              color: proffessionalBlack,
            ),
          ),
        ), 
      );
    }
  }
}