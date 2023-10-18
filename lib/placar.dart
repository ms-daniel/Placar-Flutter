import 'package:flutter/material.dart';

enum Teams { team1, team2 }

class Placar extends StatelessWidget {
  final _teamOnePoints, _teamTwoPoints, _teamOneSets, _teamTwoSets;
  final _maxPoints;

  final void Function(Teams, int) alterPoints;

  Placar(this._teamOnePoints, this._teamOneSets, this._teamTwoPoints,
      this._teamTwoSets, this._maxPoints, this.alterPoints,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    //expanded para ocupar todo o restante da tela
    return Expanded(
        child: Row(
      //alinhar widget ao centro da tela
      mainAxisAlignment: MainAxisAlignment.center,

      children: <Widget>[
        //botao de menos do time 1
        Expanded(
          flex: 1,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //botao de mais do time 1
                IconButton(
                  onPressed: () {
                    alterPoints(Teams.team1, 1);
                  },
                  iconSize: 50,
                  color: Colors.green[900],
                  icon: const Icon(Icons.add_circle_outline),
                ),

                //botao de menos do time 1
                IconButton(
                  onPressed: () {
                    alterPoints(Teams.team1, -1);
                  },
                  iconSize: 50,
                  color: Colors.red[900],
                  icon: const Icon(Icons.remove_circle_outline),
                ),
              ],
            ),
          ),
        ),

        //pontos do time 1
        Expanded(
          flex: 4,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              _teamOnePoints < 10
                  ? '0' + _teamOnePoints.toString()
                  : _teamOnePoints.toString(),
              style: const TextStyle(
                fontSize: 210,
                color: Colors.white,
                decoration: TextDecoration.underline,
                //backgroundColor: Colors.amber,
              ),
            ),
          ),
        ),

        //set time 1
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            alignment: Alignment.topLeft,
            child: Text(
              _teamOneSets.toString(),
              style: const TextStyle(
                fontSize: 74,
                color: Colors.white,
              ),
            ),
          ),
        ),

        //botao de reset
        Expanded(
          flex: 2,
          child: Container(
            //alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(0, screenSize.height * 0.30, 0, 0),
            child: IconButton(
              onPressed: () {
                //alterPoints(Teams.team1, 1);
              },
              iconSize: 70,
              color: Colors.blue[900],
              icon: const Icon(Icons.refresh_outlined),
            ),
          ),
        ),

        //digito de set do time 2
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            alignment: Alignment.topRight,
            child: Text(
              _teamTwoSets.toString(),
              style: const TextStyle(
                fontSize: 74,
                color: Colors.white,
              ),
            ),
          ),
        ),

        //pontos do time 2
        Expanded(
          flex: 4,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              _teamTwoPoints < 10
                  ? '0' + _teamTwoPoints.toString()
                  : _teamTwoPoints.toString(),
              style: const TextStyle(
                fontSize: 210,
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),

        Expanded(
          flex: 1,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //botao de mais do time 2
                IconButton(
                  onPressed: () {
                    alterPoints(Teams.team2, 1);
                  },
                  iconSize: 50,
                  color: Colors.green[900],
                  icon: const Icon(Icons.add_circle_outline),
                ),
                //botao de menos do time 2
                IconButton(
                  onPressed: () {
                    alterPoints(Teams.team2, -1);
                  },
                  iconSize: 50,
                  color: Colors.red[900],
                  icon: const Icon(Icons.remove_circle_outline),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
