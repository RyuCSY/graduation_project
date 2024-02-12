import 'package:flutter/material.dart';

class DaysItem {
  final HistoryType type;
  String txt;
  final bool isInMonth;
  DetailItem attendance = DetailItem('출근 ');
  DetailItem quitting = DetailItem('퇴근 ');

  DaysItem(this.type, this.txt,
      {this.isInMonth = true, String? strAtt, String? strQuit}) {
    Color attColor = (strAtt == null) ? Colors.red : Colors.black;
    Color quitColor = (strQuit == null) ? Colors.red : Colors.black;

    switch (type) {
      case HistoryType.late:
        attColor = Colors.purpleAccent;
        break;
      case HistoryType.early:
        quitColor = Colors.grey;
        break;
      case HistoryType.overtime:
        quitColor = Colors.orangeAccent;
        break;

      default:
        break;
    }

    attendance = DetailItem(attendance.name, time: strAtt, txtColor: attColor);
    quitting = DetailItem(quitting.name, time: strQuit, txtColor: quitColor);
  }
}

class DetailItem {
  final String name;
  final String? time;
  final Color txtColor;

  DetailItem(this.name, {this.time, this.txtColor = Colors.black});
}

enum HistoryType {
  normal('정상', Colors.green),
  late('지각', Colors.purpleAccent),
  early('조퇴', Colors.grey),
  overtime('야근', Colors.orangeAccent),
  absent('결근', Colors.red),
  date('', Colors.transparent),
  saturday('', Colors.blue),
  sunday('', Colors.red);

  final String typeName;
  final Color color;

  const HistoryType(this.typeName, this.color);
}
