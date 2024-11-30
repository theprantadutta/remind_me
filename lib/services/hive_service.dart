import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:remind_me/hive/hive_registrar.g.dart';

import '../entities/task.dart';
import '../hive/hive_boxes.dart';

class HiveService {
  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapters();
    await Hive.openBox<Task>(taskBoxKey);
  }
}
