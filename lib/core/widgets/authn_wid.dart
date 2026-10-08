import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

// =====================================================
// Small reusable widgets for Login, Sign Up, Forgot Password
// (Put this file in the same folder as login_page.dart)
// =====================================================

// Colors
const green = Color(0xFF00D09E);
const lightGreen = Color(0xFFF1FFF3);
const fieldGreen = Color(0xFFDFF7E2);
const dark = Color(0xFF093030);
const hintColor = Color(0xFF82A99F);
const blue = Color(0xFF168BFF);

// -----------------------------------------------------
// Page layout: green top with title + light rounded sheet
// -----------------------------------------------------
class AuthLayout extends StatelessWidget {
  final String title;
  final Widget child; // everything inside the light sheet

  const AuthLayout({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: green,
      body: SafeArea(
        child: Column(
          children: [
            // Green top part with title
            SizedBox(
              height: height * 0.18,
              child: Center(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: dark,
                  ),
                ),
              ),
            ),

            // Light rounded sheet
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------
// Label + rounded text field
// -----------------------------------------------------
class AuthField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword; // show eye icon?
  final bool hidden; // is the password hidden?
  final VoidCallback? onEyeTap;

  const AuthField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.hidden = false,
    this.onEyeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: dark,
          ),
        ),
        const SizedBox(height: 6),

        // Text field
        SizedBox(
          height: 42,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isPassword && hidden,
            style: GoogleFonts.poppins(fontSize: 13, color: dark),
            decoration: InputDecoration(
              filled: true,
              fillColor: fieldGreen,
              hintText: hint,
              hintStyle: GoogleFonts.poppins(fontSize: 13, color: hintColor),
              contentPadding: const EdgeInsets.only(left: 22),
              // Eye icon only for password fields
              suffixIcon: isPassword
                  ? IconButton(
                onPressed: onEyeTap,
                icon: Icon(
                  hidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: dark,
                ),
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

// -----------------------------------------------------
// Rounded button (filled = green, not filled = light green)
// -----------------------------------------------------
class GreenButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool loading;
  final bool filled;
  final double width;

  const GreenButton({
    super.key,
    required this.text,
    required this.onTap,
    this.loading = false,
    this.filled = true,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 44,
      child: ElevatedButton(
        onPressed: loading ? null : onTap, // disabled while loading
        style: ElevatedButton.styleFrom(
          backgroundColor: filled ? green : fieldGreen,
          foregroundColor: dark,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: loading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: dark),
        )
            : Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------
// "or sign up with" + Facebook and Google icons
// -----------------------------------------------------
class SocialRow extends StatelessWidget {
  final VoidCallback onFacebook;
  final VoidCallback onGoogle;

  const SocialRow({super.key, required this.onFacebook, required this.onGoogle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'or sign up with',
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w300,
            color: dark,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onFacebook,
              child: SvgPicture.asset('assets/icons/login_facebook.svg',
                  width: 33, height: 33),
            ),
            const SizedBox(width: 17),
            GestureDetector(
              onTap: onGoogle,
              child: SvgPicture.asset('assets/icons/login_google.svg',
                  width: 33, height: 33),
            ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------
// Small text with a blue link: "Don't have an account? Sign Up"
// -----------------------------------------------------
class BottomText extends StatelessWidget {
  final String normalText;
  final String linkText;
  final VoidCallback onTap;

  const BottomText({
    super.key,
    required this.normalText,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w300,
            color: dark,
          ),
          children: [
            TextSpan(text: normalText),
            TextSpan(text: linkText, style: const TextStyle(color: blue)),
          ],
        ),
      ),
    );
  }
}