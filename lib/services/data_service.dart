import 'package:psx/models/psxUserInfo.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  List<PSXUserInfo> items = [];

  factory DataService() {
    return _instance;
  }

  DataService._internal();

  void populateItems(List<PSXUserInfo> newItems) {
    items = newItems;
  }

  List<PSXUserInfo> getItems() {
    return items;
  }
}
