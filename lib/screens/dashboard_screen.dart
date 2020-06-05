import 'package:flutter/material.dart';
import 'package:privateroom/screens/drawing_screen/drawing_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: info != null ? Image.memory(info) : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var i = await Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => DrawingScreen(),
          ));

          setState(() {
            info = i;
          });
        },
      ),
    );
  }
}
