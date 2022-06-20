import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {
  const RoundedCard(
      {this.border,
      this.margin,
      this.padding,
      this.child,
      Key? key,
      this.radius,
      this.boxShadow,
      this.color})
      : super(key: key);

  final BoxBorder? border;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final Color? color;
  final BorderRadiusGeometry? radius;
  final BoxShadow? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: child,
      decoration: BoxDecoration(
        border: border,
        borderRadius: radius != null
            ? radius
            : const BorderRadius.all(const Radius.circular(8)),
        color: this.color ?? Theme.of(context).cardColor,
        boxShadow: [
          boxShadow != null
              ? boxShadow!
              : BoxShadow(
                  color: Color(0x30000000),
                  blurRadius: 2.0, // has the effect of softening the shadow
                  spreadRadius: 0.0, // has the effect of extending the shadow
                  offset: Offset(
                    1.0, // horizontal, move right 10
                    1.0, // vertical, move down 10
                  ),
                )
        ],
      ),
    );
  }
}
