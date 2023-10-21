import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yon_scoreboard/Controller/PlacarController.dart';
import 'package:yon_scoreboard/shared/enums.dart';

class Placar extends StatefulWidget {
  const Placar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PlacarState createState() => _PlacarState();
}

class _PlacarState extends State<Placar> {
  //para ajustar o tamanho dos widgets
  double _screenPercentage(double screenWith) {
    //print ("taamnho da tela: $screenWith");
    return (screenWith / 850);
  }

  @override
  Widget build(BuildContext context) {
    final placarController = context.watch<PlacarController>();

    final Size screenSize = MediaQuery.of(context).size;
    final double percentageAdjust = _screenPercentage(screenSize.width);

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
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //botao de mais do time 1
                  IconButton(
                    onPressed: () {
                      placarController.addTeamPoints(Teams.one, 1);
                    },
                    iconSize: (50 * percentageAdjust),
                    color: Colors.green[900],
                    icon: const Icon(Icons.add_circle_outline),
                    //mouseCursor: MaterialState.focused,
                  ),

                  //botao de menos do time 1
                  IconButton(
                    onPressed: () {
                      placarController.addTeamPoints(Teams.one, -1);
                    },
                    iconSize: (50 * percentageAdjust),
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
                placarController.teamOnePoints < 10
                    ? '0${placarController.teamOnePoints}'
                    : placarController.teamOnePoints.toString(),
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
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              alignment: Alignment.topLeft,
              child: Text(
                placarController.teamOneSets.toString(),
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
                onPressed: placarController.resetPoints,
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
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              alignment: Alignment.topRight,
              child: Text(
                placarController.teamTwoSets.toString(),
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
                placarController.teamTwoPoints < 10
                    ? '0${placarController.teamTwoPoints}'
                    : placarController.teamTwoPoints.toString(),
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
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //botao de mais do time 2
                  IconButton(
                    onPressed: () {
                      placarController.addTeamPoints(Teams.two, 1);
                    },
                    iconSize: (50 * percentageAdjust),
                    color: Colors.green[900],
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                  //botao de menos do time 2
                  IconButton(
                    onPressed: () {
                      placarController.addTeamPoints(Teams.two, -1);
                    },
                    iconSize: (50 * percentageAdjust),
                    color: Colors.red[900],
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
