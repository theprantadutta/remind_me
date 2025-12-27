import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design_system/components/cards/task_card.dart';
import '../design_system/components/feedback/empty_state.dart';
import '../design_system/components/lists/swipe_action_tile.dart';
import '../design_system/tokens/borders.dart';
import '../design_system/tokens/spacing.dart';
import '../design_system/tokens/typography.dart';
import '../entities/category.dart';
import '../providers/category_provider.dart';
import '../providers/task_provider.dart';
import 'create_task_screen.dart';

/// Categories screen showing all categories and their tasks
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<CategoryProvider>(
          builder: (context, categoryProvider, _) {
            final categories = categoryProvider.categories;

            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  floating: true,
                  title: Text(
                    'Categories',
                    style: AppTypography.headlineMedium,
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _showCreateCategoryDialog(context);
                      },
                    ),
                  ],
                ),
                // Category Grid
                SliverPadding(
                  padding: AppEdgeInsets.md,
                  sliver: categories.isEmpty
                      ? SliverFillRemaining(
                          child: EmptyStates.noCategories(
                            onCreateCategory: () {
                              _showCreateCategoryDialog(context);
                            },
                          ),
                        )
                      : SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.3,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final category = categories[index];
                              return _CategoryCard(category: category);
                            },
                            childCount: categories.length,
                          ),
                        ),
                ),
                // Selected Category Tasks
                if (categoryProvider.selectedCategory != null) ...[
                  SliverToBoxAdapter(
                    child: _SelectedCategoryHeader(),
                  ),
                  SliverPadding(
                    padding: AppEdgeInsets.horizontalMd,
                    sliver: _SelectedCategoryTasks(),
                  ),
                ],
                // Bottom padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    int selectedColor = 0xFF6366F1;
    int selectedIcon = Icons.folder.codePoint;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Category Name',
                      hintText: 'Enter category name',
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  AppGaps.lg,
                  Text(
                    'Select Color',
                    style: AppTypography.labelMedium,
                  ),
                  AppGaps.sm,
                  Wrap(
                    spacing: 8,
                    children: [
                      0xFF6366F1,
                      0xFF8B5CF6,
                      0xFF10B981,
                      0xFFF59E0B,
                      0xFFEF4444,
                      0xFF3B82F6,
                      0xFF06B6D4,
                      0xFFEC4899,
                    ]
                        .map((color) => GestureDetector(
                              onTap: () =>
                                  setState(() => selectedColor = color),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Color(color),
                                  shape: BoxShape.circle,
                                  border: selectedColor == color
                                      ? Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        )
                                      : null,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      context.read<CategoryProvider>().createCategory(
                            name: nameController.text,
                            colorValue: selectedColor,
                            iconCodePoint: selectedIcon,
                          );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoryProvider = context.watch<CategoryProvider>();
    final isSelected = categoryProvider.selectedCategory?.id == category.id;

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          categoryProvider.selectCategory(null);
        } else {
          categoryProvider.selectCategory(category);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: AppEdgeInsets.md,
        decoration: BoxDecoration(
          color: isSelected
              ? category.color.withValues(alpha: 0.2)
              : colorScheme.surfaceContainer,
          borderRadius: AppBorderRadius.radiusMd,
          border: isSelected
              ? Border.all(color: category.color, width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: 24,
                  ),
                ),
                if (category.isCustom)
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onSelected: (value) {
                      if (value == 'delete') {
                        _confirmDelete(context, category);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: AppTypography.titleSmall.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${category.taskCount} tasks',
                  style: AppTypography.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
          'Are you sure you want to delete "${category.name}"? Tasks in this category will be uncategorized.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<CategoryProvider>().deleteCategory(category.id);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SelectedCategoryHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoryProvider = context.watch<CategoryProvider>();
    final category = categoryProvider.selectedCategory!;

    return Padding(
      padding: AppEdgeInsets.md,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              category.icon,
              color: category.color,
              size: 16,
            ),
          ),
          AppGaps.sm,
          Text(
            category.name,
            style: AppTypography.titleMedium.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => categoryProvider.selectCategory(null),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _SelectedCategoryTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final taskProvider = context.read<TaskProvider>();
    final tasks = categoryProvider.getTasksInCategory(
      categoryProvider.selectedCategory!.id,
    );

    if (tasks.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: AppEdgeInsets.xl,
          child: Center(
            child: Text(
              'No tasks in this category',
              style: AppTypography.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final task = tasks[index];
          return Padding(
            padding: AppEdgeInsets.verticalSm,
            child: TaskSwipeActionTile(
              isCompleted: task.isCompleted,
              onComplete: () {
                taskProvider.completeTask(task.id);
                categoryProvider.loadCategories();
              },
              onDelete: () {
                taskProvider.deleteTask(task.id);
                categoryProvider.loadCategories();
              },
              child: TaskCard(
                task: task,
                showCategory: false,
                onComplete: () {
                  taskProvider.completeTask(task.id);
                  categoryProvider.loadCategories();
                },
              ),
            ),
          );
        },
        childCount: tasks.length,
      ),
    );
  }
}
