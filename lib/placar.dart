import 'package:flutter/material.dart';

class Placar extends StatelessWidget{
  var _teamOnePoints = 0, _teamTwoPoints = 0, _teamOneSets = 0, _teamTwoSets = 0;
  var maxPoints = 15;

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: IconButton(
            onPressed: () {
              // Adicione a ação do botão de voltar aqui
            },
            icon: Icon(Icons.arrow_back_ios_new), // Ícone de voltar
          ),
        ),
        Container(
          width: 100, // Largura da segunda coluna
          color: Colors.green, // Cor de fundo
          child: Text('Coluna 2'),
        ),
        Container(
          child: IconButton(
            onPressed: () {
              // Adicione a ação do botão de voltar aqui
            },
            icon: Icon(Icons.settings), // Ícone de voltar
          ),
        ),
      ],
    );
  }
}