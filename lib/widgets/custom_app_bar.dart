import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? centerWidget;
  final Widget? rightWidget;
  final VoidCallback? onTitleTap;

  const CustomAppBar({
    super.key,
    this.centerWidget,
    this.rightWidget,
    this.onTitleTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false, // 👈 disables default back arrow
      shape: const Border(
        bottom: BorderSide(color: Colors.black, width: 1),
      ),
      title: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(
              onTap: onTitleTap,
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  "iMat",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),


          const Spacer(),
          centerWidget ?? const SizedBox(),
          const Spacer(),
          rightWidget ?? const SizedBox(width: 48),
        ],
      ),
    );
  }
}
