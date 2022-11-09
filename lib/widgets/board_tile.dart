import 'package:flutter/material.dart';

import '../models/play_state.dart';

//represents single tile of tic tac toe board
class BoardTile extends StatelessWidget {
  final PlayState playState;
  final VoidCallback onPressed;

  const BoardTile(
      {super.key, required this.playState, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 208, 234, 255),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            playState == PlayState.none ? '' : playState.name.toUpperCase(),
            style: TextStyle(
              color: PlayState.x == playState ? Colors.blue : Colors.pink,
              fontSize: 52,
            ),
          ),
        ),
      ),
    );
  }
}
