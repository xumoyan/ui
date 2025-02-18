import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_ui/utils/index.dart';

class JumpToBrowserLink extends StatefulWidget {
  JumpToBrowserLink(this.url, {this.text, this.mainAxisAlignment, this.color});

  final String? text;
  final String url;
  final MainAxisAlignment? mainAxisAlignment;
  final Color? color;

  @override
  _JumpToBrowserLinkState createState() => _JumpToBrowserLinkState();
}

class _JumpToBrowserLinkState extends State<JumpToBrowserLink> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              widget.mainAxisAlignment ?? MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 4),
              child: Text(
                widget.text ?? widget.url,
                style: TextStyle(
                    color: widget.color ?? Theme.of(context).primaryColor,
                    fontSize: 14),
              ),
            ),
            Icon(Icons.open_in_new,
                size: 14, color: widget.color ?? Theme.of(context).primaryColor)
          ],
        ),
        onTap: () {
          UI.launchURL(widget.url);
        });
  }
}
