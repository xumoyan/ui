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

class SendAddressTextFormField extends StatefulWidget {
  SendAddressTextFormField(this.api, this.localAccounts,
      {this.initialValue,
      this.onChanged,
      this.addressBookPressed,
      this.scanAddressPressed,
      this.hintText,
      this.hintStyle,
      this.errorStyle,
      this.labelText,
      this.labelStyle,
      this.style,
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
  final TextStyle? style;
  final String? labelText;
  final TextStyle? labelStyle;

  @override
  _SendAddressTextFormFieldState createState() =>
      _SendAddressTextFormFieldState();
}

class _SendAddressTextFormFieldState extends State<SendAddressTextFormField> {
  final TextEditingController _controller = TextEditingController();
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
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.labelText ?? "",
                    style: labelStyle,
                  ),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            'packages/polkawallet_ui/assets/images/icon_send_address_book.png',
                            width: 17,
                            height: 17,
                          ),
                        ),
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (widget.addressBookPressed != null) {
                            widget.addressBookPressed!();
                          }
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        height: 8,
                        child: VerticalDivider(
                          width: 1,
                          color: Color(0xFF999999),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            'packages/polkawallet_ui/assets/images/icon_send_scan.png',
                            width: 17,
                            height: 17,
                          ),
                        ),
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (widget.scanAddressPressed != null) {
                            widget.scanAddressPressed!();
                          }
                        },
                      )
                    ],
                  ))
                ],
              ))
          : Container(),
      Container(
          padding: EdgeInsets.only(left: 15, top: 12, right: 9, bottom: 12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(const Radius.circular(8)),
            color: Colors.white,
          ),
          child: v3.TextInputWidget(
            controller: _controller,
            focusNode: _commentFocus,
            maxLines: 3,
            keyboardType: TextInputType.text,
            displayShadow: false,
            showShadowPadding: false,
            onChanged: (value) {
              final isDeleteBlank =
                  oldValue.replaceAll(' ', '') == value.replaceAll(' ', '');
              final startString = isDeleteBlank ? oldValue : value;
              final startBlankNum = startString.split(' ').length > 1
                  ? startString.split(' ').length - 1
                  : 0;
              String formatString = isDeleteBlank
                  ? value.replaceRange(_controller.selection.baseOffset - 1,
                      _controller.selection.extentOffset, '')
                  : value.replaceAll(' ', '');
              String address = formatAddress(formatString);
              var endBlankNum = address.split(' ').length > 1
                  ? address.split(' ').length - 1
                  : 0;
              final isAdd = oldValue.length < value.length;

              var offset = 0;
              if (isDeleteBlank && startBlankNum == endBlankNum) {
                offset = -1;
              } else {
                offset = endBlankNum - startBlankNum;
              }
              setState(() {
                _controller.value = TextEditingValue(
                    text: address,
                    selection: TextSelection.fromPosition(TextPosition(
                        affinity: TextAffinity.downstream,
                        offset: _controller.selection.extentOffset + offset)));
                oldValue = address;
                hasValue = value.length > 0 ? true : false;
              });

              if (validatorError != null &&
                  _controller.text.trim().toString().length == 0) {
                setState(() {
                  validatorError = null;
                });
              }
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: widget.style,
            decoration: v3.InputDecorationV3(
              hintText: widget.hintText,
              hintStyle: widget.hintStyle,
              suffixIcon: _controller.text.trim().toString().length != 0
                  ? GestureDetector(
                      onTap: () async {
                        _controller.clear();
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(12, 12, 0, 12),
                          child: Image.asset(
                            'packages/polkawallet_ui/assets/images/icon_input_close_g.png',
                            height: 6,
                            width: 6,
                          )),
                    )
                  : null,
            ),
            validator: (value) {
              if (value!.trim().length > 0) {
                return validatorError;
              }
              return null;
            },
          ))
    ]);
  }
}
