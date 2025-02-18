import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/addressIcon.dart';
import 'package:polkawallet_ui/components/jumpToBrowserLink.dart';
import 'package:polkawallet_ui/utils/consts.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/index.dart';

class AccountInfo extends StatelessWidget {
  AccountInfo(
      {this.accInfo,
      this.address,
      this.icon,
      this.network,
      this.isPlugin = false,
      this.charts});
  final Map? accInfo;
  final String? address;
  final String? icon;
  final String? network;
  final bool isPlugin;
  final Widget? charts;
  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    if (accInfo != null) {
      List<Widget> ls = [];
      accInfo!['identity'].keys.forEach((k) {
        if (k != 'judgements' && k != 'other') {
          String? content = accInfo!['identity'][k].toString();
          if (k == 'parent') {
            content = Fmt.address(content);
          }
          ls.add(Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 80,
                child: Text(k,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(color: isPlugin ? Colors.white : null)),
              ),
              Expanded(
                  child: Text(content,
                      style: TextStyle(color: isPlugin ? Colors.white : null))),
            ],
          ));
        }
      });

      if (ls.length > 0) {
        if (!isPlugin) {
          list.add(Divider());
          list.add(Container(height: 4));
        }
        list.addAll(ls);
      }
    }

    return Column(
      children: <Widget>[
        Container(
          color: Color(0x0FFFFFFF),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 8),
                child: AddressIcon(address, svg: icon),
              ),
              Visibility(
                  visible: accInfo != null,
                  child: Text(accInfo?['accountIndex'] ?? '',
                      style: TextStyle(color: isPlugin ? Colors.white : null))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UI.accountDisplayName(address, accInfo,
                      expand: false,
                      textColor: isPlugin ? Colors.white : Color(0xFF565554))
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16, top: 8),
                child: Text(Fmt.address(address),
                    style: TextStyle(
                        color: isPlugin ? Colors.white : null, fontSize: 14)),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: JumpToBrowserLink(
                        'https://polkascan.io/$network/account/$address',
                        text: 'Polkascan',
                        color: isPlugin ? PluginColorsDark.primary : null,
                      ),
                    ),
                    JumpToBrowserLink(
                      'https://$network.subscan.io/account/$address',
                      text: 'Subscan',
                      color: isPlugin ? PluginColorsDark.primary : null,
                    ),
                    Visibility(
                        visible: charts != null,
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: charts ?? Container(),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
        Visibility(
            visible: accInfo != null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: isPlugin
                  ? Color.fromARGB(255, 58, 60, 63)
                  : Colors.transparent,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: list),
            ))
      ],
    );
  }
}
