import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

mixin PhotoDataProvider on ChangeNotifier {
  List<AssetPathEntity> pathList = [];

  AssetPathEntity _current;

  AssetPathEntity get current => _current;

  set current(AssetPathEntity current) {
    if (_current != current) {
      _current = current;
      currentPathNotifier.value = current;
    }
  }

  final currentPathNotifier = ValueNotifier<AssetPathEntity>(null);

  Map<String, PickerPathCache> _cacheMap = {};

  void resetPathList(List<AssetPathEntity> list, [int defaultIndex = 0]) {
    this.pathList.clear();
    this.pathList.addAll(list);
    _cacheMap.clear();
    current = list[defaultIndex];
    notifyListeners();
  }

  PickerPathCache getPickerCache(AssetPathEntity path) {
    var cache = _cacheMap[path.id];
    if (cache == null) {
      _cacheMap[path.id] = PickerPathCache(path: path);
    }
    return cache;
  }
}

class PickerDataProvider extends ChangeNotifier with PhotoDataProvider {
  PickerDataProvider({List<AssetPathEntity> pathList}) {
    if (pathList != null && pathList.isNotEmpty) {
      this.pathList.addAll(pathList);
    }
  }

  List<AssetEntity> picked = [];
  bool isOrigin = false;

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
