import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:privateroom/screens/dashboard_screen/foreground_screen.dart';
import 'package:privateroom/screens/dashboard_screen/nav_bar_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  bool absorbPointer = false;
  AnimationController _animationController;

  void animateForward() {
    _animationController.forward();
  }

  void animateBackward() {
    _animationController.reverse();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 150,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        absorbPointer = true;
      }

      if (status == AnimationStatus.reverse) {
        absorbPointer = false;
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            NavBarScreen(
              onPressed: animateBackward,
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (ctx, _) {
                double x = _animationController.value;

                double translateValue = 180 * x;
                double scaleValue = 1 - 0.25 * x;
                double rotateYValue = -0.10 * x;
                double setEntryValue = -0.0005 * x;

                var transformMatrix = Matrix4.identity()
                  ..translate(translateValue)
                  ..scale(scaleValue)
                  ..rotateY(rotateYValue)
                  ..setEntry(3, 0, setEntryValue);

                return Transform(
                  alignment: Alignment.center,
                  transform: transformMatrix,
                  child: AbsorbPointer(
                    absorbing: absorbPointer,
                    child: ForegroundScreen(
                      navBarOnPressed: animateForward,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
