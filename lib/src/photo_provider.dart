import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class PickerDataProvider extends ChangeNotifier {
  PickerDataProvider({List<AssetPathEntity> pathList}) {
    if (pathList != null && pathList.isNotEmpty) {
      this.pathList.addAll(pathList);
    }
  }

  List<AssetPathEntity> pathList = [];
  List<AssetEntity> picked = [];
  bool isOrigin = false;

  Map<String, PickerPathCache> _cacheMap = {};

  void pickEntity(AssetEntity entity) {
    print(picked.contains(entity));
    if (picked.contains(entity)) {
      picked.remove(entity);
    } else {
      picked.add(entity);
    }
    notifyListeners();
  }

  int pickIndex(AssetEntity entity) {
    return picked.indexOf(entity);
  }

  void resetPathList(List<AssetPathEntity> list) {
    this.pathList.clear();
    this.pathList.addAll(list);
    _cacheMap.clear();
    notifyListeners();
  }

  PickerPathCache getPickerCache(AssetPathEntity path) {
    var cache = _cacheMap[path.id];
    if (cache == null) {
      _cacheMap[path.id] = PickerPathCache(path: path);
    }
    return cache;
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

class PickerPathCache {
  final AssetPathEntity path;

  Map<int, AssetEntity> map = {};

  PickerPathCache({
    @required this.path,
  });

  void cache(int index, AssetEntity entity) {
    map[index] = entity;
  }

  AssetEntity entity(int index) {
    return map[index];
  }
}
