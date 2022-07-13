import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polkawallet_ui/utils/index.dart';
import 'package:flutter/src/cupertino/switch.dart' as system;

class CupertinoSwitch extends StatelessWidget {
  const CupertinoSwitch(
      {required this.value,
      required this.onChanged,
      this.isPlugin = false,
      Key? key})
      : super(key: key);
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isPlugin;

  @override
  Widget build(BuildContext context) {
    return UI.isDarkTheme(context)
        ? SizedBox(
            width: 36,
            child: FittedBox(
                child: system.CupertinoSwitch(
              value: value,
              onChanged: onChanged,
              activeColor: Theme.of(context).errorColor,
              trackColor: Theme.of(context).scaffoldBackgroundColor,
              thumbColor:
                  value ? const Color(0xFFD4D4D4) : const Color(0x80FFFFFF),
            )),
          )
        : GestureDetector(
            onTap: () {
              onChanged!(!value);
            },
            child: Image.asset(
              "packages/polkawallet_ui/assets/images/${isPlugin ? 'plugin_' : ''}switch_${value ? 'open' : 'close'}.png",
              width: 36,
            ),
          );
  }
}
