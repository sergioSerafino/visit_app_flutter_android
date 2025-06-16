//
import 'package:flutter/material.dart';
import '../../core/utils/button_icon_navigation_constants.dart';

enum IconPosition { left, right, none }

class ButtonIconNavigation extends StatelessWidget {
  final IconData? icon;
  final Widget? customIcon; // z. B. SvgPicture, Image, etc.
  final String label;
  final double sizeOfFont;
  final VoidCallback onPressed;
  final IconPosition iconPosition;
  final bool isOutlined;
  final MainAxisAlignment alignment;
  final Color? color;

  const ButtonIconNavigation({
    super.key,
    this.icon,
    this.customIcon,
    required this.label,
    required this.sizeOfFont,
    required this.onPressed,
    this.isOutlined = false,
    this.iconPosition = IconPosition.left,
    this.alignment = MainAxisAlignment.center,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final hasIcon = iconPosition != IconPosition.none &&
        (icon != null || customIcon != null);

    Widget labelContent = Text(
      label,
      style: ButtonIconNavigationConstants.textStyle.copyWith(fontSize: sizeOfFont),
    );

    Widget? leadingIcon;
    if (icon != null) {
      leadingIcon = Icon(icon,
          size: ButtonIconNavigationConstants.iconSize, color: Colors.white);
    }
    if (customIcon != null) leadingIcon = customIcon;

    List<Widget> children;
    switch (iconPosition) {
      case IconPosition.left:
        children = hasIcon
            ? [leadingIcon!, const SizedBox(width: 8), labelContent]
            : [labelContent];
        break;
      case IconPosition.right:
        children = hasIcon
            ? [labelContent, const SizedBox(width: 8), leadingIcon!]
            : [labelContent];
        break;
      case IconPosition.none:
        children = [labelContent];
        break;
    }

    final content = Row(mainAxisSize: MainAxisSize.min, children: children);

    final button = isOutlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              padding: ButtonIconNavigationConstants.padding,
              textStyle: ButtonIconNavigationConstants.textStyle.copyWith(fontSize: sizeOfFont),
            ),
            child: content,
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              padding: ButtonIconNavigationConstants.padding,
              textStyle: ButtonIconNavigationConstants.textStyle.copyWith(fontSize: sizeOfFont),
            ),
            child: content,
          );

    return Row(mainAxisAlignment: alignment, children: [button]);
  }
}

/*
A) Icon links, elevated:

ButtonIconNavigation(
  icon: Icons.play_arrow,
  label: "Abspielen",
  onPressed: () {},
),


B) Icon rechts, outlined:

ButtonIconNavigation(
  icon: Icons.arrow_forward,
  label: "Weiter",
  iconPosition: IconPosition.right,
  isOutlined: true,
  onPressed: () {},
),


C) Kein Icon:

ButtonIconNavigation(
  label: "Nur Text",
  iconPosition: IconPosition.none,
  onPressed: () {},
),


D) Eigene Farbe + Custom Icon (z. B. SVG):

ButtonIconNavigation(
  label: "Mit SVG",
  customIcon: SvgPicture.asset('assets/icons/play.svg'),
  iconPosition: IconPosition.left,
  color: Colors.pink,
  onPressed: () {},
),

*/
