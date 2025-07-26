import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimationUtils {
  // Fade in animation
  static List<Effect<dynamic>> fadeIn({Duration? duration, Curve? curve}) {
    return [
      FadeEffect(
        duration: duration ?? 300.ms,
        curve: curve ?? Curves.easeInOut,
      ),
    ];
  }

  // Slide in animation
  static List<Effect<dynamic>> slideIn({
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
  }) {
    return [
      SlideEffect(
        begin: begin ?? const Offset(0, 0.2),
        end: end ?? Offset.zero,
        duration: duration ?? 400.ms,
        curve: curve ?? Curves.easeOutQuart,
      ),
    ];
  }

  // Bounce animation
  static List<Effect<dynamic>> bounce({
    Duration? duration,
    double? begin,
    double? end,
  }) {
    return [
      ScaleEffect(
        begin: Offset(begin ?? 0.8, begin ?? 0.8),
        end: Offset(end ?? 1.0, end ?? 1.0),
        duration: duration ?? 300.ms,
        curve: Curves.elasticOut,
      ),
    ];
  }

  // Shake animation for wrong guess
  static List<Effect<dynamic>> shake() {
    return [
      ShakeEffect(
        hz: 4,
        offset: const Offset(10, 0),
        duration: 300.ms,
        curve: Curves.easeInOut,
      ),
    ];
  }

  // Pulse animation for correct guess
  static List<Effect<dynamic>> pulse() {
    return [
      ScaleEffect(
        begin: const Offset(1, 1),
        end: const Offset(1.2, 1.2),
        duration: 200.ms,
        curve: Curves.easeInOut,
      ),
      ScaleEffect(
        begin: const Offset(1.2, 1.2),
        end: const Offset(1, 1),
        delay: 200.ms,
        duration: 200.ms,
        curve: Curves.easeInOut,
      ),
    ];
  }

  // Confetti animation for win
  static List<Effect<dynamic>> confetti() {
    return [
      ScaleEffect(
        begin: const Offset(0.5, 0.5),
        end: const Offset(1, 1),
        duration: 500.ms,
        curve: Curves.easeOutBack,
      ),
    ];
  }

  // Button press animation
  static List<Effect<dynamic>> buttonPress() {
    return [
      ScaleEffect(
        begin: const Offset(1, 1),
        end: const Offset(0.95, 0.95),
        duration: 100.ms,
        curve: Curves.easeInOut,
      ),
      ScaleEffect(
        begin: const Offset(0.95, 0.95),
        end: const Offset(1, 1),
        delay: 100.ms,
        duration: 100.ms,
        curve: Curves.easeInOut,
      ),
    ];
  }

  // Letter reveal animation
  static List<Effect<dynamic>> letterReveal() {
    return [
      FadeEffect(
        begin: 0.0,
        end: 1.0,
        duration: 300.ms,
        curve: Curves.easeInOut,
      ),
      ScaleEffect(
        begin: const Offset(0.8, 0.8),
        end: const Offset(1.0, 1.0),
        duration: 300.ms,
        curve: Curves.easeOutBack,
      ),
    ];
  }

  // Hangman part reveal animation
  static List<Effect<dynamic>> hangmanPartReveal() {
    return [
      FadeEffect(
        begin: 0.0,
        end: 1.0,
        duration: 500.ms,
        curve: Curves.easeInOut,
      ),
    ];
  }

  // Game over animation
  static List<Effect<dynamic>> gameOver() {
    return [
      ShakeEffect(
        hz: 3,
        offset: const Offset(15, 0),
        duration: 800.ms,
        curve: Curves.easeInOut,
      ),
      FadeEffect(
        begin: 1.0,
        end: 0.7,
        duration: 800.ms,
        curve: Curves.easeInOut,
      ),
    ];
  }

  // Combine multiple animations
  static List<Effect<dynamic>> combine(List<List<Effect<dynamic>>> effects) {
    return effects.expand((effect) => effect).toList();
  }
}
