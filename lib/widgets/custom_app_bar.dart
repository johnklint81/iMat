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
        child: LayoutBuilder(
          builder: (context, constraints) {
            const iMatWidth = 300.0; // Hack to fix the size of the search bar when shrinking app size
            const kontoWidth = 380.0;
            const spacing = 77.0;


            final availableCenterWidth = constraints.maxWidth - iMatWidth - kontoWidth - 2 * spacing;
            final safeSearchWidth = availableCenterWidth.clamp(200.0, 600.0);

            return Stack(
              children: [
                // iMat logo
                Positioned(
                  left: iMatWidth / 2 - 50,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onTitleTap,
                          borderRadius: BorderRadius.circular(4),
                          splashColor: AppTheme.backgroundSplashColor,
                          highlightColor: Colors.transparent,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            child: Text("iMat", style: AppTheme.logoStyle),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Konto button
                Positioned(
                  right: spacing,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: rightWidget ?? SizedBox(width: kontoWidth),
                  ),
                ),

                // Search bar in between
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: safeSearchWidth,
                    ),
                    child: centerWidget ?? const SizedBox(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}
