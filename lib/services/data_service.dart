import 'package:psx/models/psxUserInfo.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  List<PSXUserInfo> _psxUserInfo = [];

  factory DataService() {
    return _instance;
  }

  DataService._internal();

  List<PSXUserInfo> get psxUserInfo => _psxUserInfo;

  void setPsxUserInfo(List<PSXUserInfo> newList) {
    _psxUserInfo = newList;
  }

  void addPsxUserInfo(PSXUserInfo newItem) {
    _psxUserInfo.add(newItem);
  }

  List<PSXUserInfo> getItems() => _psxUserInfo;

  void removePsxUserInfo(PSXUserInfo item) {
    _psxUserInfo.remove(item);
  }

  void clearPsxUserInfo() {
    _psxUserInfo.clear();
  }

  sendToUI(PSXUserInfo psxUserInfoInbound) {
    return _psxUserInfo.firstWhere(
      (userInfo) => userInfo.id == psxUserInfoInbound.id,
      orElse: () =>
          PSXUserInfo(id: -1, accountName: '', login: '', password: ''),
    );
  }
}
