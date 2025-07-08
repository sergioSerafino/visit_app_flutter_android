import 'package:flutter/material.dart';

class FavoritesDrawerContent extends StatelessWidget {
  const FavoritesDrawerContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Favoriten-Provider einbinden und Liste anzeigen
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                Icon(Icons.star, color: Colors.amber, size: 28),
                SizedBox(width: 12),
                Text('Favoriten',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
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
