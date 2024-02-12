import '../model/response.dart';

abstract interface class HistoryRepository {
  Response getHistory(DateTime dateTime);
}
