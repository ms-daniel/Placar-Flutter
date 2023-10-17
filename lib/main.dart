import 'package:fluter_proj1/BarraSuperiorPlacar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './Placar.dart';

main() {
  /*SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]);*/
  runApp(PlacarApp());
} 

enum Teams { 
  team1, team2
}

class _PlacarState extends State<PlacarApp>{

  // ignore: unused_field
  var _teamOnePoints = 0, _teamTwoPoints = 0, _teamOneSets = 0, _teamTwoSets = 0;
  var _maxPoints = 15;

  @override
  void initState() {
    super.initState();
    //define a orientação do app
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    //define a tela em full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _incrementPoints(Teams team, int point){
    setState(() {
      //incrementa/decrementa a pontuação de algum dos times
      switch(team){
        case Teams.team1:
          _teamTwoPoints += point;
          break;

        case Teams.team2:
          _teamOnePoints += point;
          break;

        default:
          break;
      }

      //quando atingir o maximo de pontos definido
      //incremnta os sets e reseta a pontuação
      if(_teamOnePoints >= _maxPoints){
        _teamOneSets += 1;
        _teamOnePoints = 0;
      }
      else if(_teamTwoPoints >= _maxPoints){
        _teamTwoSets += 1;
        _teamTwoPoints = 0;
      }
    });
  }

  void _responder(){
    print('Respondido');
  }

  @override
  Widget build(BuildContext context){

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Placar - Yonkous'),
          centerTitle: true,
          backgroundColor: Colors.black,
          foregroundColor: Colors.red[400],
        ),
        body: Column(
          children: <Widget>[
            BarraSuperiorPlacar(),
            Placar(10,0,2,0,15),
          ],
        ),
        backgroundColor: Colors.black, 
      ),
    );
  }
}

class PlacarApp extends StatefulWidget{
  _PlacarState createState(){
    return _PlacarState();
  }
}