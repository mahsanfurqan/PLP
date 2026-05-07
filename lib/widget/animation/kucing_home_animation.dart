import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KucingHomeAnimation extends StatefulWidget {
  const KucingHomeAnimation({super.key, this.size = 420});

  final double size;

  @override
  State<KucingHomeAnimation> createState() => _KucingHomeAnimationState();
}

class _KucingHomeAnimationState extends State<KucingHomeAnimation>
    with SingleTickerProviderStateMixin {
  static const String _baseAsset = 'assets/icons/kucinghome_base.svg';
  static const String _leftEarAsset = 'assets/icons/kucinghome_kuping_kiri.svg';
  static const String _rightEarAsset =
      'assets/icons/kucinghome_kuping_kanan.svg';
  static const String _tailAsset = 'assets/icons/kucinghome_ekor.svg';
  static const String _rightHandAsset =
      'assets/icons/kucinghome_tangan_kanan.svg';

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _sine({required double phase, required double amplitude}) {
    return math.sin((_controller.value * 2 * math.pi) + phase) * amplitude;
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final bodyFloat = _sine(phase: math.pi / 2, amplitude: 7);
          final leftEarAngle = _sine(phase: 0.35, amplitude: 0.06);
          final rightEarAngle = _sine(phase: math.pi + 0.45, amplitude: 0.06);
          final tailAngle = _sine(phase: 0, amplitude: 0.16);
          final handAngle = _sine(phase: math.pi / 3, amplitude: 0.11);

          Widget buildLayer(String assetPath) {
            return SvgPicture.asset(assetPath, fit: BoxFit.contain);
          }

          return SizedBox(
            width: size,
            height: size * 1.18,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(0, bodyFloat),
                    child: Transform.rotate(
                      angle: tailAngle,
                      alignment: const Alignment(0.76, 0.28),
                      child: buildLayer(_tailAsset),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(0, bodyFloat),
                    child: Transform.rotate(
                      angle: handAngle,
                      alignment: const Alignment(-0.54, -0.08),
                      child: buildLayer(_rightHandAsset),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(0, bodyFloat),
                    child: buildLayer(_baseAsset),
                  ),
                ),
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(0, bodyFloat),
                    child: Transform.rotate(
                      angle: leftEarAngle,
                      alignment: const Alignment(0.22, -0.9),
                      child: buildLayer(_leftEarAsset),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(0, bodyFloat),
                    child: Transform.rotate(
                      angle: rightEarAngle,
                      alignment: const Alignment(-0.18, -0.9),
                      child: buildLayer(_rightEarAsset),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
