import 'package:flutter/material.dart';

class ImportCoinItem extends StatefulWidget {
  ImportCoinItem(this.title, this.subtitle, this.balance, this.isSeleted,
      this.position, this.onPressed);
  final String title;
  final String subtitle;
  final String balance;
  final bool isSeleted;
  final int position;
  final Function onPressed;

  @override
  _ImportCoinItemState createState() => _ImportCoinItemState();
}

class _ImportCoinItemState extends State<ImportCoinItem> {
  bool _isHightLight = false;

  String getIcon() {
    String icon = '';
    switch (widget.title) {
      case 'DOT':
        icon = 'packages/polkawallet_ui/assets/images/dot.png';
        break;
      case 'KSM':
        icon = 'packages/polkawallet_ui/assets/images/ksm.png';
        break;
      default:
        icon = '';
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
            onTap: () {
              widget.onPressed();
            },
            child: Center(
              child: Container(
                  child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: Image.asset(
                      getIcon(),
                      width: 36,
                      height: 36,
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width - 102,
                      decoration: new BoxDecoration(
                        color: Colors.red,
                      ),
                      margin: EdgeInsets.fromLTRB(0, 16, 12, 12),
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14,
                                    backgroundColor: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    color: widget.position > 3
                                        ? Color.fromARGB(255, 51, 51, 51)
                                        : Colors.white),
                              ),
                              Visibility(
                                child: Text(
                                  widget.balance,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: widget.position > 3
                                          ? Color.fromARGB(255, 51, 51, 51)
                                          : Colors.white),
                                ),
                                visible: false,
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.subtitle,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 10,
                                  backgroundColor: Colors.green,
                                  color: widget.position > 3
                                      ? Color.fromARGB(255, 51, 51, 51)
                                      : Colors.white),
                            ),
                          )
                        ],
                      ))
                ],
              )),
            )));
  }
}
