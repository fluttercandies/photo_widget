import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

mixin PhotoDataProvider on ChangeNotifier {
  AssetPathEntity _current;

  AssetPathEntity get currentPath => _current;

  set currentPath(AssetPathEntity current) {
    if (_current != current) {
      _current = current;
      currentPathNotifier.value = current;
    }
  }

  final currentPathNotifier = ValueNotifier<AssetPathEntity>(null);

  Map<String, PickerPathCache> _cacheMap = {};

  final pathListNotifier = ValueNotifier<List<AssetPathEntity>>([]);
  List<AssetPathEntity> pathList = [];

  static int _defaultSort(
    AssetPathEntity a,
    AssetPathEntity b,
  ) {
    if (a.isAll) {
      return -1;
    }
    if (b.isAll) {
      return 1;
    }
    return 0;
  }

  void resetPathList(
    List<AssetPathEntity> list, {
    int defaultIndex = 0,
    int sortBy(
      AssetPathEntity a,
      AssetPathEntity b,
    ) = _defaultSort,
  }) {
    if (sortBy != null) {
      list.sort(sortBy);
    }
    this.pathList.clear();
    this.pathList.addAll(list);
    _cacheMap.clear();
    currentPath = list[defaultIndex];
    pathListNotifier.value = this.pathList;
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
  PickerDataProvider({List<AssetPathEntity> pathList, int max = 9}) {
    if (pathList != null && pathList.isNotEmpty) {
      this.pathList.addAll(pathList);
    }
    pickedNotifier.value = picked;
    this.max.value = max;
  }

  final max = ValueNotifier(0);

  List<AssetEntity> picked = [];
  bool isOrigin = false;

  final pickedNotifier = ValueNotifier<List<AssetEntity>>([]);

  void pickEntity(AssetEntity entity) {
    print(picked.contains(entity));
    if (picked.contains(entity)) {
      picked.remove(entity);
    } else {
      picked.add(entity);
    }
    pickedNotifier.value = picked;
    pickedNotifier.notifyListeners();
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
