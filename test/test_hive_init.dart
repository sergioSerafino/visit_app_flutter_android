// test/test_hive_init.dart
// Initialisiert Hive für alle Widget- und Bloc-Tests
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void setupHiveForTests() {
  setUpAll(() async {
    Hive.init(Directory.systemTemp.path);
  });
}
