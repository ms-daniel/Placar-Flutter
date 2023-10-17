import 'package:flutter/material.dart';

main() => runApp(new PerguntaApp());

class PerguntaApp extends StatelessWidget{
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