import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomingCatAnimation extends StatefulWidget {
  const WelcomingCatAnimation({super.key, this.size = 380});

  final double size;

  @override
  State<WelcomingCatAnimation> createState() => _WelcomingCatAnimationState();
}

class _WelcomingCatAnimationState extends State<WelcomingCatAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const String _baseAsset = 'assets/icons/kucingpenyambutan_base.svg';
  static const String _rightHandAsset =
      'assets/icons/kucingpenyambutan_tangan_kanan.svg';
  static const String _leftHandAsset =
      'assets/icons/kucingpenyambutan_tangan_kiri.svg';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _wave(double phase, double amplitude) {
    return math.sin((_controller.value * 2 * math.pi) + phase) * amplitude;
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final rightHandAngle = _wave(0, 0.16);
          final leftHandAngle = _wave(math.pi, 0.12);
          final bodyOffsetY = _wave(math.pi / 2, 5.5);

          return SizedBox(
            width: size,
            height: size * 0.76,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(0, bodyOffsetY),
                    child: SvgPicture.asset(_baseAsset, fit: BoxFit.contain),
                  ),
                ),
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(0, bodyOffsetY),
                    child: Transform.rotate(
                      angle: rightHandAngle,
                      alignment: const Alignment(-0.1, 0.12),
                      child: SvgPicture.asset(
                        _rightHandAsset,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(0, bodyOffsetY),
                    child: Transform.rotate(
                      angle: leftHandAngle,
                      alignment: const Alignment(0.58, -0.06),
                      child: SvgPicture.asset(
                        _leftHandAsset,
                        fit: BoxFit.contain,
                      ),
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
