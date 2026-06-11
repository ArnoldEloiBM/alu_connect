import 'package:flutter/material.dart';

/// Constrains the app to phone dimensions and centers it on larger surfaces
/// (desktop / web), so the UI always renders as a phone screen.
///
/// The frame is as tall as the window allows (minus a small margin) so it
/// always fits without scaling. On a screen already narrower than [width]
/// (i.e. a real phone) it just returns the child untouched.
class PhoneFrame extends StatelessWidget {
  final Widget child;
  final double width;

  /// Vertical breathing room left above + below the frame.
  final double verticalMargin;

  const PhoneFrame({
    super.key,
    required this.child,
    this.width = 390,
    this.verticalMargin = 24,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // Real phone (or anything smaller than the frame): no framing needed.
    if (size.width <= width + 1) return child;

    // Use the full available height so the phone is as long as can fit.
    final height = (size.height - verticalMargin * 2).clamp(0.0, size.height);

    return ColoredBox(
      color: const Color(0xFF05080F),
      child: Center(
        child: SizedBox(
          width: width,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              border: Border.all(color: Colors.black, width: 6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
