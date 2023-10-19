import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

enum Teams { team1, team2 }

class Placar extends StatelessWidget {
  final _teamOnePoints, _teamTwoPoints, _teamOneSets, _teamTwoSets;
  final _maxPoints;

  final void Function(Teams, int) alterPoints;

  Placar(this._teamOnePoints, this._teamOneSets, this._teamTwoPoints,
      this._teamTwoSets, this._maxPoints, this.alterPoints,
      {super.key});

  //para ajustar o tamanho dos widgets
  double ScreenPercentage(double screenWith){
    print ("taamnho da tela: $screenWith");
    return (screenWith/850);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double percentageAdjust = ScreenPercentage(screenSize.width);

    //expanded para ocupar todo o restante da tela
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          //alinhar widget ao centro da tela
          mainAxisAlignment: MainAxisAlignment.center,
      
          children: <Widget>[
            
            //botao de menos do time 1
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.fromLTRB(0,0,0,0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //botao de mais do time 1
                    IconButton(
                      onPressed: () {
                        alterPoints(Teams.team1, 1);
                      },
                      iconSize: (50*percentageAdjust),
                      color: Colors.green[900],
                      icon: const Icon(Icons.add_circle_outline),
                      //mouseCursor: MaterialState.focused,
                    ),
      
                    //botao de menos do time 1
                    IconButton(
                      onPressed: () {
                        alterPoints(Teams.team1, -1);
                      },
                      iconSize: (50*percentageAdjust),
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
                child: AutoSizeText(
                  _teamOnePoints < 10
                      ? '0' + _teamOnePoints.toString()
                      : _teamOnePoints.toString(),
                  style: TextStyle(
                    fontSize: (210 * percentageAdjust),
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                  maxLines: 1,
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
                  style: TextStyle(
                    fontSize: (74 * percentageAdjust),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
      
            //botao de reset
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, screenSize.height * 0.30, 0, 0),
                child: IconButton(
                  onPressed: () {
                    //alterPoints(Teams.team1, 1);
                  },
                  iconSize: (60 * percentageAdjust),
                  color: Colors.blue[900],
                  icon: const Icon(Icons.refresh_outlined),
                  tooltip: 'Resetar Pontuação',
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
                  style: TextStyle(
                    fontSize: (74 * percentageAdjust),
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
                child: AutoSizeText(
                  _teamTwoPoints < 10
                      ? '0' + _teamTwoPoints.toString()
                      : _teamTwoPoints.toString(),
                  style: TextStyle(
                    fontSize: (210 * percentageAdjust),
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
      
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.fromLTRB(0,0,0,0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //botao de mais do time 2
                    IconButton(
                      onPressed: () {
                        alterPoints(Teams.team2, 1);
                      },
                      iconSize: (50*percentageAdjust),
                      color: Colors.green[900],
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                    //botao de menos do time 2
                    IconButton(
                      onPressed: () {
                        alterPoints(Teams.team2, -1);
                      },
                      iconSize:(50*percentageAdjust),
                      color: Colors.red[900],
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
