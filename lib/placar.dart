import 'package:fluter_proj1/main.dart';
import 'package:flutter/material.dart';


enum Teams { 
  team1, team2
}

class Placar extends StatelessWidget {
  var _teamOnePoints = 0, _teamTwoPoints = 0, _teamOneSets = 0, _teamTwoSets = 0;
  var _maxPoints = 15;

  final void Function(Teams, int) alterPoints;

  Placar(this._teamOnePoints, this._teamOneSets, this._teamTwoPoints, this._teamTwoSets, this._maxPoints, this.alterPoints,{super.key});

  @override
  Widget build(BuildContext context) {
    //expanded para ocupar todo o restante da tela
    return Expanded(
      child: Row(
        //alinhar widget ao centro da tela
        mainAxisAlignment: MainAxisAlignment.center, 

        children: <Widget>[
          SizedBox(
            width: 60,
            //botao de menos do time 1
            child: IconButton(
              onPressed: () { 
                alterPoints(Teams.team1,-1);
              },
              iconSize: 50,
              color:  Colors.red[900],
              icon: const Icon(Icons.remove_circle_outline), 
            ),
          ),

          SizedBox(
            width: 60,
            //botao de mais do time 1
            child: IconButton(
              onPressed: () { 
                alterPoints(Teams.team1,1);
              },
              iconSize: 50,
              color: Colors.green[900],
              icon: const Icon(Icons.add_circle_outline), 
            ),
          ),

          SizedBox(
            width: 200,
            //pontos do time 1
            child: Text(
                _teamOnePoints < 10 ? '0' + _teamOnePoints.toString() : _teamOnePoints.toString(),
                style: const TextStyle(
                  fontSize: 174,
                  color:  Colors.white,
                  decoration: TextDecoration.underline,
                  //backgroundColor: Colors.amber,
                ),
              ),
          ),
        
          //digito de set do time 1
          Container(
            width: 50,
            margin: EdgeInsets.fromLTRB(5, 20, 10, 0),
            alignment: Alignment.topLeft,
            //pontos do time 1
            child: Text(
                _teamOneSets.toString(),
                style: const TextStyle(
                  fontSize: 74,
                  color:  Colors.white,
                  //backgroundColor: Colors.amber,
                ),
              ),
          ),

          //digito de set do time 2
          Container(
            width: 50,
            margin: EdgeInsets.fromLTRB(10, 20, 5, 0),
            alignment: Alignment.topRight,
            //pontos do time 1
            child: Text(
                _teamTwoSets.toString(),
                style: const TextStyle(
                  fontSize: 74,
                  color:  Colors.white,
                  //backgroundColor: Colors.amber,
                ),
              ),
          ),

          SizedBox(
            width: 200,
            //pontos do time 1
            child: Text(
                _teamTwoPoints < 10 ? '0' + _teamTwoPoints.toString() : _teamTwoPoints.toString(),
                style: const TextStyle(
                  fontSize: 174,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  //backgroundColor: Colors.amber,
                ),
              ),
          ),
          
          SizedBox(
            width: 60,
            //botao de mais do time 2
            child: IconButton(
              onPressed: () { 
                alterPoints(Teams.team2,1);
              },
              iconSize: 50,
              color: Colors.green[900],
              icon: const Icon(Icons.add_circle_outline),
              
            ),
          ),
          SizedBox(
            width: 60,
            //botao de menos do time 2
            child: IconButton(
              onPressed: (){
                alterPoints(Teams.team2,-1);
              },
              iconSize: 50,
              color:  Colors.red[900],
              icon: const Icon(Icons.remove_circle_outline), 
            ),
          ),
        ],
      )
    );
    
  }
}