import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

const green = Color(0xFF00D09E);
const lightGreen = Color(0xFFF1FFF3);
const fieldGreen = Color(0xFFDFF7E2);
const dark = Color(0xFF093030);
const hintColor = Color(0xFF82A99F);
const blue = Color(0xFF168BFF);

class AuthLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const AuthLayout({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: green,
      body: SafeArea(
        child: Column(
          children: [
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
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(45),
                  ),
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

class AuthField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool hidden;
  final VoidCallback? onEyeTap;
  final String? Function(String value)? validator;
  final ValueChanged<String>? onChanged;

  const AuthField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.hidden = false,
    this.onEyeTap,
    this.validator,
    this.onChanged,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  String? errorText;

  void _validate(String value) {
    if (widget.validator == null) return;

    final error = widget.validator!(value);

    if (mounted && errorText != error) {
      setState(() => errorText = error);
    }
  }

  @override
  void didUpdateWidget(covariant AuthField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Revalidate when a related field changes,
    // for example when the password changes.
    if (widget.validator != oldWidget.validator &&
        widget.controller.text.isNotEmpty) {
      errorText = widget.validator?.call(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: dark,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 42,
          child: TextField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword && widget.hidden,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: dark,
            ),
            onChanged: (value) {
              _validate(value);
              widget.onChanged?.call(value);
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: fieldGreen,
              hintText: widget.hint,
              hintStyle: GoogleFonts.poppins(
                fontSize: 13,
                color: hintColor,
              ),
              contentPadding: const EdgeInsets.only(left: 22),
              suffixIcon: widget.isPassword
                  ? IconButton(
                onPressed: widget.onEyeTap,
                icon: Icon(
                  widget.hidden
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
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              errorText!,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.red.shade700,
              ),
            ),
          ),
        const SizedBox(height: 14),
      ],
    );
  }
}

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
        onPressed: loading ? null : onTap,
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
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: dark,
          ),
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

class SocialRow extends StatelessWidget {
  final VoidCallback onFacebook;
  final VoidCallback onGoogle;

  const SocialRow({
    super.key,
    required this.onFacebook,
    required this.onGoogle,
  });

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
              child: SvgPicture.asset(
                'assets/icons/login_facebook.svg',
                width: 33,
                height: 33,
              ),
            ),
            const SizedBox(width: 17),
            GestureDetector(
              onTap: onGoogle,
              child: SvgPicture.asset(
                'assets/icons/login_google.svg',
                width: 33,
                height: 33,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

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
            TextSpan(
              text: linkText,
              style: const TextStyle(color: blue),
            ),
          ],
        ),
      ),
    );
  }
}