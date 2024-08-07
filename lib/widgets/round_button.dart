import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  const RoundButton({
    super.key,
    required this.title,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  strokeWidth: 1,
                  color: Colors.white,
                )
              : Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
