import 'package:flutter/material.dart';

class AppTextFile extends StatelessWidget {
  final String lableTextFile;
  final String hintTextFile;
  final Widget iconFile;
  final TextEditingController textController;
  final Function onChangefunction;
  final String errorText;

  const AppTextFile(
      {Key key,
      this.lableTextFile,
      this.hintTextFile,
      this.iconFile,
      this.textController,
      this.onChangefunction,
      this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: textController,
        onChanged: onChangefunction,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: lableTextFile,
          hintText: hintTextFile,
          prefixIcon: iconFile,
          errorText: errorText,
        ),
      ),
    );
  }
}
