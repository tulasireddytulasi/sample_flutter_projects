import 'package:flutter/material.dart';

class CountdownWidget extends StatelessWidget {
  final String buttonTitle;
  final TextStyle? textStyle;
  const CountdownWidget({super.key, required this.buttonTitle, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final inAnimation = Tween<Offset>(begin: const Offset(0.0, 1.0), end: const Offset(0.0, 0.0)).animate(animation);
        final outAnimation = Tween<Offset>(begin: const Offset(0.0, -1.0), end: const Offset(0.0, 0.0)).animate(animation);

        return child.key == ValueKey(buttonTitle)
            ? ClipRect(
                child: SlideTransition(position: inAnimation, child: child),
              )
            : ClipRect(
                child: SlideTransition(position: outAnimation, child: child),
              );
      },
      child: KeyedSubtree(
        key: ValueKey(buttonTitle),
        child: Text(
          buttonTitle,
          style: textStyle,
        ),
      ),
    );
  }
}
