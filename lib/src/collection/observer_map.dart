import 'dart:collection';

class ObserverMap<K, V> with MapMixin<K, V> {
  final _map = <K, V>{};

  @override
  V operator [](Object key) {
    return _map[key];
  }

  @override
  void operator []=(K key, V value) {
    print("on map put $key");
    _map[key] = value;
  }

  @override
  void clear() {
    print("on map clear");
    _map.clear();
  }

  @override
  Iterable<K> get keys => _map.keys;

  @override
  V remove(Object key) {
    print("on map remove $key");
    return _map.remove(key);
  }
}
