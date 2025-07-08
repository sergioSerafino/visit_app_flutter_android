import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Favoriten-Provider einbinden und Liste anzeigen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoriten'),
      ),
      body: const Center(
        child: Text('Hier werden deine Favoriten angezeigt.'),
      ),
    );
  }
}
