import 'package:flutter/material.dart';

import '../../tokens/borders.dart';
import '../../tokens/spacing.dart';

// Convenience alias
typedef AppBorders = AppBorderRadius;

/// A shimmer/skeleton loading animation widget
class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.child,
  });

  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  final Widget? child;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = colorScheme.surfaceContainerHighest;
    final highlightColor = colorScheme.surface;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? AppBorders.radiusSm,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// A skeleton loader for a list item (task card style)
class SkeletonTaskCard extends StatelessWidget {
  const SkeletonTaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppEdgeInsets.horizontalMd,
      child: Container(
        padding: AppEdgeInsets.md,
        decoration: BoxDecoration(
          borderRadius: AppBorders.radiusMd,
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonLoader(width: 24, height: 24),
                AppGaps.sm,
                const Expanded(
                  child: SkeletonLoader(height: 18),
                ),
                AppGaps.md,
                const SkeletonLoader(width: 60, height: 14),
              ],
            ),
            AppGaps.sm,
            const SkeletonLoader(width: double.infinity, height: 14),
            AppGaps.xs,
            const SkeletonLoader(width: 200, height: 14),
          ],
        ),
      ),
    );
  }
}

/// A list of skeleton task cards
class SkeletonTaskList extends StatelessWidget {
  const SkeletonTaskList({
    super.key,
    this.itemCount = 5,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (context, index) => AppGaps.sm,
      itemBuilder: (context, index) => const SkeletonTaskCard(),
    );
  }
}
