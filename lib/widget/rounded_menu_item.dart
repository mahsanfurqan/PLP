import 'package:flutter/material.dart';

class RoundedMenuItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const RoundedMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade300, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black12, // abu-abu lembut
              offset: const Offset(0, 4), // ke bawah
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(icon, width: 40, height: 40),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
