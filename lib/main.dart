import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

main() {
  /*SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]);*/
  runApp(new PerguntaApp());
} 

enum Teams { 
  team1, team2
}

class PlacarState extends State<PlacarApp>{

  var teamOnePoints = 0, teamTwoPoints = 0, teamOneSets = 0, teamTwoSets = 0;
  var maxPoints = 15;

  void incrementPoints(Teams team, int point){
    //incrementa/decrementa a pontuação de algum dos times
    switch(team){
      case Teams.team1:
        teamTwoPoints += point;
        break;

      case Teams.team2:
        teamOnePoints += point;
        break;

      default:
        break;
    }

    //quando atingir o maximo de pontos definido
    //incremnta os sets e reseta a pontuação
    if(teamOnePoints >= maxPoints){
      teamOneSets += 1;
      teamOnePoints = 0;
    }
    else if(teamTwoPoints >= maxPoints){
      teamTwoSets += 1;
      teamTwoPoints = 0;
    }
      

  }
}

class PlacarApp extends StatefulWidget{
  void responder(){
    print('Respondido');
  }

  @override
  Widget build(BuildContext context){
    final List<String> perguntas = [
      'foda-se?',
      'dane-se',
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Perguntas'),
        ),
        body: Column(
          children: <Widget>[
            Text(perguntas.elementAt(0)),

            //antigo raisedbutton
            ElevatedButton(
              onPressed: responder,
              child: Text('Resposta 1'),
            ),

            ElevatedButton(
              onPressed: responder,
              child: Text('Resposta 2'),
            ),

            ElevatedButton(
              onPressed: responder,
              child: Text('Resposta 3'),
            ),
        ]),
      ),
    );
  }
}