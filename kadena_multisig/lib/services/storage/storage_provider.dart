import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:kadena_multisig/services/storage/i_storage_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageProvider extends ChangeNotifier implements IStorageProvider {
  late SharedPreferences _prefs;

  StorageProvider({required SharedPreferences prefs}) {
    _prefs = prefs;
  }

  // Method to save a value with the given key
  @override
  Future<void> saveValue(String key, dynamic value) async {
    String jsonString = jsonEncode(value);
    await _prefs.setString(key, jsonString);
    notifyListeners();
  }

  // Method to retrieve the value for the given key and deserialize it using the provided function
  @override
  dynamic getValue(
    String key, {
    dynamic Function(Map<String, dynamic>)? deserializer,
  }) {
    String? jsonString = _prefs.getString(key);

    if (jsonString == null) {
      return null;
    }

    if (deserializer != null) {
      return deserializer(jsonDecode(jsonString));
    } else {
      return jsonDecode(jsonString);
    }
  }

  // Method to delete the value for the given key
  @override
  Future<void> deleteValue(String key) async {
    await _prefs.remove(key);
    notifyListeners();
  }

  // Method to clear all stored key-value pairs
  @override
  Future<void> clearStorage() async {
    await _prefs.clear();
    notifyListeners();
  }
}
