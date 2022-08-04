import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button(
      {Key? key,
      this.onPressed,
      this.title = "",
      this.style,
      this.icon,
      this.submitting = false,
      this.isBlueBg = true,
      this.imageType = 1,
      this.height})
      : super(key: key);
  final Function()? onPressed;
  final String title;
  final Widget? icon;
  final bool submitting;
  final double? height;
  final TextStyle? style;
  final bool isBlueBg;
  //imageType 1 default
  //imageType 1 eos_transfer_btn_normal png
  final int imageType;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.all(0),
      onPressed: !submitting ? onPressed : null,
      child: BgContainer(
        double.infinity,
        height: height ?? 48,
        isBlueBg: isBlueBg,
        imageType: imageType,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: submitting,
              child: Container(
                margin: EdgeInsets.only(right: 8),
                child: CupertinoActivityIndicator(),
              ),
            ),
            Text(title, style: style ?? Theme.of(context).textTheme.button),
            icon != null ? icon! : Container(),
          ],
        ),
      ),
    );
  }
}

class BgContainer extends StatelessWidget {
  const BgContainer(this.width,
      {this.margin,
      this.padding,
      this.child,
      this.isBlueBg = false,
      this.alignment,
      this.height,
      this.imageType = 1,
      Key? key})
      : super(key: key);

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final double width;
  final double? height;
  final bool isBlueBg;
  final int imageType;
  final AlignmentGeometry? alignment;

  List<Widget> getBgImage() {
    if (imageType == 1) {
      return [
        Image.asset(
          "packages/polkawallet_ui/assets/images/bg_${this.isBlueBg ? "blue" : "grey"}_left.png",
          fit: BoxFit.fill,
        ),
        Expanded(
            child: Image.asset(
          "packages/polkawallet_ui/assets/images/bg_${this.isBlueBg ? "blue" : "grey"}_center.png",
          fit: BoxFit.fill,
        )),
        Image.asset(
          "packages/polkawallet_ui/assets/images/bg_${this.isBlueBg ? "blue" : "grey"}_right.png",
          fit: BoxFit.fill,
        )
      ];
    } else {
      return [
        Expanded(
            child: Image.asset(
          "packages/polkawallet_ui/assets/images/eos_transfer_btn_normal.png",
          fit: BoxFit.fill,
        ))
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: width,
            child: Row(
              children: getBgImage(),
            ),
          ),
          Container(
              margin: margin,
              width: width,
              padding: padding,
              alignment: alignment,
              child: child!)
        ],
      ),
    );
  }
}
