import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_beautiful_checklist_exercise/data/database_repository.dart';
import 'package:simple_beautiful_checklist_exercise/data/shared_preferences_repository.dart';
import 'package:simple_beautiful_checklist_exercise/src/app.dart';

void main() async {
  // Wird benötigt, um auf SharedPreferences zuzugreifen
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Reminder: Dem repository die shared preferences (prefs) als Parameter übergeben. Somit wird sichergestellt, dass alle shared preference Daten bei Initialisierung des repositories bereits vorhanden sind und Instanz-Methoden auf diese korrekt zugreifen und sie verarbeiten können.
  // Mit der Lösung aus dem vorigen Commit, wo die shared preferences IN der Repository Klasse selbst initialisiert wurden, musste jede Methode nochmal über einen getter die prefs einzeln aufrufen, um sicherzustellen, dass die Daten bei Methodenaufruf vorhanden sind. Das ist umständlich und die nun globale Initialisierung der shared prefs in der Main Methode effektiver und einfacher.
  final DatabaseRepository repository = SharedPreferencesRepository(prefs);

  runApp(App(repository: repository));
}
