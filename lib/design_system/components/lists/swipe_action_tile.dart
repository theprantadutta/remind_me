import 'package:flutter/material.dart';

import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// A list tile with swipe-to-action functionality
class SwipeActionTile extends StatefulWidget {
  const SwipeActionTile({
    super.key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.leftAction,
    this.rightAction,
    this.leftActionColor,
    this.rightActionColor,
    this.leftActionIcon,
    this.rightActionIcon,
    this.leftActionLabel,
    this.rightActionLabel,
    this.confirmDismiss,
    this.threshold = 0.3,
  });

  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final Widget? leftAction;
  final Widget? rightAction;
  final Color? leftActionColor;
  final Color? rightActionColor;
  final IconData? leftActionIcon;
  final IconData? rightActionIcon;
  final String? leftActionLabel;
  final String? rightActionLabel;
  final Future<bool> Function(DismissDirection)? confirmDismiss;
  final double threshold;

  @override
  State<SwipeActionTile> createState() => _SwipeActionTileState();
}

class _SwipeActionTileState extends State<SwipeActionTile> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: UniqueKey(),
      direction: _getDirection(),
      dismissThresholds: {
        DismissDirection.endToStart: widget.threshold,
        DismissDirection.startToEnd: widget.threshold,
      },
      confirmDismiss: widget.confirmDismiss,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          widget.onSwipeLeft?.call();
        } else if (direction == DismissDirection.startToEnd) {
          widget.onSwipeRight?.call();
        }
      },
      background: widget.rightAction ??
          _buildBackground(
            context,
            alignment: Alignment.centerLeft,
            color: widget.rightActionColor ?? colorScheme.primary,
            icon: widget.rightActionIcon ?? Icons.check,
            label: widget.rightActionLabel,
          ),
      secondaryBackground: widget.leftAction ??
          _buildBackground(
            context,
            alignment: Alignment.centerRight,
            color: widget.leftActionColor ?? colorScheme.error,
            icon: widget.leftActionIcon ?? Icons.delete,
            label: widget.leftActionLabel,
          ),
      child: widget.child,
    );
  }

  DismissDirection _getDirection() {
    if (widget.onSwipeLeft != null && widget.onSwipeRight != null) {
      return DismissDirection.horizontal;
    } else if (widget.onSwipeLeft != null) {
      return DismissDirection.endToStart;
    } else if (widget.onSwipeRight != null) {
      return DismissDirection.startToEnd;
    }
    return DismissDirection.none;
  }

  Widget _buildBackground(
    BuildContext context, {
    required AlignmentGeometry alignment,
    required Color color,
    required IconData icon,
    String? label,
  }) {
    return Container(
      color: color,
      alignment: alignment,
      padding: AppEdgeInsets.horizontalLg,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerRight) ...[
            if (label != null) ...[
              Text(
                label,
                style: AppTypography.labelLarge.copyWith(
                  color: Colors.white,
                ),
              ),
              AppGaps.sm,
            ],
          ],
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          if (alignment == Alignment.centerLeft) ...[
            if (label != null) ...[
              AppGaps.sm,
              Text(
                label,
                style: AppTypography.labelLarge.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// Swipe action tile specifically for tasks
class TaskSwipeActionTile extends StatelessWidget {
  const TaskSwipeActionTile({
    super.key,
    required this.child,
    this.onComplete,
    this.onDelete,
    this.isCompleted = false,
  });

  final Widget child;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SwipeActionTile(
      onSwipeRight: onComplete,
      onSwipeLeft: onDelete,
      rightActionColor: isCompleted
          ? colorScheme.secondary
          : colorScheme.primary,
      rightActionIcon: isCompleted
          ? Icons.replay
          : Icons.check,
      rightActionLabel: isCompleted ? 'Undo' : 'Complete',
      leftActionColor: colorScheme.error,
      leftActionIcon: Icons.delete,
      leftActionLabel: 'Delete',
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Delete confirmation
          return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Task'),
                  content: const Text(
                    'Are you sure you want to delete this task?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.error,
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ) ??
              false;
        }
        return true;
      },
      child: child,
    );
  }
}
