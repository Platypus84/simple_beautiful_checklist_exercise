import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_beautiful_checklist_exercise/data/database_repository.dart';

class SharedPreferencesRepository implements DatabaseRepository {
  SharedPreferences? _prefs;

  // Simulierte Datenbank mit einer Liste von Strings.
  // In einer echten App würden hier Daten aus einer Datenbank oder SharedPreferences geladen werden.

  Future<void> initSharedPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  @override
  Future<int> getItemCount() async {
    final preferences = await prefs;
    return preferences.getInt('itemCount') ?? 0;
  }

  @override
  Future<List<String>> getItems() async {
    final preferences = await prefs;
    List<String> items = preferences.getStringList('items') ?? [];
    debugPrint('Geladene Items: $items');

    if (items.isEmpty) {
      return ['Keine Item Liste'];
    }
    return items;
  }

  @override
  Future<void> addItem(String newValue) async {
    try {
      debugPrint('Value ist: $newValue');
      final preferences = await prefs;
      List<String> currentItemList = preferences.getStringList('items') ?? [];

      if (newValue.isNotEmpty && !currentItemList.contains(newValue)) {
        currentItemList.add(newValue);
        await preferences.setStringList('items', currentItemList);
        await preferences.setInt('itemCount', currentItemList.length);
        debugPrint('Item gespeichert. Neue Liste: $currentItemList');
      }
    } catch (e) {
      debugPrint("Fehler beim Speichern des Items: $e");
    }
  }

  @override
  Future<void> deleteItem(int index) async {
    try {
      final preferences = await prefs;
      List<String> currentItemList = preferences.getStringList('items') ?? [];

      if (index >= 0 && index < currentItemList.length) {
        currentItemList.removeAt(index);
        await preferences.setStringList('items', currentItemList);
        await preferences.setInt('itemCount', currentItemList.length);
        debugPrint(
          'Item an Index $index gelöscht. Neue Liste: $currentItemList',
        );
      }
    } catch (e) {
      debugPrint("Fehler beim Löschen des Items: $e");
    }
  }

  @override
  Future<void> editItem(int index, String newItem) async {
    try {
      final preferences = await prefs;
      List<String> currentItemList = preferences.getStringList('items') ?? [];

      if (index >= 0 &&
          index < currentItemList.length &&
          newItem.isNotEmpty &&
          !currentItemList.contains(newItem)) {
        currentItemList[index] = newItem;
        await preferences.setStringList('items', currentItemList);
        debugPrint(
          'Item mit Index $index bearbeitet. Neue Liste: $currentItemList',
        );
      }
    } catch (e) {
      debugPrint("Fehler beim Bearbeiten des Items: $e");
    }
  }
}
