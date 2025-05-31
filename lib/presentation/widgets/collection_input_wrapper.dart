// lib/presentation/widgets/collection_input_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/data_mode_provider.dart';
import '../../domain/enums/repository_source_type.dart';
import 'collection_input_widget.dart';

class CollectionInputWrapper extends ConsumerWidget {
  const CollectionInputWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isApiMode = ref.watch(dataSourceProvider) == RepositorySourceType.api;

    return SizedBox(
      width: 160,
      height: 38,
      child: AnimatedOpacity(
        opacity: isApiMode ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: IgnorePointer(
          ignoring: !isApiMode,
          child: const CollectionInputWidget(),
        ),
      ),
    );
  }
}
