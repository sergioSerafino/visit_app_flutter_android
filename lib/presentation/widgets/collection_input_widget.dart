// /presentation/widgets/collection_input_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/collection_provider.dart';

class CollectionInputWidget extends ConsumerWidget {
  const CollectionInputWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 150,
      height: 38,
      child: TextField(
        decoration: InputDecoration(
          hintText: "Collection ID",
          hintStyle: const TextStyle(fontSize: 14),
          prefixIcon: Icon(Icons.numbers,
              size: 18, color: theme.colorScheme.onSurface.withAlpha(120)),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          final id = int.tryParse(value);
          if (id != null) {
            ref.read(collectionIdProvider.notifier).setCollectionId(id);
          }
        },
      ),
    );
  }
}
