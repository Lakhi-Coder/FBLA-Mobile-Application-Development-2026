import 'package:fbla_connect/entities/color_pallete.dart';
import 'package:fbla_connect/entities/responsive/media_query.dart';
import 'package:fbla_connect/entities/responsive/section_alignment.dart';
import 'package:fbla_connect/entities/widgets/branding/logo.dart';
import 'package:fbla_connect/entities/widgets/clickable_Surfaces/button.dart';
import 'package:fbla_connect/entities/widgets/custom_text.dart';
import 'package:fbla_connect/entities/widgets/glassmorphism/glass_container.dart';
import 'package:fbla_connect/services/authentication/authentication.dart';
import 'package:fbla_connect/services/user_storage/firestore_database.dart';
import 'package:fbla_connect/tabs/home_tab.dart';
import 'package:fbla_connect/tabs/login_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupTab extends StatefulWidget {
  SignupTab({super.key}); 

  @override
  State<SignupTab> createState() => _SignupTabState();
}

class _SignupTabState extends State<SignupTab> {
  final WidgetStatesController _signupController = WidgetStatesController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); 
  final TextEditingController _chapterNumber = TextEditingController();
  final TextEditingController _gradeLevel = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _fullname = TextEditingController(); 
  final TextEditingController _role = TextEditingController();
  AuthService authService = AuthService(); 
  
  String? _selectedGrade; 
  String? _selectedRole;
  

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
                    maxHeight: 800, 
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
                            const SizedBox(height: 48),
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
              "Welcome!", 
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
          "Create An Account",
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
        // Full Name
        GlassContainer(
          blur: 10,
          opacity: 0.1, 
          borderRadius: [10, 10, 10, 10],
          borderColor: Colors.white.withAlpha(30), 
          child: TextField(
            controller: _fullname,
            cursorColor: tertiaryColor.withAlpha(240).withBlue(100), 
            style: TextStyle(
              color: proffessionalBlack.withAlpha(200), 
              fontSize: adaptiveNumberSizing(16),
            ),
            decoration: InputDecoration(
              hintText: "Full Name",
              hintStyle: TextStyle(
                color: proffessionalBlack.withAlpha(150),  
                fontSize: adaptiveNumberSizing(16),
              ),
              prefixIcon: Icon(
                Icons.person_outline,
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

        const SizedBox(height: 16),

        // Email
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
        
        const SizedBox(height: 16),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withAlpha(20),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedGrade,
            hint: Text('Grade Level', 
              style: TextStyle(color: proffessionalBlack.withAlpha(150))
            ),
            items: ['9', '10', '11', '12'].map((grade) {
              return DropdownMenuItem(
                value: grade, 
                child: Text(grade)
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedGrade = value),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.school_outlined,
                color: uniqueTertiaryColor.withAlpha(204),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            dropdownColor: Colors.white.withAlpha(230),
          ),
        ),

        const SizedBox(height: 16),

        GlassContainer(
          blur: 10,
          opacity: 0.1,
          borderRadius: [10, 10, 10, 10],
          borderColor: Colors.white.withAlpha(30),
          child: TextField(
            controller: _chapterNumber,
            cursorColor: tertiaryColor.withAlpha(240).withBlue(100),
            style: TextStyle(
              color: proffessionalBlack.withAlpha(200), 
              fontSize: adaptiveNumberSizing(16),
            ),
            decoration: InputDecoration(
              hintText: "Chapter Number",
              hintStyle: TextStyle(
                fontSize: adaptiveNumberSizing(16),
                color: proffessionalBlack.withAlpha(150),
              ),
              prefixIcon: Icon(
                Icons.numbers_outlined, 
                color: uniqueTertiaryColor.withAlpha(204), 
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        ),

        const SizedBox(height: 16),

        // Role Dropdown
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withAlpha(20),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedRole,
            hint: Text('Role', 
              style: TextStyle(color: proffessionalBlack.withAlpha(150))
            ),
            items: ['member', 'officer', 'advisor'].map((role) {
              return DropdownMenuItem(
                value: role, 
                child: Text(role[0].toUpperCase() + role.substring(1)) 
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedRole = value),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.work_outline,
                color: uniqueTertiaryColor.withAlpha(204),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            dropdownColor: Colors.white.withAlpha(230),
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
                color: uniqueTertiaryColor.withOpacity(0.9), 
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
      onClickContinue: _signupController,
      text: 'Sign In',
      width: double.infinity,
      onPressed: () {
        _performSignin(context); 
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
          "Have an account? ",
          style: TextStyle(
            color: proffessionalBlack.withAlpha(180),
            fontSize: adaptiveNumberSizing(14),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push( 
              PageRouteBuilder( 
                pageBuilder: (context, animation, secondaryAnimation) => LoginTab(),    
                transitionDuration: Duration(seconds: 0), 
              ), 
            ); 
          },
          child: Text(
            "Login",
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

  void _performSignin(BuildContext context) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final role = _selectedRole ?? '';
      final gradeLevel = _selectedGrade ?? '';
      final chapterNumber = _chapterNumber.text.trim();
      final fullname = _fullname.text.trim();

      if (email.isNotEmpty && 
          password.isNotEmpty && 
          role.isNotEmpty && 
          fullname.isNotEmpty) {
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blue,
            content: CustomNormalText(
              text: 'Creating account...',
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        );
        
        final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        final String userId = userCredential.user!.uid;
        await addUser(userId, email, chapterNumber, gradeLevel, fullname, role); 
        ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: CustomNormalText(
              text: 'Account created successfully!',
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        );
        
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
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
              color: primaryColor,
            ),
          ),
        ),
      );
    }
  }
}