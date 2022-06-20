import 'package:flutter/material.dart' hide IconButton;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkawallet_ui/components/v3/iconButton.dart';

class BackBtn extends StatelessWidget {
  BackBtn({this.onBack, this.margin, Key? key}) : super(key: key);

  final Function? onBack;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (onBack != null) {
          onBack!();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Center(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
              width: 44,
              height: 44,
              color: Colors.transparent,
              child: IconButton(
                icon: SvgPicture.asset(
                  "packages/polkawallet_ui/assets/images/icon_back_24.svg",
                ),
              ))),
    );
  }
}
