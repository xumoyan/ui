import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/txButton.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginButton.dart';
import 'package:polkawallet_ui/pages/txConfirmPage.dart';
import 'package:polkawallet_ui/utils/i18n.dart';

export 'package:polkawallet_ui/components/txButton.dart';

class PluginTxButton extends StatelessWidget {
  PluginTxButton({
    this.text,
    required this.getTxParams,
    this.onFinish,
    this.icon,
    this.color,
  });

  final String? text;
  final Future<TxConfirmParams?> Function() getTxParams;
  final Function(Map?)? onFinish;
  final Widget? icon;
  final Color? color;

  Future<void> _onPressed(BuildContext context) async {
    final params = await getTxParams();
    if (params != null) {
      final res = await Navigator.of(context)
          .pushNamed(TxConfirmPage.route, arguments: params);
      onFinish!(res as Map<dynamic, dynamic>?);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PluginButton(
      title: text ??
          I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!['tx.submit'] ??
          "",
      icon: icon,
      onPressed: () {
        _onPressed(context);
      },
    );
  }
}
