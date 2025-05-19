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
  Size get preferredSize => const Size.fromHeight(AppTheme.appbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      shape: const Border(
        bottom: BorderSide(color: Colors.black, width: 1),
      ),
      toolbarHeight: AppTheme.appbarHeight,
      flexibleSpace: SafeArea(
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 66),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: InkWell(
                  onTap: onTitleTap,
                  splashColor: AppTheme.backgroundSplashColor,
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      "iMat",
                      style: AppTheme.logoStyle,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              centerWidget ?? const SizedBox(),
              const Spacer(),
              rightWidget ?? const SizedBox(width: 48),
              const SizedBox(width: 54),
            ],
          ),
        ),
      ),
    );
  }

}
