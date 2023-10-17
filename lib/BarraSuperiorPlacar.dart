import 'package:flutter/material.dart';

class BarraSuperiorPlacar extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          child: IconButton(
            onPressed: () {
              // Adicione a ação do botão de voltar aqui
            },
            color: Colors.white,
            icon: const Icon(Icons.arrow_back_ios_new), // Ícone de voltar
          ),
        ),
        SizedBox(
          width: 200, // Largura da segunda coluna
          //color: Colors.red[400], // Cor de fundo
          child: Text(
            'Disconnected',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red[400],
              fontSize: 18,
            ),
          ),
          
        ),
        SizedBox(
          child: IconButton(
            onPressed: () {
              // Adicione a ação do botão de voltar aqui
            },
            color: Colors.white,
            icon: const Icon(Icons.settings), // Ícone de voltar
          ),
        ),
      ],
    );
  }
}