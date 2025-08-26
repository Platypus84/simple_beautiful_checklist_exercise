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

  @override
  Future<void> addItem(String newValue) async {
    try {
      debugPrint('Value ist: $newValue');
      List<String> currentItemList = _prefs?.getStringList('items') ?? [];
      if (newValue.isNotEmpty && !currentItemList.contains(newValue)) {
        currentItemList.add(newValue);
        await _prefs?.setStringList('items', currentItemList);
        await _prefs?.setInt('itemCount', currentItemList.length);
      }
    } catch (e) {
      debugPrint("Fehler beim Speichern des Items: $e");
    }
  }

  @override
  Future<int> getItemCount() async {
    return _prefs?.getInt('itemCount') ?? 0;
  }

  @override
  Future<List<String>> getItems() async {
    return _prefs?.getStringList('items') ?? ['No Item List'];
  }

  @override
  Future<void> deleteItem(int index) async {
    await _prefs?.remove('items'[index]);
  }

  @override
  Future<void> editItem(int index, String newItem) async {
    // make sure not empty and not same as other
    if (newItem.isNotEmpty &&
        !_prefs!.getStringList('items')!.contains(newItem)) {
      await _prefs?.setStringList('items'[index], [newItem]);
    }
  }
}
