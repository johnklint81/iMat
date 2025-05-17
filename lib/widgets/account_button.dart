import 'package:flutter/material.dart';

import '../app_theme.dart';

class AccountButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isActive;

  const AccountButton({
    super.key,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  State<AccountButton> createState() => _AccountButtonState();
}

class _AccountButtonState extends State<AccountButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(24));
    final backgroundColor = widget.isActive
        ? const Color(0x1AFFC266)
        : _isHovered
        ? const Color(0x0D000000) // light translucent black on hover
        : Colors.white;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: borderRadius,
          splashColor: const Color(0xFFFFC266),
          highlightColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(
                color: widget.isActive ? const Color(0xFFFFC266) : Colors.black12,
              ),
              borderRadius: borderRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.person, size: 37),
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
