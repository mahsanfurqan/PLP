import 'package:flutter/material.dart';

import 'kucing_home_animation.dart';

class LatarBelakangHomeWidget extends StatelessWidget {
  const LatarBelakangHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final catSize = width > 900 ? width * 0.5 : width * 0.8;

        return Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/icons/latarbelakanghome.png',
              fit: BoxFit.cover,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.16),
                    Colors.white.withValues(alpha: 0.02),
                    Colors.black.withValues(alpha: 0.18),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
            Positioned(
              top: height * 0.40,
              left: 0,
              right: 0,
              child: Center(child: KucingHomeAnimation(size: catSize)),
            ),
          ],
        );
      },
    );
  }
}
