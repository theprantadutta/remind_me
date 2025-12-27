import 'package:flutter/material.dart';

/// Animation duration tokens
abstract class AppDurations {
  /// 100ms - Instant, micro-interactions
  static const Duration instant = Duration(milliseconds: 100);

  /// 150ms - Fast transitions
  static const Duration fast = Duration(milliseconds: 150);

  /// 200ms - Quick animations
  static const Duration quick = Duration(milliseconds: 200);

  /// 300ms - Normal/default duration
  static const Duration normal = Duration(milliseconds: 300);

  /// 400ms - Medium duration
  static const Duration medium = Duration(milliseconds: 400);

  /// 500ms - Slow animations
  static const Duration slow = Duration(milliseconds: 500);

  /// 700ms - Slower animations
  static const Duration slower = Duration(milliseconds: 700);

  /// 1000ms - Very slow, emphasis animations
  static const Duration verySlow = Duration(milliseconds: 1000);

  // ============ Semantic Durations ============

  /// Button press feedback
  static const Duration buttonPress = fast;

  /// Page transitions
  static const Duration pageTransition = normal;

  /// Modal/dialog entry
  static const Duration modalEntry = normal;

  /// Modal/dialog exit
  static const Duration modalExit = quick;

  /// List item stagger delay
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Ripple effect
  static const Duration ripple = normal;

  /// Snackbar display
  static const Duration snackbar = Duration(seconds: 4);

  /// Splash screen minimum
  static const Duration splashMinimum = Duration(seconds: 2);

  /// Skeleton shimmer cycle
  static const Duration shimmerCycle = Duration(milliseconds: 1500);
}

/// Animation curve tokens
abstract class AppCurves {
  /// Standard easing - most animations
  static const Curve standard = Curves.easeInOutCubic;

  /// Emphasized easing - important transitions
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;

  /// Entry easing - elements appearing
  static const Curve enter = Curves.easeOutCubic;

  /// Exit easing - elements leaving
  static const Curve exit = Curves.easeInCubic;

  /// Bounce easing - playful elements
  static const Curve bounce = Curves.elasticOut;

  /// Decelerate - coming to rest
  static const Curve decelerate = Curves.decelerate;

  /// Linear - progress indicators
  static const Curve linear = Curves.linear;

  /// Fast out, slow in - for emphasized entry
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  /// Overshoot - for attention-grabbing
  static const Curve overshoot = Curves.easeOutBack;
}

/// Stagger animation helper
class StaggeredAnimation {
  /// Calculate stagger delay for index in list
  static Duration getDelay(int index, {Duration base = AppDurations.staggerDelay}) {
    return Duration(milliseconds: base.inMilliseconds * index);
  }

  /// Calculate total duration for list animation
  static Duration getTotalDuration(
    int itemCount, {
    Duration itemDuration = AppDurations.normal,
    Duration staggerDelay = AppDurations.staggerDelay,
  }) {
    return Duration(
      milliseconds: itemDuration.inMilliseconds + (staggerDelay.inMilliseconds * (itemCount - 1)),
    );
  }
}
