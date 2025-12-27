import 'package:hive_ce/hive.dart';

import '../entities/task.dart';
import '../entities/category.dart';
import '../entities/tag.dart';
import '../entities/completed_task.dart';
import '../entities/daily_stats.dart';
import '../enums/priority.dart';

part '../generated/hive/hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<Task>(),
  AdapterSpec<Category>(),
  AdapterSpec<Tag>(),
  AdapterSpec<CompletedTask>(),
  AdapterSpec<DailyStats>(),
  AdapterSpec<Priority>(),
])
class HiveAdapters {}
