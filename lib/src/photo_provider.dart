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
    this.maxNotifier.value = max;
  }

  /// Notification when max is modified.
  final maxNotifier = ValueNotifier(0);

  int get max => maxNotifier.value;
  set max(int value) => maxNotifier.value = value;

  final onPickMax = ChangeNotifier();

  /// The currently selected item.
  List<AssetEntity> picked = [];

  final isOriginNotifier =  ValueNotifier(false);

  bool get isOrigin => isOriginNotifier.value;

  set isOrigin(bool isOrigin) {
    isOriginNotifier.value = isOrigin;
  }

  /// Single-select mode, there are subtle differences between interaction and multiple selection.
  ///
  /// In single-select mode, when you click an unselected item, the old one is automatically cleared and the new one is selected.
  bool get singlePickMode => _singlePickMode;
  bool _singlePickMode = false;
  set singlePickMode(bool singlePickMode) {
    _singlePickMode = singlePickMode;
    if (singlePickMode) {
      maxNotifier.value = 1;
    }
  }

  final pickedNotifier = ValueNotifier<List<AssetEntity>>([]);

  void pickEntity(AssetEntity entity) {
    if (singlePickMode) {
      if (picked.contains(entity)) {
        picked.remove(entity);
      } else {
        picked.clear();
        picked.add(entity);
      }
    } else {
      if (picked.contains(entity)) {
        picked.remove(entity);
      } else {
        if (picked.length == max) {
          onPickMax.notifyListeners();
          return;
        }
        picked.add(entity);
      }
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
