import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkawallet_sdk/api/api.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/addressFormItem.dart';
import 'package:polkawallet_ui/components/v3/textFormField.dart' as v3;
import 'package:polkawallet_ui/pages/v3/accountListPage.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';
import 'package:polkawallet_ui/utils/Utils.dart';

class AmountTextFormField extends StatefulWidget {
  AmountTextFormField(this.api, this.localAccounts,
      {this.initialValue,
      this.onChanged,
      this.addressBookPressed,
      this.scanAddressPressed,
      this.hintText,
      this.hintStyle,
      this.errorStyle,
      this.labelText,
      this.labelStyle,
      this.currency = "CNY",
      this.symbol,
      Key? key})
      : super(key: key);
  final PolkawalletApi api;
  final List<KeyPairData> localAccounts;
  final KeyPairData? initialValue;
  final Function(KeyPairData)? onChanged;
  final Function()? addressBookPressed;
  final Function()? scanAddressPressed;

  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final String currency;
  final String symbol;

  @override
  _AmountTextFormFieldState createState() => _AmountTextFormFieldState();
}

class _AmountTextFormFieldState extends State<AmountTextFormField> {
  final TextEditingController _coinAmountController = TextEditingController();
  final TextEditingController _currencyAmountController =
      TextEditingController();
  Map _addressIndexMap = {};
  Map _addressIconsMap = {};
  String? validatorError;
  bool hasFocus = false;
  bool hasValue = false;
  String oldValue = '';
  FocusNode _commentFocus = FocusNode();

  Future<KeyPairData?> _getAccountFromInput(String input) async {
    // return local account list if input empty
    if (input.isEmpty || input.trim().length < 3) {
      return null;
    }

    // todo: eth address not support now
    if (input.trim().startsWith('0x')) {
      return null;
    }

    // check if user input is valid address or indices
    final checkAddress = await widget.api.account.decodeAddress([input]);
    if (checkAddress == null) {
      return null;
    }

    final acc = KeyPairData();
    acc.address = input;
    acc.pubKey = checkAddress.keys.toList()[0];
    if (input.length < 47) {
      // check if input indices in local account list
      final int indicesIndex = widget.localAccounts.indexWhere((e) {
        final Map? accInfo = e.indexInfo;
        return accInfo != null && accInfo['accountIndex'] == input;
      });
      if (indicesIndex >= 0) {
        return widget.localAccounts[indicesIndex];
      }
      // query account address with account indices
      final queryRes =
          await widget.api.account.queryAddressWithAccountIndex(input);
      if (queryRes != null) {
        acc.address = queryRes;
        acc.name = input;
      }
    } else {
      // check if input address in local account list
      final int addressIndex = widget.localAccounts
          .indexWhere((e) => _itemAsString(e).contains(input));
      if (addressIndex >= 0) {
        return widget.localAccounts[addressIndex];
      }
    }

    // fetch address info if it's a new address
    final res = await widget.api.account.getAddressIcons([acc.address]);
    if (res != null) {
      if (res.length > 0) {
        acc.icon = res[0][1];
        setState(() {
          _addressIconsMap.addAll({acc.address: res[0][1]});
        });
      }

      // The indices query too slow, so we use address as account name
      if (acc.name == null) {
        acc.name = Fmt.address(acc.address);
      }
    }
    return acc;
  }

  String _itemAsString(KeyPairData item) {
    final Map? accInfo = _getAddressInfo(item);
    String? idx = '';
    if (accInfo != null && accInfo['accountIndex'] != null) {
      idx = accInfo['accountIndex'];
    }
    if (item.name != null) {
      return '${item.name} $idx ${item.address}';
    }
    return '${UI.accountDisplayNameString(item.address, accInfo)} $idx ${item.address}';
  }

  Map? _getAddressInfo(KeyPairData acc) {
    return acc.indexInfo ?? _addressIndexMap[acc.address];
  }

  String formatAddress(String value) {
    RegExp regExp = new RegExp(r'([^]){1,4}');
    Iterable<Match> matches = regExp.allMatches(value.replaceAll(' ', ''));

    List<String?> strList = [];
    for (Match m in matches) {
      strList.add(m.group(0));
    }
    final formatAddress = strList.join(' ');
    return formatAddress;
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common');
    final labelStyle =
        widget.labelStyle ?? Theme.of(context).textTheme.bodyText1;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      widget.labelText != null
          ? Container(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.labelText ?? "",
                    style: labelStyle,
                  )
                ],
              ))
          : Container(),
      Container(
          margin: EdgeInsets.only(top: 12),
          height: 115,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(const Radius.circular(8)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                  height: 74,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: v3.TextInputWidget(
                              displayShadow: false,
                              showShadowPadding: false,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: v3.InputDecorationV3(
                                hintText: '0.00',
                                isCollapsed: true,
                                hintStyle: widget.hintStyle,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 27),
                                suffix: _coinAmountController.text
                                            .trim()
                                            .toString()
                                            .length !=
                                        0
                                    ? GestureDetector(
                                        onTap: () async {
                                          _coinAmountController.clear();
                                        },
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                12, 12, 0, 12),
                                            child: Image.asset(
                                              'packages/polkawallet_ui/assets/images/icon_input_close_g.png',
                                              height: 6,
                                              width: 6,
                                            )),
                                      )
                                    : null,
                                prefixIcon: Container(
                                    child: Image.asset(
                                  Utils.getCoinSymbol(widget.symbol),
                                  height: 16,
                                  width: 16,
                                )),
                              ),
                              controller: _coinAmountController,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true))),
                      Center(
                        child: Container(
                            width: 18,
                            height: 74,
                            padding: EdgeInsets.only(bottom: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '≈',
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Color(0xFFdcdcdc),
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            )),
                      ),
                      Expanded(
                          flex: 1,
                          child: v3.TextInputWidget(
                              displayShadow: false,
                              showShadowPadding: false,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF333333)),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: v3.InputDecorationV3(
                                isCollapsed: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 27),
                                hintText: '12.00',
                                hintStyle: widget.hintStyle,
                                suffix: _currencyAmountController.text
                                            .trim()
                                            .toString()
                                            .length !=
                                        0
                                    ? GestureDetector(
                                        onTap: () async {
                                          _currencyAmountController.clear();
                                        },
                                        child: Container(
                                            width: 12,
                                            padding: EdgeInsets.fromLTRB(
                                                12, 12, 0, 12),
                                            child: Image.asset(
                                              'packages/polkawallet_ui/assets/images/icon_input_close_g.png',
                                              height: 6,
                                              width: 6,
                                            )),
                                      )
                                    : null,
                                prefixIcon: Container(
                                    child: Image.asset(
                                  Utils.getCurrencySymbol(widget.currency),
                                  height: 16,
                                  width: 16,
                                )),
                                isDense: true,
                                prefixIconConstraints:
                                    BoxConstraints(minWidth: 0, minHeight: 0),
                              ),
                              controller: _currencyAmountController,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true))),
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                  height: 1,
                  color: Color(0xFFeeeeee),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('可用：0 ETH',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                              fontWeight: FontWeight.w400)),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 1, bottom: 1),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(8)),
                            color: Colors.white,
                            border: Border.all(
                              color: Color(0x335887e3),
                            )),
                        child: Text('全部发送',
                            style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF5887e3),
                                fontWeight: FontWeight.w400)),
                      )
                    ],
                  )),
            ],
          ))
    ]);
  }
}
