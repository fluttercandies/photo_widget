import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class PickerDataProvider extends ChangeNotifier {
  List<AssetEntity> assetList = [];
  List<AssetPathEntity> pathList = [];
  bool isOrigin = false;

  void onRefreshPathEntity(List<AssetPathEntity> list) {
    this.pathList.clear();
    this.pathList.addAll(list);
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

class PickerPathProvider extends ChangeNotifier {
  List<AssetEntity> picked = [];

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
