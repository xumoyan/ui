import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/addressIcon.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginButton.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginScaffold.dart';
import 'package:polkawallet_ui/components/v3/plugin/roundedPluginCard.dart';
import 'package:polkawallet_ui/utils/consts.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';

class PluginTxDetail extends StatelessWidget {
  PluginTxDetail({
    this.success,
    this.networkName,
    this.action,
    this.fee,
    this.eventId,
    this.hash,
    this.blockTime,
    this.blockNum,
    this.infoItems,
    required this.current,
  });

  final bool? success;
  final String? networkName;
  final String? action;
  final String? fee;
  final String? eventId;
  final String? hash;
  final String? blockTime;
  final int? blockNum;
  final List<TxDetailInfoItem>? infoItems;
  final KeyPairData current;

  List<Widget> _buildListView(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common');
    final labelStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontFamily: 'TitilliumWeb',
      fontWeight: FontWeight.w600,
    );

    var list = <Widget>[
      Container(
        margin: EdgeInsets.all(16),
        height: 180,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
                margin: EdgeInsets.only(top: 30),
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 68, 70, 73),
                    borderRadius: BorderRadius.all(Radius.circular(16)))),
            Image.asset(
                'packages/polkawallet_ui/assets/images/bg_detail_circle.png',
                width: 90,
                color: Color.fromARGB(255, 68, 70, 73),
                fit: BoxFit.contain),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    AddressIcon(
                      current.address,
                      svg: current.icon,
                      size: 55,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Theme.of(context).toggleableActiveColor,
                              width: 3),
                          borderRadius:
                              BorderRadius.all(Radius.circular(55 / 2.0))),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: Text(current.name!, style: labelStyle)),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        infoItems![0].content!,
                        Text(
                          '$action ${success! ? dic!['success'] : dic!['fail']}',
                          style: TextStyle(
                            color: success!
                                ? Color(0xFF81FEB9)
                                : PluginColorsDark.primary,
                            fontSize: 14,
                            fontFamily: 'TitilliumWeb',
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ))
                  ],
                ))
          ],
        ),
      )
    ];

    int index = 0;
    bool isShowDivider = false;
    list.add(RoundedPluginCard(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      borderRadius: const BorderRadius.all(const Radius.circular(14)),
      child: Column(
        children: [
          ...infoItems!.map((i) {
            if (index == 0) {
              index = 1;
              return Container();
            }
            if (isShowDivider == false) {
              isShowDivider = true;
              return TxDetailItem(i, labelStyle, isShowDivider: false);
            }
            return TxDetailItem(i, labelStyle);
          }).toList(),
          Visibility(
              visible: fee != null,
              child: TxDetailItem(
                  TxDetailInfoItem(
                      label: dic['tx.fee'],
                      content: Text(
                        fee ?? "",
                        style: TextStyle(color: Colors.white),
                      )),
                  labelStyle)),
          Visibility(
              visible: eventId != null,
              child: TxDetailItem(
                  TxDetailInfoItem(
                      label: 'Event',
                      content: Text(eventId ?? "",
                          style: TextStyle(color: Colors.white))),
                  labelStyle)),
          Visibility(
              visible: blockNum != null,
              child: TxDetailItem(
                  TxDetailInfoItem(
                      label: 'Block',
                      content: Text('#$blockNum',
                          style: TextStyle(color: Colors.white))),
                  labelStyle)),
          Visibility(
              visible: hash != null,
              child: TxDetailItem(
                  TxDetailInfoItem(
                      label: 'Hash',
                      content: Text(Fmt.address(hash),
                          style: TextStyle(color: Colors.white))),
                  labelStyle)),
          Visibility(
              visible: blockTime != null,
              child: TxDetailItem(
                  TxDetailInfoItem(
                      label: 'Time',
                      content: Text(blockTime!,
                          style: TextStyle(color: Colors.white))),
                  labelStyle)),
        ],
      ),
    ));
    if (hash == null) return list;

    final pnLink = networkName == 'polkadot' || networkName == 'kusama'
        ? 'https://polkascan.io/${networkName!.toLowerCase()}/transaction/$hash'
        : null;
    final snLink =
        'https://${networkName!.toLowerCase()}.subscan.io/extrinsic/$hash';
    Widget links = Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: PluginButton(
          title: 'Subscan',
          style: Theme.of(context)
              .textTheme
              .headline3
              ?.copyWith(color: Colors.black),
          backgroundColor: PluginColorsDark.primary,
          onPressed: () async {
            await UI.launchURL(snLink);
          },
          icon: SvgPicture.asset(
            "packages/polkawallet_ui/assets/images/icon_share.svg",
            width: 24,
            color: Colors.black,
          ),
        ));
    if (pnLink != null) {
      links = Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Expanded(
                  child: PluginButton(
                title: 'Subscan',
                backgroundColor: PluginColorsDark.primary,
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(color: Colors.black),
                onPressed: () async {
                  await UI.launchURL(snLink);
                },
                icon: Container(
                    margin: EdgeInsets.only(left: 3),
                    child: SvgPicture.asset(
                      "packages/polkawallet_ui/assets/images/icon_share.svg",
                      width: 24,
                      color: Colors.black,
                    )),
              )),
              Container(width: 30),
              Expanded(
                  child: PluginButton(
                title: 'Polkascan',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: "TitilliumWeb"),
                backgroundColor: PluginColorsDark.headline1,
                onPressed: () async {
                  await UI.launchURL(pnLink);
                },
                icon: Container(
                    margin: EdgeInsets.only(left: 3),
                    child: SvgPicture.asset(
                      "packages/polkawallet_ui/assets/images/icon_share.svg",
                      width: 24,
                      color: Colors.black,
                    )),
              ))
            ],
          ));
    }

    list.add(links);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
    return PluginScaffold(
      appBar: PluginAppBar(title: Text(dic['detail']!), centerTitle: true),
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 32),
          children: _buildListView(context),
        ),
      ),
    );
  }
}

class TxDetailItem extends StatelessWidget {
  TxDetailItem(this.i, this.labelStyle, {this.isShowDivider = true});
  final TxDetailInfoItem i;
  final TextStyle labelStyle;
  final bool isShowDivider;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
            visible: isShowDivider,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  height: 1,
                ))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(flex: 0, child: Text(i.label!, style: labelStyle)),
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(left: 16),
                alignment: Alignment.centerRight,
                child: i.content!,
              )),
              i.copyText != null
                  ? GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Image.asset(
                          'packages/polkawallet_ui/assets/images/copy.png',
                          width: 16,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () => UI.copyAndNotify(context, i.copyText),
                    )
                  : Container(width: 0)
            ],
          ),
        )
      ],
    );
  }
}

class TxDetailInfoItem {
  TxDetailInfoItem({this.label, this.content, this.copyText});
  final String? label;
  final Widget? content;
  final String? copyText;
}
