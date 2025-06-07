// filepath: g:/ProjekteFlutter/empty_flutter_template/_migration_src/storage_hold/lib/presentation/widgets/async/async_value_widget.dart
// /presentation/widgets/async/async_value_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '/../../../core/logging/logger_config.dart'; // Entfernt, da nicht mehr benötigt
// import '/../../presentation/widgets/image_with_banner.dart'; // Wird aktuell nicht genutzt, aber im Original als Fallback kommentiert belassen
import 'async_ui_helper.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
  });

  final AsyncValue<T> value;

  /// Was soll angezeigt werden, wenn die Daten erfolgreich geladen wurden?
  final Widget Function(T data) data;

  /// Optional: Custom-Loading-Widget
  final Widget Function()? loading;

  /// Optional: Custom-Error-Widget
  final Widget Function(Object error, StackTrace? stackTrace)? error;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (dataValue) {
        return data(dataValue);
      },
      loading: () {
        return (loading ?? AsyncUIHelper.loading)();
      },
      error: (e, st) {
        return (error ?? ((e, st) => AsyncUIHelper.error(e, stackTrace: st)))(
          e,
          st,
        );
      },
    );
  }
}
