import 'package:flutter/material.dart';

class AppBottomContainer extends StatelessWidget {
  final Widget child;

  const AppBottomContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF1FFF3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(55),
          topRight: Radius.circular(55),
        ),
      ),
      child: child,
    );
  }
}