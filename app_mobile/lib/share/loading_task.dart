import 'package:app_mobile/share/scale_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingTask extends StatelessWidget {
  final Widget child;
  final bool loading;

  const LoadingTask({Key key, this.child, this.loading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      child,
      loading
          ? Scaffold(
              backgroundColor: Colors.white38,
              body: Center(
                child: ScaleAnimation(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: SpinKitPouringHourGlass(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          : Container(),
    ]);
  }
}
