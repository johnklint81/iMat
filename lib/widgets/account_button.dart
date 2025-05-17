import 'package:flutter/material.dart';

import '../app_theme.dart';

class AccountButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;

  const AccountButton({
    super.key,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(24));
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius,
          splashColor: const Color(0xFFFFC266),
          highlightColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? const Color(0x1AFFC266) : Colors.white,
              border: Border.all(
                color: isActive ? const Color(0xFFFFC266) : Colors.black12,
              ),
              borderRadius: borderRadius
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.person, size: 32),
                SizedBox(width: 6),
                Text(
                  "Konto",
                  style: AppTheme.accountButtonStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
