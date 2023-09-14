abstract class IStorageManager {
  Future<T?> getValue<T>(String key);

  Future setValue(String key, dynamic value);

  void removeValue(String key);

  void clearAll();
}
