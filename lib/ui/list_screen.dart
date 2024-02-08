import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const double font_size = 16;

class ListScreen extends StatefulWidget {
  var current = DateTime.now();
  var nextVisibility = false;
  DaysItem? selectdItem;

  ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('출퇴근 내역', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Container(
            height: 44,
            decoration: BoxDecoration(color: Colors.black12),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              GestureDetector(onTap: () => _previousClick(), child: Container(margin: EdgeInsets.only(left: 22), child: Icon(Icons.arrow_circle_left_rounded))),
              Text(DateFormat('yyyy년 MM월').format(widget.current), style: TextStyle(color: Colors.black, fontSize: font_size)),
              Visibility(
                  visible: widget.nextVisibility,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: GestureDetector(
                      onTap: () => _nextClick(), child: Container(margin: EdgeInsets.only(right: 22), child: Icon(Icons.arrow_circle_right_rounded)))),
            ]),
          ),
          Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                children: _getCalendar(widget.current, <int>{1, 3, 5})
                    .map((item) => InkWell(
                          onTap: () {
                            setState(() {
                              widget.selectdItem = item;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(8),
                            decoration: item.getBoxDecoration(),
                            child: Text(
                              item.txt,
                              style: item.getTextStyle(),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              (widget.selectdItem == null)
                  ? Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(bottom: 44),
                      child: Text(
                        '확인할 날짜를 선택하세요.',
                        style: TextStyle(fontSize: font_size, color: Colors.black54),
                      ))
                  : Container(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Container(padding: EdgeInsets.only(right: 22), child: Text('2023.11.11 내역')),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 55, vertical: 33),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(11),
                            child: widget.selectdItem?.getDetailWidget(),
                          ),
                        )
                      ]),
                    ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 33),
        height: 77,
        child: Row(
            children: [
          DaysItem(DayType.normal, '22'),
          DaysItem(DayType.late, '22'),
          DaysItem(DayType.early, '22'),
          DaysItem(DayType.overtime, '22'),
          DaysItem(DayType.absent, '22'),
        ]
                .map((item) => Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 44,
                            height: 44,
                            decoration: item.getBoxDecoration(),
                            child: Text(
                              item.txt,
                              style: TextStyle(color: Colors.black, fontSize: font_size),
                            ),
                          ),
                          Text(
                            item.type.name,
                            style: TextStyle(color: Colors.black, fontSize: font_size),
                          ),
                        ],
                      ),
                    ))
                .toList()),
      ),
    );
  }

  void _move(DateTime current) {
    final now = DateTime.now();
    final isSame = (current.year == now.year) && (current.month == now.month);

    widget.current = current;
    widget.nextVisibility = !isSame;
    widget.selectdItem = null;
  }

  void _nextClick() {
    setState(() {
      _move(DateTime(widget.current.year, widget.current.month + 1, 1));
    });
  }

  void _previousClick() {
    setState(() {
      _move(DateTime(widget.current.year, widget.current.month - 1, 1));
    });
  }
}

List<DaysItem> _getCalendar(DateTime calendar, Set<int> set) {
  final List<DaysItem> ret = [];

  // 이번달 시작일의 요일.
  final int firstInWeek = DateTime(calendar.year, calendar.month, 1).weekday;
  // 지난달의 마지막 일자.
  int lastForPreviousMonth = DateTime(calendar.year, calendar.month, 0).day;
  // 이달의 마지막 일자.
  int lastDay = DateTime(calendar.year, calendar.month + 1, 0).day;

  final week = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  for (var i = 0; i < week.length; i++) {
    DayType type = switch (i) {
      0 => DayType.sunday,
      6 => DayType.saturday,
      _ => DayType.date,
    };

    ret.add(DaysItem(type, week[i]));
  }

  for (int i = firstInWeek - 1; i >= 0; i--) {
    DaysItem day = DaysItem(DayType.date, '${lastForPreviousMonth - i}', isInMonth: false);
    ret.add(day);
  }
  for (int i = 1; i <= lastDay; i++) {
//    day.setWork(set.contains(i));
    final type;
    switch (Random().nextInt(7)) {
      case 0:
      case 1:
      case 2:
      case 3:
      case 4:
        type = DayType.normal;
      default:
        type = DayType.values[Random().nextInt(6)];
    }
    final week = DateTime(calendar.year, calendar.month, i).weekday;
    ret.add((week == DateTime.sunday || week == DateTime.saturday) ? DaysItem(DayType.date, '${i}') : DaysItem(type, '${i}'));
  }

  int next = 1;

  for (int i = DateTime(calendar.year, calendar.month + 1, 1).weekday; i < 7; i++) {
    DaysItem day = DaysItem(DayType.date, '${next++}', isInMonth: false);
    ret.add(day);
  }

  return ret;
}

class DetailItem {
  final String name;
  final String? time;

  Color get txtColor => (this.time == null) ? Colors.red : Colors.black;

  DetailItem(this.name, {this.time});
}

class DaysItem {
  final DayType type;
  final String txt;
  final bool isInMonth;
  final String? inTime;
  final String? outTime;

  DaysItem(this.type, this.txt, {this.isInMonth = true, this.inTime, this.outTime});

  TextStyle getTextStyle() {
    Color color = switch (type) {
      DayType.sunday => Colors.red,
      DayType.saturday => Colors.blue,
      _ => isInMonth ? Colors.black : Colors.black12,
    };
    return TextStyle(fontSize: font_size, color: color);
  }

  BoxDecoration? getBoxDecoration() {
    switch (type) {
      case DayType.saturday:
      case DayType.sunday:
      case DayType.date:
        return null;
      case DayType.normal:
        return BoxDecoration(border: Border(bottom: BorderSide(color: type.color)));
      default:
        return BoxDecoration(shape: BoxShape.circle, color: type.color);
    }
  }

  Widget getDetailWidget() {
    Color txtColor = switch (type) {
      DayType.normal => Colors.grey,
      DayType.saturday => Colors.blue,
      _ => isInMonth ? Colors.black : Colors.black12,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [DetailItem('출근 : ', time: '07:05'), null, DetailItem('퇴근  : ', time: '17:05')]
          .map((item) => (item == null)
              ? Container(
                  height: 22.0,
                  width: 1.5,
                  color: Colors.grey.withOpacity(0.33),
                )
              : Row(
                  children: [
                    Container(
                      child: Text(
                        item.name,
                        style: TextStyle(color: item.txtColor),
                      ),
                    ),
                    Text(
                      item.time ?? 'N/A',
                      style: TextStyle(color: item.txtColor),
                    ),
                  ],
                ))
          .toList(),
    );
  }
}

enum DayType {
  normal('정상', Colors.green),
  late('지각', Colors.purpleAccent),
  early('조퇴', Colors.grey),
  overtime('야근', Colors.orangeAccent),
  absent('결근', Colors.red),
  date('', Colors.transparent),
  saturday('', Colors.blue),
  sunday('', Colors.red);

  final String name;
  final Color color;

  const DayType(this.name, this.color);
}
