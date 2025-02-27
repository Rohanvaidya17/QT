import 'package:flutter/material.dart';

class BrandedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final double elevation;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final bool useHeroLogo;  // Added this parameter

  const BrandedAppBar({
    Key? key,
    this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.centerTitle = true,
    this.elevation = 0,
    this.backgroundColor,
    this.bottom,
    this.useHeroLogo = true,  // Default to true for backward compatibility
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (useHeroLogo) ...[
            Hero(
              tag: 'qt_logo',
              child: Image.asset(
                'assets/Images/QTlogo.png',
                height: 32,
              ),
            ),
            if (title != null) const SizedBox(width: 8),
          ],
          if (title != null)
            Text(
              title!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
      centerTitle: centerTitle,
      actions: actions,
      bottom: bottom,
    );
  }
}