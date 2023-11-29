import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yon_scoreboard/Controller/bluetooth_controller.dart';
import 'package:yon_scoreboard/Controller/placar_controller.dart';
import 'package:yon_scoreboard/shared/enums.dart';

import '../Utils/snackbar.dart';
import '../shared/points_sets.dart';

class Placar extends StatefulWidget {
  const Placar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PlacarState createState() => _PlacarState();
}

class _PlacarState extends State<Placar> {
  BluetoothController _bluetoothController = BluetoothController();
  
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

          //time 1: pontos
          TeamPoints(placarController.teamOnePoints, percentageAdjust),
          //time 1: sets
          TeamSets(placarController.teamOneSets, percentageAdjust),

          //botao de reset
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, screenSize.height * 0.30, 0, 0),
              //inkwell para adicionar long press
              child: InkWell(
                onLongPress: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const  Text("Confirmação"),
                          //rich text para poder colocar uma cor a palavra pontuação
                          content: RichText(
                            text: TextSpan(
                              text: "Tem certeza de que deseja resetar os ",
                              style: DefaultTextStyle.of(context).style,
                              children: const <TextSpan>[
                                TextSpan(
                                  text: "SETS",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 199, 3, 3),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "?",
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Cancelar",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 102, 102, 102)
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(); // Fecha o diálogo
                              },
                            ),
                            TextButton(
                              child: const Text("Sim"),
                              onPressed: () {
                                //caso confirme reset
                                Navigator.of(context).pop(); // Fecha o diálogo
                                placarController.resetSets();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                //placarController.resetSets,
                child:IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const  Text("Confirmação"),
                          //rich text para poder colocar uma cor a palavra pontuação
                          content: RichText(
                            text: TextSpan(
                              text: "Tem certeza de que deseja resetar a ",
                              style: DefaultTextStyle.of(context).style,
                              children: const <TextSpan>[
                                TextSpan(
                                  text: "PONTUAÇÃO",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "?",
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Cancelar",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 102, 102, 102)
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(); // Fecha o diálogo
                              },
                            ),
                            TextButton(
                              child: const Text("Sim"),
                              onPressed: () {
                                //caso confirme reset
                                Navigator.of(context).pop(); // Fecha o diálogo
                                placarController.resetPoints();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    //placarController.resetPoints,
                    iconSize: (60 * percentageAdjust),
                    color: Colors.blue[900],
                    icon: const Icon(Icons.refresh_outlined),
                  ),
                
              ),
            ),
          ),

          //time 2: sets
          TeamSets(placarController.teamTwoSets, percentageAdjust),
          //time 2: pontos
          TeamPoints(placarController.teamTwoPoints, percentageAdjust),

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
