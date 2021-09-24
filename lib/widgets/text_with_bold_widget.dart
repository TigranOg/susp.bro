import 'package:flutter/material.dart';

class TextWithBoldWidget extends StatelessWidget {
  const TextWithBoldWidget({
    Key? key,
    required this.text,
    required this.textBold,
    required this.boldFirst,
  }) : super(key: key);

  final String text;
  final String textBold;
  final bool boldFirst;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: new TextSpan(
        children: <TextSpan>[
          new TextSpan(
            text: !boldFirst ? '$text ' : '$textBold ',
            style: new TextStyle(fontWeight: !boldFirst ? FontWeight.normal : FontWeight.bold, color: Colors.white),
          ),
          new TextSpan(
            text: !boldFirst ? '$textBold' : '$text',
            style: new TextStyle(fontWeight: !boldFirst ? FontWeight.bold : FontWeight.normal, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
