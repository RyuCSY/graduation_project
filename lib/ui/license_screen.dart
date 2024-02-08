import 'package:flutter/material.dart';

class LicenseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white,
              Colors.cyanAccent,
              Colors.cyan,
              Colors.lightBlue,
              Colors.blue,
              Colors.blueGrey,
            ],
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('오픈 라이선스', style: TextStyle(color: Colors.white)),
        ),
        body: Text('오픈 라이선스 화면'),
      ),
    ]);
  }
}
