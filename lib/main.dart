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
      //incrementa/decrementa a pontuação de algum dos times
      switch(team){
        case Teams.team1:
          if((_teamOnePoints >= 0 && point > 0) || (point < 0 && _teamOnePoints > 0)){
            setState(() {
               _teamOnePoints += point;
            });
          }
           
          break;

        case Teams.team2:
          if((_teamTwoPoints >= 0 && point > 0) || (point < 0 && _teamTwoPoints > 0)){
            setState(() {
              _teamTwoPoints += point;
            });
          }  
          break;

        default:
          break;
      }

      //quando atingir o maximo de pontos definido
      //incremnta os sets e reseta a pontuação
      if(_teamOnePoints >= _maxPoints){
        setState(() {
          _teamOneSets += 1;
          _teamOnePoints = 0;
          _teamTwoPoints = 0;
        });
      }
      else if(_teamTwoPoints >= _maxPoints){
        setState(() {
          _teamTwoSets += 1;
          _teamOnePoints = 0;
          _teamTwoPoints = 0;
        });
      }
  }

  @override
  Widget build(BuildContext context){

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Placar - Yonkous'),
          centerTitle: true,
          backgroundColor: Colors.black,
          foregroundColor: Colors.red[400],
        ),
        body: Column(
          children: <Widget>[
            BarraSuperiorPlacar(),
            Placar(_teamOnePoints, _teamOneSets, _teamTwoPoints, _teamTwoSets, _maxPoints, _incrementPoints),
          ],
        ),
        backgroundColor: Colors.black, 
      ),
    );
  }
}

class PlacarApp extends StatefulWidget{
  const PlacarApp({super.key});


  @override
  _PlacarState createState(){
    return _PlacarState();
  }
}