import 'package:hive_ce/hive.dart';

import '../entities/task.dart';

part '../generated/hive/hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<Task>(),
])
class HiveAdapters {}
