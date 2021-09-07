import 'package:flutter/material.dart';
import 'package:custom_switch_button/custom_switch_button.dart';

class SWitchButton extends StatelessWidget {
  final bool value;
  const SWitchButton({Key key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSwitchButton(
        indicatorWidth: 30,
        indicatorBorderRadius: 30,
        backgroundBorderRadius: 20,
        buttonHeight: 30,
        buttonWidth: 50,
        backgroundColor: value ? Colors.greenAccent : Colors.grey,
        checked: value,
        checkedColor: Colors.white,
        unCheckedColor: Colors.white,
        animationDuration: Duration(milliseconds: 200));
  }
}
