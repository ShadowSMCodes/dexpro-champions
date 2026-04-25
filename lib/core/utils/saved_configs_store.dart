import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum SaveAppendResult { saved, duplicate, failed }

class SavedConfigsStore {
  const SavedConfigsStore._();

  static Future<List<Map<String, dynamic>>> load(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final String? rawJson = prefs.getString(key);
      if (rawJson != null && rawJson.isNotEmpty) {
        final dynamic decoded = jsonDecode(rawJson);
        if (decoded is List) {
          return decoded
              .whereType<Map>()
              .map((Map item) => Map<String, dynamic>.from(item))
              .toList(growable: false);
        }
      }

      final List<String> legacyItems = prefs.getStringList(key) ?? <String>[];
      return legacyItems
          .map((String item) => jsonDecode(item))
          .whereType<Map>()
          .map((Map item) => Map<String, dynamic>.from(item))
          .toList(growable: false);
    } catch (_) {
      return <Map<String, dynamic>>[];
    }
  }

  static Future<SaveAppendResult> append(
    String key,
    Map<String, dynamic> value,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final List<Map<String, dynamic>> items = await load(key);
      final String encoded = _canonicalJson(value);
      final Set<String> existing = items.map(_canonicalJson).toSet();

      if (existing.contains(encoded)) {
        return SaveAppendResult.duplicate;
      }

      final List<Map<String, dynamic>> updatedItems = <Map<String, dynamic>>[
        ...items,
        value,
      ];
      final bool success = await prefs.setString(key, jsonEncode(updatedItems));
      return success ? SaveAppendResult.saved : SaveAppendResult.failed;
    } catch (_) {
      return SaveAppendResult.failed;
    }
  }

  static Future<bool> saveAll(
    String key,
    List<Map<String, dynamic>> values,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      return prefs.setString(key, jsonEncode(values));
    } catch (_) {
      return false;
    }
  }

  static Future<bool> removeAt(String key, int index) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final List<Map<String, dynamic>> items = await load(key);
      if (index < 0 || index >= items.length) {
        return false;
      }
      items.removeAt(index);
      return prefs.setString(key, jsonEncode(items));
    } catch (_) {
      return false;
    }
  }

  static String _canonicalJson(Map<String, dynamic> value) {
    return jsonEncode(_normalize(value));
  }

  static dynamic _normalize(dynamic value) {
    if (value is Map) {
      final List<MapEntry<String, dynamic>> entries =
          value.entries
              .map(
                (MapEntry<dynamic, dynamic> entry) => MapEntry<String, dynamic>(
                  entry.key.toString(),
                  _normalize(entry.value),
                ),
              )
              .toList(growable: false)
            ..sort((a, b) => a.key.compareTo(b.key));
      return <String, dynamic>{
        for (final entry in entries) entry.key: entry.value,
      };
    }
    if (value is List) {
      return value.map(_normalize).toList(growable: false);
    }
    return value;
  }
}
