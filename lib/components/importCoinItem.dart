import 'package:flutter/material.dart';

class ImportCoinItem extends StatefulWidget {
  ImportCoinItem(
      this.title, this.subtitle, this.balance, this.isSeleted, this.onPressed);
  final String title;
  final String subtitle;
  final String balance;
  final bool isSeleted;
  final Function onPressed;

  @override
  _ImportCoinItemState createState() => _ImportCoinItemState();
}

class _ImportCoinItemState extends State<ImportCoinItem> {
  bool _isHightLight = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
            onTapDown: (details) {
              setState(() {
                _isHightLight = true;
              });
            },
            onTapUp: (details) {
              setState(() {
                _isHightLight = false;
              });
            },
            onTapCancel: () {
              setState(() {
                _isHightLight = false;
              });
            },
            onTap: () {
              widget.onPressed();
            },
            child: Center(
              child: Container(
                  decoration: new BoxDecoration(
                    color: _isHightLight
                        ? Color.fromARGB(127, 255, 255, 255)
                        : Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(12, 12, 12, 12),
                        child: Image.asset(
                          'packages/polkawallet_ui/assets/images/dot.png',
                          width: 36,
                          height: 36,
                        ),
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width - 102,
                          margin: EdgeInsets.fromLTRB(0, 13, 12, 12),
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.title,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 51, 51, 51)),
                                  ),
                                  Visibility(
                                    child: Text(
                                      widget.balance,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 51, 51, 51)),
                                    ),
                                    visible: false,
                                  ),
                                ],
                              ),
                              Expanded(child: SizedBox()),
                              Container(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  widget.subtitle,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color:
                                          Color.fromARGB(255, 153, 153, 153)),
                                ),
                              )
                            ],
                          ))
                    ],
                  )),
            )));
  }
}
