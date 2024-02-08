import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
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
          title: const Text('출퇴근 내역', style: TextStyle(color: Colors.white)),
        ),
        body: Text('내역 화면'),
      ),
    ]);
  }
}
