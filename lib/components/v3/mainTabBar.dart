import 'package:flutter/material.dart';

class MainTabBar extends StatelessWidget {
  MainTabBar({required this.tabs, this.activeTab, this.onTap});

  final Map<String, bool> tabs;
  final Function(int)? onTap;
  final int? activeTab;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    tabs.forEach((key, value) {
      final index = tabs.keys.toList().indexOf(key);
      children.add(Expanded(
        child: GestureDetector(
          child: Container(
            alignment: Alignment.center,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                  image: AssetImage(
                      "packages/polkawallet_ui/assets/images/tab_bg_${index == 0 ? 'l' : 'r'}_${index == activeTab ? 'blue' : 'grey'}.png"),
                  fit: BoxFit.fill),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  key,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'TitilliumWeb',
                    color: activeTab == index
                        ? Colors.white
                        : Theme.of(context).unselectedWidgetColor,
                  ),
                ),
                Visibility(
                    visible: value,
                    child: Container(
                      width: 9,
                      height: 9,
                      margin: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.5),
                          color: Theme.of(context).errorColor),
                    ))
              ],
            ),
          ),
          onTap: () => onTap!(index),
        ),
      ));
    });
    return Row(
      children: children,
    );
  }
}
