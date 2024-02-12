import 'package:attendance/data/interfaces/repository.dart';
import 'package:attendance/data/source/dummy_data_generator.dart';

import 'model/response.dart';

class DummyDataRepository implements HistoryRepository {
  final DummyDataGenerator source = DummyDataGenerator();

  @override
  Response getHistory(DateTime dateTime) {
    return source.getDummyData(dateTime);
  }
}
