import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Function onpressButton;
  const AppButton({Key key, this.text, this.style, this.onpressButton})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressButton,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          text,
          style: style,
        ),
      ),
    );
  }
}
