import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardButton extends StatelessWidget {
  CardButton({this.onPressed, required this.text, required this.icon, Key? key})
      : super(key: key);
  final Function()? onPressed;
  final String text;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: Container(
          padding: EdgeInsets.only(top: 3.h, bottom: 10, right: 3),
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
                image: AssetImage(
                    "packages/polkawallet_ui/assets/images/btn_card_bg.png"),
                fit: BoxFit.fill),
          ),
          alignment: Alignment.center,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                Text(
                  text,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.w600, fontFamily: "TitilliumWeb"),
                ),
              ],
            ),
          ),
        ));
  }
}
