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
    const borderRadius = BorderRadius.all(Radius.circular(64));

    final isActive = widget.isActive;
    final baseColor = isActive
        ? AppTheme.buttonColor1
        : _isHovered
        ? const Color(0x26000000) // 15% black
        : Colors.white;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        borderRadius: borderRadius,
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: borderRadius,
            border: Border.all(
              color: isActive ? const Color(0xFFFFC266) : Colors.black12,
            ),
            boxShadow: isActive
                ? [
              BoxShadow(
                color: const Color(0xFFFFC266).withOpacity(0.5),
                blurRadius: 6,
                offset: const Offset(0, 2),
              )
            ]
                : [],
          ),
          child: InkWell(
            borderRadius: borderRadius,
            splashColor: AppTheme.buttonColor1,
            highlightColor: Colors.transparent,
            onTap: widget.onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    size: 37,
                    color: isActive ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Konto",
                    style: AppTheme.accountButtonStyle.copyWith(
                      color: isActive ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
