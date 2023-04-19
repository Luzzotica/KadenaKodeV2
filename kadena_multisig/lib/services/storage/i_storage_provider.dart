import 'package:flutter/foundation.dart';

abstract class IStorageProvider extends ChangeNotifier {
  /// Method to save a value with the given key
  Future<void> saveValue(String key, dynamic value);

  /// Method to retrieve the value for the given key and deserialize it using the provided function
  dynamic getValue(
    String key, {
    dynamic Function(Map<String, dynamic>)? deserializer,
  });

  /// Method to delete the value for the given key
  Future<void> deleteValue(String key);

  /// Method to clear all stored key-value pairs
  Future<void> clearStorage();
}
