import 'package:attendance/data/dummy_data_repository.dart';
import 'package:attendance/data/model/response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

import '../data/interfaces/repository.dart';
import '../data/model/days_item.dart';

const double fontSize = 16;

class HistoryScreen extends StatefulWidget {
  final HistoryRepository repository = DummyDataRepository();

  var current = DateTime.now();
  var nextVisibility = false;

  DaysItem? selectedItem;

  Response historyData = Response.empty();

  HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    widget.historyData = widget.repository.getHistory(widget.current);
  }

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
            decoration: const BoxDecoration(color: Colors.black12),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () => _previousClick(),
                      child: Container(
                          margin: const EdgeInsets.only(left: 22),
                          child: const Icon(Icons.arrow_circle_left_rounded))),
                  Text(DateFormat('yyyy년 MM월').format(widget.current),
                      style: const TextStyle(
                          color: Colors.black, fontSize: fontSize)),
                  Visibility(
                      visible: widget.nextVisibility,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: GestureDetector(
                          onTap: () => _nextClick(),
                          child: Container(
                              margin: const EdgeInsets.only(right: 22),
                              child: const Icon(
                                  Icons.arrow_circle_right_rounded)))),
                ]),
          ),
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GridView.count(
                    crossAxisCount: 7,
                    shrinkWrap: true,
                    children:
                        _getCalendar(widget.current, widget.historyData.data)
                            .map((item) => InkWell(
                                  onTap: () {
                                    setState(() {
                                      widget.selectedItem =
                                          (item.type == HistoryType.date)
                                              ? null
                                              : item;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.all(8),
                                    decoration: getBoxDecoration(item),
                                    child: Text(
                                      item.txt,
                                      style: getTextStyle(item),
                                    ),
                                  ),
                                ))
                            .toList(),
                  ),
                  (widget.selectedItem == null)
                      ? Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(bottom: 44),
                              child: const Text(
                                '확인할 날짜를 선택하세요.',
                                style: TextStyle(
                                    fontSize: fontSize, color: Colors.black54),
                              )),
                        )
                      : Expanded(
                          child: Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.only(right: 22),
                                      child: Text(
                                          '${DateFormat('yyyy.MM').format(widget.current)}.${sprintf('%02d', [
                                            int.parse(widget.selectedItem!.txt)
                                          ])} 내역')),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 55, vertical: 33),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(11),
                                      child:
                                          getDetailWidget(widget.selectedItem!),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                ]),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 33),
        height: 77,
        child: Row(
            children: widget.historyData.summary
                .map((item) => Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 44,
                            height: 44,
                            decoration: getBoxDecoration(item),
                            child: Text(
                              item.txt,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: fontSize),
                            ),
                          ),
                          Text(
                            item.type.typeName,
                            style: const TextStyle(
                                color: Colors.black, fontSize: fontSize),
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
    widget.historyData = widget.repository.getHistory(widget.current);
    widget.nextVisibility = !isSame;
    widget.selectedItem = null;
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

List<DaysItem> _getCalendar(DateTime calendar, Map<int, DaysItem> historyMap) {
  final List<DaysItem> ret = [];

  // 이번달 시작일의 요일.
  final int firstInWeek = DateTime(calendar.year, calendar.month, 1).weekday;
  // 지난달의 마지막 일자.
  int lastForPreviousMonth = DateTime(calendar.year, calendar.month, 0).day;
  // 이달의 마지막 일자.
  int lastDay = DateTime(calendar.year, calendar.month + 1, 0).day;

  final week = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  for (var i = 0; i < week.length; i++) {
    HistoryType type = switch (i) {
      0 => HistoryType.sunday,
      6 => HistoryType.saturday,
      _ => HistoryType.date,
    };

    ret.add(DaysItem(type, week[i]));
  }

  for (int i = firstInWeek - 1; i >= 0; i--) {
    DaysItem day = DaysItem(HistoryType.date, '${lastForPreviousMonth - i}',
        isInMonth: false);
    ret.add(day);
  }
  for (int i = 1; i <= lastDay; i++) {
//    day.setWork(set.contains(i));

    final historyItem = historyMap[i];
    final type = historyItem?.type ?? HistoryType.date;

    final week = DateTime(calendar.year, calendar.month, i).weekday;
    ret.add((week == DateTime.sunday || week == DateTime.saturday)
        ? DaysItem(HistoryType.date, '${i}')
        : historyItem ?? DaysItem(type, '${i}'));
  }

  int next = 1;

  for (int i = DateTime(calendar.year, calendar.month + 1, 1).weekday;
      i < 7;
      i++) {
    DaysItem day = DaysItem(HistoryType.date, '${next++}', isInMonth: false);
    ret.add(day);
  }

  return ret;
}

TextStyle getTextStyle(DaysItem item) {
  Color color = switch (item.type) {
    HistoryType.sunday => Colors.red,
    HistoryType.saturday => Colors.blue,
    _ => item.isInMonth ? Colors.black : Colors.black12,
  };
  return TextStyle(fontSize: fontSize, color: color);
}

BoxDecoration? getBoxDecoration(DaysItem item) {
  switch (item.type) {
    case HistoryType.saturday:
    case HistoryType.sunday:
    case HistoryType.date:
      return null;
    case HistoryType.normal:
      return BoxDecoration(
          border: Border(bottom: BorderSide(color: item.type.color)));
    default:
      return BoxDecoration(shape: BoxShape.circle, color: item.type.color);
  }
}

Widget getDetailWidget(DaysItem item) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [item.attendance, null, item.quitting]
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
