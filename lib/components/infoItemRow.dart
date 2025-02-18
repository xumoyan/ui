import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoItemRow extends StatelessWidget {
  InfoItemRow(this.label, this.content,
      {this.colorPrimary = false,
      this.color,
      this.labelStyle,
      this.contentStyle,
      this.crossAxisAlignment = CrossAxisAlignment.center});
  final String label;
  final String? content;
  final Color? color;
  final bool colorPrimary;
  final TextStyle? labelStyle;
  final TextStyle? contentStyle;
  final CrossAxisAlignment crossAxisAlignment;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: this.crossAxisAlignment,
      children: <Widget>[
        Text(
          label,
          style: labelStyle ?? TextStyle(fontSize: 14),
        ),
        Expanded(
          child: Text(
            content!,
            textAlign: TextAlign.right,
            style: contentStyle ??
                (color != null || colorPrimary
                    ? TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color ?? Theme.of(context).primaryColor,
                      )
                    : Theme.of(context).textTheme.headline4),
          ),
        ),
      ],
    );
  }
}
