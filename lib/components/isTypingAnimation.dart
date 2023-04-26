import 'package:flutter/material.dart';

class IsTypingAnimation extends StatefulWidget {
  const IsTypingAnimation({super.key});

  @override
  State<IsTypingAnimation> createState() => _IsTypingAnimationState();
}

class _IsTypingAnimationState extends State<IsTypingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _circleController1;
  late AnimationController _circleController2;
  late AnimationController _circleController3;

  @override
  void initState() {
    _circleController1 = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _circleController2 = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
    _circleController3 = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _circleController2.addListener(() async {
      if (!mounted) return;

      try {
        if (_circleController2.isCompleted) {
          await Future.delayed(const Duration(milliseconds: 100));
          _circleController2.reverse();
        } else if (_circleController2.isDismissed) {
          await Future.delayed(const Duration(milliseconds: 100));
          _circleController2.forward();
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    _circleController3.addListener(() async {
      if (!mounted) return;

      try {
        if (_circleController3.isCompleted) {
          await Future.delayed(const Duration(milliseconds: 200));
          _circleController3.reverse();
        } else if (_circleController3.isDismissed) {
          await Future.delayed(const Duration(milliseconds: 200));
          _circleController3.forward();
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      height: 40,
      margin: const EdgeInsets.fromLTRB(10, 0, 200, 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // circle 1
          ScaleTransition(
            scale: CurvedAnimation(
                parent: _circleController1, curve: Curves.easeInOut),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // circle 2
          ScaleTransition(
            scale: CurvedAnimation(
                parent: _circleController2, curve: Curves.easeInOut),
            child: Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // circle 3
          ScaleTransition(
            scale: CurvedAnimation(
                parent: _circleController3, curve: Curves.easeInOut),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _circleController1.dispose();
    _circleController2.dispose();
    _circleController3.dispose();
    super.dispose();
  }
}
