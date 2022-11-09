//for accessing shared preferences
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/play_state.dart';

class SharedPref {
  static final SharedPref _apis = SharedPref._internal();
  factory SharedPref() => _apis;

  SharedPref._internal();

  //single object of pref
  static late SharedPreferences _pref;

  static Future<void> initPref() async {
    _pref = await SharedPreferences.getInstance();
  }

  // get current turn (if available)
  static PlayState get currentTurn =>
      _pref.getString('currentTurn') == PlayState.x.name
          ? PlayState.x
          : PlayState.o;

  //set current player turn
  static void setCurrentTurn(PlayState currentTurn) async {
    await _pref.setString('currentTurn', currentTurn.name);
  }

  // get win status (if available)
  static bool get isWinned => _pref.getBool('isWinned') ?? false;

  //set win status
  static void setIsWinned(bool isWinned) async {
    await _pref.setBool('isWinned', isWinned);
  }

  // get game draw status (if available)
  static bool get isDraw => _pref.getBool('isDraw') ?? false;

  //set game draw status
  static void setGameDraw(bool isDraw) async {
    await _pref.setBool('isDraw', isDraw);
  }

  static Future<bool> storePlayStateList(List<PlayState> list) async {
    // Obtain shared preferences.
    final pref = await SharedPreferences.getInstance();

    final listToStore = list.map((e) => e.name).toList();
    log('listToStore: $listToStore');

    return await pref.setStringList('list', listToStore);
  }

  static List<PlayState> loadPlayStateList() {
    final data = _pref.getStringList('list');
    log('data: $data');
    if (data != null) {
      //return list of stored play states
      return data.map((e) {
        switch (e) {
          case 'x':
            return PlayState.x;

          case 'o':
            return PlayState.o;

          default:
            return PlayState.none;
        }
      }).toList();
    }
    return List.filled(9, PlayState.none);
  }
}
