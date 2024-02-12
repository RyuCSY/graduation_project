import 'dart:math';

import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

import '../model/days_item.dart';
import '../model/response.dart';

class DummyDataGenerator {
  static final Map<String, Response> dummyCache = {};

  Response getDummyData(DateTime dateTime) {
    final strDate = DateFormat('yyyyMM').format(dateTime);
    var retVal = (dummyCache.containsKey(strDate)) ? dummyCache[strDate]! : _genDummyData(dateTime);
    return retVal;
  }

  Response _genDummyData(DateTime dateTime) {
    final summaryList = [
      DaysItem(HistoryType.normal, '0'),
      DaysItem(HistoryType.late, '0'),
      DaysItem(HistoryType.early, '0'),
      DaysItem(HistoryType.overtime, '0'),
      DaysItem(HistoryType.absent, '0'),
    ];

    Map<int, DaysItem> map = {};

    var now = DateTime.now();

    bool isSame = (now.year == dateTime.year) && (now.month == dateTime.month);
    int len = (isSame) ? now.day - 1 : DateTime(dateTime.year, dateTime.month + 1, 0).day;

    final ran = Random();

    for (int i = 1; i <= len; i++) {
      HistoryType type;
      String? strAtt;
      String? strQuit;

      int week = DateTime(dateTime.year, dateTime.month, i).weekday;
      //dateTime.add(const Duration(days: 1)).weekday;

      if (week == DateTime.sunday || week == DateTime.saturday) {
        type = HistoryType.date;
      } else {
        switch (ran.nextInt(10)) {
          case 0:
          case 1:
            type = HistoryType.values[ran.nextInt(5)];
            break;
          default:
            type = HistoryType.normal;
            break;
        }

        switch (type) {
          case HistoryType.normal:
            strAtt = '07:${sprintf('%02d', [ran.nextInt(29) + 30])}';
            strQuit = '17:${sprintf('%02d', [ran.nextInt(11)])}';
            break;
          case HistoryType.late:
            strAtt = '${sprintf('%02d', [ran.nextInt(3) + 8])}:${sprintf('%02d', [ran.nextInt(29) + 30])}';
            strQuit = '17:${sprintf('%02d', [ran.nextInt(11)])}';
            break;
          case HistoryType.early:
            strAtt = '07:${sprintf('%02d', [ran.nextInt(29) + 30])}';
            strQuit = '${sprintf('%02d', [ran.nextInt(3) + 11])}:${sprintf('%02d', [ran.nextInt(11)])}';
            break;
          case HistoryType.overtime:
            strAtt = '07:${sprintf('%02d', [ran.nextInt(29) + 30])}';
            strQuit = '${sprintf('%02d', [ran.nextInt(3) + 18])}:${sprintf('%02d', [ran.nextInt(11)])}';
            break;

          default:
            break;
        }
      }

      map[i] = DaysItem(type, '$i', strAtt: strAtt, strQuit: strQuit);

      summaryList.forEach((element) {
        if (element.type == type) {
          element.txt = '${int.parse(element.txt) + 1}';
        }
      });
    }

    final strDate = DateFormat('yyyyMM').format(dateTime);

    Response retVal = Response(map, summaryList);

    dummyCache[strDate] = retVal;
    return retVal;
  }
}
