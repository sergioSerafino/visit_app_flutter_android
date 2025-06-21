import 'package:flutter/material.dart';
import '../../core/utils/color_utils.dart';

String _formatHostNameForLineBreak(String hostName, {int threshold = 30}) {
  if (hostName.length < threshold) return hostName;
  final delimiters = [':', '-', '|', '/', ','];
  for (var d in delimiters) {
    if (hostName.contains(d)) {
      final parts = hostName.split(d);
      if (parts.length > 1) {
        return '${parts[0]}$d\n${parts.sublist(1).join(d).trim()}';
      }
    }
  }
  return hostName;
}

/// Material3-Header mit AppBar-Overlay, dynamischem "Visit\nHostName", SafeArea und Actions.
class HomeHeaderMaterial3 extends StatelessWidget {
  final String hostName;
  final Color baseColor;
  final Color? surfaceTint;
  final bool overlayActive;
  final Color? textColor;
  final double height;
  final List<Widget>? actions;
  final TextStyle? textStyle;

  const HomeHeaderMaterial3({
    super.key,
    required this.hostName,
    required this.baseColor,
    this.surfaceTint,
    this.overlayActive = false,
    this.textColor,
    this.height = kToolbarHeight + 30,
    this.actions,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final double elevation = overlayActive ? 3.0 : 0.0;
    final Color effectiveColor = flutterAppBarOverlayColorM3(
      context,
      baseColor,
      surfaceTint: surfaceTint,
      elevation: elevation,
    );
    final Color effectiveTextColor =
        textColor ?? Theme.of(context).colorScheme.onPrimary;
    final formattedHost = _formatHostNameForLineBreak(hostName);
    return SafeArea(
      bottom: false,
      child: Material(
        color: Colors.transparent, // Hintergrund transparent für Overlay-Effekt
        elevation: 0,
        child: SizedBox(
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 0), // Kein linker Abstand mehr
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      style: textStyle ??
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: effectiveTextColor,
                              ),
                      children: [
                        const TextSpan(text: 'Visit'),
                        TextSpan(
                          text: "\n$formattedHost",
                          style: (textStyle ??
                                  Theme.of(context).textTheme.headlineSmall)
                              ?.copyWith(
                            color: effectiveTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (actions != null) ...actions!,
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
