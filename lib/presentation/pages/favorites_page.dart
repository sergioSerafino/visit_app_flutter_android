import 'package:flutter/material.dart';

class FavoritesDrawerContent extends StatelessWidget {
  const FavoritesDrawerContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Favoriten-Provider einbinden und Liste anzeigen

    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: 32,
                  shadows: [
                    Shadow(
                      color: theme.colorScheme.primary.withAlpha(140),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Text('Favoriten',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          const Divider(),
          const Expanded(
            child: Center(
              child: Text('Hier werden deine Favoriten angezeigt.'),
            ),
          ),
        ],
      ),
    );
  }
}
