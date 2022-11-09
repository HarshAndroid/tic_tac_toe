import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';

import '../helper/shared_pref.dart';
import '../main.dart';
import '../models/play_state.dart';
import '../widgets/board_tile.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late List<PlayState> _playStates;
  PlayState _currentTurn = PlayState.o;
  bool _isWinned = false, _isDraw = false;

  @override
  void initState() {
    super.initState();
    //loading previous state of game
    _playStates = SharedPref.loadPlayStateList();
    _currentTurn = SharedPref.currentTurn;
    _isWinned = SharedPref.isWinned;
    _isDraw = SharedPref.isDraw;

    //for storing state of game
    SystemChannels.lifecycle.setMessageHandler((message) {
      log(message.toString());
      if (message != null) {
        try {
          if (message.contains('paused')) {
            log('State: Paused');
            SharedPref.setCurrentTurn(_currentTurn);
            SharedPref.storePlayStateList(_playStates);
            SharedPref.setGameDraw(_isDraw);
            SharedPref.setIsWinned(_isWinned);
          }
        } catch (e) {
          log(e.toString());
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Tic Tac Toe')),

        //replay or restart game button
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            onPressed: () {
              _currentTurn = PlayState.o;
              _isWinned = false;
              _isDraw = false;
              _playStates = List.filled(9, PlayState.none);
              setState(() {});
            },
            child: const Icon(Icons.replay),
          ),
        ),
        body: Column(
          children: [
            //for adding some space
            SizedBox(height: mq.height * .05),

            //for showing the turn (who is playing)
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    minimumSize: Size(mq.width * .6, mq.height * .06),
                    elevation: 0),
                child: Text(
                  _isDraw && _isWinned == false
                      ? 'Game Draw'
                      : _isWinned
                          ? 'Game Over'
                          : "IT'S ${_currentTurn.name.toUpperCase()} TURN",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.normal),
                )),

            //for adding some space
            SizedBox(height: mq.height * .04),

            //center board for playing game
            _ticTacToeBoard(context),

            //for adding some space
            SizedBox(height: mq.height * .04),

            //for showing the turn (who is playing)

            AnimatedOpacity(
              opacity: _isWinned || _isDraw ? 1 : 0,
              duration: const Duration(milliseconds: 1500),
              child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: Size(mq.width * .8, mq.height * .06),
                      elevation: 0),
                  icon: Icon(
                      _isDraw && _isWinned == false
                          ? Icons.replay
                          : Icons.celebration_rounded,
                      size: 35),
                  label: Text(
                    _isDraw && _isWinned == false
                        ? 'Tap to Play Again'
                        : ' Winner: Player ${_currentTurn.name.toUpperCase()}',
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.normal),
                  )),
            ),
          ],
        ));
  }

  Widget _ticTacToeBoard(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemCount: _playStates.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 8, crossAxisCount: 3, mainAxisSpacing: 8),
      itemBuilder: (context, index) => BoardTile(
        playState: _playStates[index],
        onPressed: () {
          if (!_isWinned) _onTileClicked(index);
        },
      ),
    );
  }

  _onTileClicked(int index) {
    if (_playStates[index] == PlayState.none) {
      //beep sound
      FlutterBeep.beep();

      setState(() => _playStates[index] = _currentTurn);
      final val = _findWinner();
      if (val != null) {
        //for now a system sound is played on success (but any custom sound can be played)
        FlutterBeep.playSysSound(AndroidSoundIDs.TONE_SUP_CONFIRM);
        setState(() {
          _isWinned = true;
        });
      } else {
        _currentTurn = _currentTurn == PlayState.x ? PlayState.o : PlayState.x;
      }
      if (!_playStates.contains(PlayState.none)) {
        FlutterBeep.playSysSound(AndroidSoundIDs.TONE_SUP_CONFIRM);
        setState(() {
          _isDraw = true;
        });
      }
    } else {
      //beep sound for failure
      FlutterBeep.beep(false);
    }
  }

  PlayState? _findWinner() {
    final allChecks = [
      _checkMatch(0, 1, 2),
      _checkMatch(3, 4, 5),
      _checkMatch(6, 7, 8),
      _checkMatch(0, 3, 6),
      _checkMatch(1, 4, 7),
      _checkMatch(2, 5, 8),
      _checkMatch(0, 4, 8),
      _checkMatch(2, 4, 6),
    ];

    for (var i = 0; i < allChecks.length; ++i) {
      if (allChecks[i] != null) {
        log('PlayState: ${_playStates[i]}');
        return _playStates[i];
      }
    }
    return null;
  }

  //pass three positions & it will check for match
  PlayState? _checkMatch(int x, int y, int z) {
    if (_playStates[x] != PlayState.none) {
      if (_playStates[x] == _playStates[y] &&
          _playStates[y] == _playStates[z]) {
        return _playStates[x];
      }
    }
    return null;
  }
}
