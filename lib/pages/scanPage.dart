import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_scan/qrcode_reader_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';

class ScanPage extends StatelessWidget {
  ScanPage(this.plugin, this.keyring);
  final PolkawalletPlugin plugin;
  final Keyring keyring;

  static final String route = '/account/scan';

  final GlobalKey<QrcodeReaderViewState> _qrViewKey = GlobalKey();

  Future<bool> canOpenCamera() async {
    var status = await Permission.camera.request();
    return status.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    Future onScan(String? txt, String? rawData) async {
      String address = '';
      final String data = txt!.trim();
      if (data != null) {
        if (data.contains("polkawallet.io")) {
          final paths = data.toString().split("polkawallet.io");
          Map<dynamic, dynamic> args = Map<dynamic, dynamic>();
          if (paths.length > 1) {
            final pathDatas = paths[1].split("?");
            if (pathDatas.length > 1) {
              final datas = pathDatas[1].split("&");
              datas.forEach((element) {
                args[element.split("=")[0]] =
                    Uri.decodeComponent(element.split("=")[1]);
              });
            }
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(pathDatas[0], arguments: args);
          }
          return;
        }
        List<String> ls = data.split(':');

        if (ls[0] == 'wc') {
          print('walletconnect pairing uri detected.');
          Navigator.of(context).pop(QRCodeResult(
            type: QRCodeResultType.rawData,
            rawData: data,
          ));
          return;
        }

        for (String item in ls) {
          if (Fmt.isAddress(item)) {
            address = item;
            break;
          }
        }

        if (address.length > 0) {
          print('address detected in Qr');
          Navigator.of(context).pop(QRCodeResult(
            type: QRCodeResultType.address,
            address: ls.length == 4
                ? QRCodeAddressResult(ls)
                : QRCodeAddressResult(['', address, '', '']),
          ));
        } else if (Fmt.isHexString(data)) {
          print('hex detected in Qr');
          Navigator.of(context).pop(QRCodeResult(
            type: QRCodeResultType.hex,
            hex: data,
          ));
        } else if (rawData != null &&
            rawData.startsWith('4') &&
            (rawData.endsWith('ec') ||
                rawData.endsWith('ec11') ||
                rawData.endsWith('0'))) {
          print('rawBytes detected in Qr');
          Navigator.of(context).pop(QRCodeResult(
            type: QRCodeResultType.rawData,
            rawData: rawData,
          ));
        } else {
          _qrViewKey.currentState!.startScan();
        }
      }
    }

    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
    return Scaffold(
      body: FutureBuilder<bool>(
        future: canOpenCamera(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return QrcodeReaderView(
                key: _qrViewKey,
                headerWidget: SafeArea(
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).cardColor,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                helpWidget: Text(dic['scan.help']!),
                onScan: onScan);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

enum QRCodeResultType { address, hex, rawData }

class QRCodeResult {
  QRCodeResult({this.type, this.address, this.hex, this.rawData});

  final QRCodeResultType? type;
  final QRCodeAddressResult? address;
  final String? hex;
  final String? rawData;
}

class QRCodeAddressResult {
  QRCodeAddressResult(this.rawData)
      : chainType = rawData[0],
        address = rawData[1],
        pubKey = rawData[2],
        name = rawData[3];

  final List<String> rawData;

  final String chainType;
  final String address;
  final String pubKey;
  final String name;
}
