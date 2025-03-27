import 'package:flutter/material.dart';

import '../../model/ride/ride_pref.dart';
import '../../repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  final List<RidePreference> _pastPreferences = [];

  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    // Fetch past preferences from the repository
    _pastPreferences.addAll(repository.getPastPreferences());
  }

  RidePreference? get currentPreference => _currentPreference;

  void setCurrentPreference(RidePreference pref) {
    // Process only if the new preference is not equal to the current one
    if (_currentPreference != pref) {
      //Update the current preference
      _currentPreference = pref;

      // Update the history (ensure exclusivity)
      _updatePreference(pref);

      // Notify listeners
      notifyListeners();
    }
  }

  void _updatePreference(RidePreference preference) {
    // Remove the preference if it already exists in the history
    _pastPreferences.removeWhere((p) => p == preference);

    // Add the new preference to the history
    _pastPreferences.add(preference);

    // Save the updated preference to the repository
    repository.addPreference(preference);
  }

  // History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();
}
