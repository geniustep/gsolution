import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class PrefUpdate {
  static SharedPreferences? _preferences;

  static Future<void> _initPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static Future<void> addItem<T>({
    required String key,
    required T item,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
    required RxList<T> Function() getListFunction,
  }) async {
    await _initPreferences();
    List<T> currentList = await _getList<T>(key, fromJson);
    currentList.insert(0, item);
    await _updateList<T>(currentList, key, toJson);
    RxList<T> dynamicList = getListFunction();
    dynamicList.insert(0, item);
    dynamicList.refresh();
  }

  static Future<void> deleteItem<T>({
    required String key,
    int? id,
    bool Function(T)? matchCondition,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
    required RxList<T> Function() getListFunction,
  }) async {
    await _initPreferences();

    List<T> currentList = await _getList<T>(key, fromJson);

    if (id != null) {
      currentList.removeWhere((item) => (item as dynamic).id == id);
    } else if (matchCondition != null) {
      currentList.removeWhere(matchCondition);
    } else {
      throw Exception("Either 'id' or 'matchCondition' must be provided");
    }

    await _updateList<T>(currentList, key, toJson);

    RxList<T> dynamicList = getListFunction();
    if (id != null) {
      dynamicList.removeWhere((item) => (item as dynamic).id == id);
    } else if (matchCondition != null) {
      dynamicList.removeWhere(matchCondition);
    }
    dynamicList.refresh();
  }

  static Future<void> updateItem<T>({
    required String key,
    required T newItem,
    bool Function(T)? matchCondition,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
    required RxList<T> Function() getListFunction,
  }) async {
    await _initPreferences();

    List<T> currentList = await _getList<T>(key, fromJson);

    bool isUpdated = false;
    for (int i = 0; i < currentList.length; i++) {
      T item = currentList[i];
      if ((matchCondition != null && matchCondition(item)) ||
          ((item as dynamic).id == (newItem as dynamic).id)) {
        currentList[i] = newItem;
        isUpdated = true;
        break;
      }
    }

    if (!isUpdated) {
      throw Exception("Item to update not found.");
    }

    await _updateList<T>(currentList, key, toJson);

    RxList<T> dynamicList = getListFunction();
    for (int i = 0; i < dynamicList.length; i++) {
      T item = dynamicList[i];
      if ((matchCondition != null && matchCondition(item)) ||
          ((item as dynamic).id == (newItem as dynamic).id)) {
        dynamicList[i] = newItem;
        break;
      }
    }
    dynamicList.refresh();
  }

  static Future<List<T>> getList<T>({
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    await _initPreferences();
    return await _getList<T>(key, fromJson);
  }

  static Future<List<T>> _getList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    String? jsonString = _preferences?.getString(key);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> _updateList<T>(
    List<T> updatedList,
    String key,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    final jsonString =
        jsonEncode(updatedList.map((item) => toJson(item)).toList());
    await _preferences?.setString(key, jsonString);
  }
}
