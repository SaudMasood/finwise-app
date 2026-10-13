import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notification/notification.dart';

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({super.key});

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  static const Color mainGreen = Color(0xFF00D09E);
  static const Color lightGreen = Color(0xFFF1FFF3);
  static const Color darkGreen = Color(0xFF063F3F);

  static const String _acceptedKey = 'terms_conditions_accepted';

  bool accepted = false;
  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _loadAcceptance();
  }

  Future<void> _loadAcceptance() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      accepted = prefs.getBool(_acceptedKey) ?? false;
      loading = false;
    });
  }

  Future<void> _acceptTerms() async {
    if (!accepted || saving) return;

    setState(() => saving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_acceptedKey, true);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terms and conditions accepted successfully.'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to save your acceptance. Please try again.'),
        ),
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  TextStyle get _bodyStyle => GoogleFonts.poppins(
    fontSize: 10.5,
    height: 1.6,
    color: darkGreen,
  );

  Widget _paragraph(String text) {
    return Text(text, textAlign: TextAlign.justify, style: _bodyStyle);
  }

  Widget _item(String number, String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 22, child: Text(number, style: _bodyStyle)),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$title. ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: text),
                ],
              ),
              textAlign: TextAlign.justify,
              style: _bodyStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Terms And Conditions',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: darkGreen,
                    ),
                  ),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: lightGreen,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.notifications_none,
                    color: darkGreen,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(45),
                  ),
                ),
                child: loading
                    ? const Center(
                  child: CircularProgressIndicator(color: mainGreen),
                )
                    : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 30, 28, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Terms And Conditions',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: darkGreen,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _paragraph(
                        'Please read these terms and conditions '
                            'carefully before using FinWise. By using the '
                            'application, you agree to follow the '
                            'applicable terms and use its features '
                            'responsibly.',
                      ),
                      const SizedBox(height: 12),
                      _item(
                        '1.',
                        'Account Information',
                        'You are responsible for maintaining the '
                            'accuracy of your account information.',
                      ),
                      _item(
                        '2.',
                        'Application Usage',
                        'Use FinWise responsibly and do not misuse its '
                            'services.',
                      ),
                      _item(
                        '3.',
                        'Privacy',
                        'Your information is handled according to the '
                            'application privacy policy.',
                      ),
                      _item(
                        '4.',
                        'Financial Information',
                        'Review your financial records carefully. The '
                            'application does not replace professional '
                            'financial advice.',
                      ),
                      const SizedBox(height: 8),
                      _paragraph(
                        'By continuing, you confirm that you have read '
                            'and understood the terms and conditions.',
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Read the terms and conditions in more detail at',
                        style: _bodyStyle,
                      ),
                      Text(
                        'www.finwiseapp.de',
                        style: _bodyStyle.copyWith(
                          color: const Color(0xFF2F80ED),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: accepted,
                            activeColor: Colors.transparent,
                            checkColor: darkGreen,
                            side: const BorderSide(
                              color: darkGreen,
                              width: 1.5,
                            ),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                            onChanged: (v) =>
                                setState(() => accepted = v ?? false),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'I accept all the terms and conditions',
                            style: _bodyStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: SizedBox(
                          width: 150,
                          height: 38,
                          child: ElevatedButton(
                            onPressed:
                            accepted && !saving ? _acceptTerms : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainGreen,
                              disabledBackgroundColor:
                              Colors.grey.shade300,
                              foregroundColor: darkGreen,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: saving
                                ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: darkGreen,
                              ),
                            )
                                : Text(
                              'Accept',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}