// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_beautiful_checklist_exercise/data/database_repository.dart';

class SharedPreferencesRepository implements DatabaseRepository {
  final SharedPreferences? _prefs;

  const SharedPreferencesRepository(this._prefs);

  @override
  Future<int> getItemCount() async {
    return this._prefs?.getInt('itemCount') ?? 0;
  }

  @override
  Future<List<String>> getItems() async {
    List<String> items = this._prefs?.getStringList('items') ?? [];
    debugPrint('Geladene Items: $items');

    if (items.isEmpty) {
      return ['Keine Item Liste'];
    }
    return items;
  }

  // Reminder: Man kann Werte in einer sharded Pref Liste nicht mittels eines Index wie bei einer List oder Array ansprechen und somit keine Werte editieren, löschen oder hinzufügen.
  // Man muss die alte shared pref List erst in eine lokale Liste laden, diese nach Wunsch bearbeiten (add/edit/delete) und danach dann wieder unter demselben Namen komplett neu als shared pref Liste abspeichern (alte Liste mit neuer überschreiben)
  @override
  Future<void> addItem(String newValue) async {
    try {
      debugPrint('Value ist: $newValue');
      List<String> currentItemList = this._prefs?.getStringList('items') ?? [];

      if (newValue.isNotEmpty && !currentItemList.contains(newValue)) {
        currentItemList.add(newValue);
        await this._prefs?.setStringList('items', currentItemList);
        await this._prefs?.setInt('itemCount', currentItemList.length);
        debugPrint('Item gespeichert. Neue Liste: $currentItemList');
      }
    } catch (e) {
      debugPrint("Fehler beim Speichern des Items: $e");
    }
  }

  @override
  Future<void> deleteItem(int index) async {
    try {
      List<String> currentItemList = this._prefs?.getStringList('items') ?? [];

      if (index >= 0 && index < currentItemList.length) {
        currentItemList.removeAt(index);
        await this._prefs?.setStringList('items', currentItemList);
        await this._prefs?.setInt('itemCount', currentItemList.length);
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
      List<String> currentItemList = this._prefs?.getStringList('items') ?? [];

      if (index >= 0 &&
          index < currentItemList.length &&
          newItem.isNotEmpty &&
          !currentItemList.contains(newItem)) {
        currentItemList[index] = newItem;
        await this._prefs?.setStringList('items', currentItemList);
        debugPrint(
          'Item mit Index $index bearbeitet. Neue Liste: $currentItemList',
        );
      }
    } catch (e) {
      debugPrint("Fehler beim Bearbeiten des Items: $e");
    }
  }
}
