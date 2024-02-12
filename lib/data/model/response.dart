import 'days_item.dart';

class Response {
  Map<int, DaysItem> data;
  List<DaysItem> summary;

  Response(this.data, this.summary);

  Response.empty()
      : this.data = {},
        this.summary = [];
}
