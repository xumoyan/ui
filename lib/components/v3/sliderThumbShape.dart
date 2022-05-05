import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class SliderThumbShape extends SliderComponentShape {
  final ui.Image? image;
  // ui.Image images;
  SliderThumbShape(this.image);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.zero;
  }

  @override
  Future<void> paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) async {
    final Canvas canvas = context.canvas;
    if (image != null) {
      canvas.drawImage(
          image!,
          Offset(
              center.dx - image!.width / 2, center.dy - image!.height / 2 + 2),
          Paint());
    }
  }
}
