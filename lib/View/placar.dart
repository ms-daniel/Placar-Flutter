import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
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

  //inscrição para valor enviado pelo servdiro ble
  late StreamSubscription<List<int>> _lastValueReceiveSubscription;
  bool isSubscriptionLastValue = false;

  late StreamSubscription<OnConnectionStateChangedEvent> _connectionStateSubscription;

  late StreamSubscription<bool> _servicesStreamSubscription;

  bool tryit = false;

  List<int> _valueToSend  = [];
  List<int> _valueReceive = [];

  String _logText = "";

  bool isRunning = false;

  @override
  void initState(){
    super.initState();

    _servicesStreamSubscription = _bluetoothController.isServicesStream.listen((isServices) async {
      if(isServices){
        separateCharacteristics();
        //tryInitStream();

        //setState(() {});
      }
      else{
        if(isSubscriptionLastValue){
          _lastValueReceiveSubscription.cancel();
        }
      }
    });
  }

  //tenta criar inscrição no fluxo de recebimento de dados do bluetooth
  Future<void> tryInitStream() async{
    try{
      _lastValueReceiveSubscription = _bluetoothController.characteristicToReceive!.lastValueStream.listen((value) async {
        _valueReceive = value;

        separateData();

        //setState(() {});
      });

      isSubscriptionLastValue = true;
    }catch(e){
      
      //TODO
    }
  }

  @override
  void dispose(){
    _servicesStreamSubscription.cancel();
    
    if(isSubscriptionLastValue){
      _lastValueReceiveSubscription.cancel();
      _valueReceive = [];
      isSubscriptionLastValue = false;
    }

      _connectionStateSubscription.cancel();

    super.dispose();
  }

  Future<void> separateCharacteristics() async{
    setState(() {
      _logText = "Descobrindo serviços...";
    });

    BluetoothService? service;
    //BluetoothCharacteristic? receiver;
    //BluetoothCharacteristic sender;

    if(_bluetoothController.services.isNotEmpty){
      //retorna um service especifico do microcontrolador que queremos 
      service = _bluetoothController.services.where(
        (s) => s.uuid == Guid("4fafc201-1fb5-459e-8fcc-c5c9c331914b")).firstOrNull;

      Snackbar.show(ABC.a, "Separando caracteristicas....", success: true);

      
      //se existir o servico que queremos iremos procurar agora o
      //characteristics especifico
      if(service != null){
        _bluetoothController.characteristicToReceive = service.characteristics.where((c) => c.uuid == Guid("beb5483e-36e1-4688-b7f5-ea07361b26a8")).firstOrNull;

        

        if(_bluetoothController.characteristicToReceive != null){
          _bluetoothController.characteristicToReceive!.setNotifyValue(true);

          setState(() {});
        }
          
      }
    }
  }

  Future<void> separateData() async{
    String strData;
    List<String> substrings;

    if(_valueReceive.isNotEmpty){
      strData = String.fromCharCodes(_valueReceive);

      substrings = strData.split(';');

      print("Data: $substrings");
    }
  }

  Widget _buildLogWidget(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IndexedStack(
          index: (isRunning) ? 1 : 0,
          children: const <Widget>[
            Icon(Icons.close_outlined),
            SizedBox(
              width: 18.0,
              height: 18.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.grey),
              ),
            ),
          ],
        ),
        Text(
          _logText,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  //para ajustar o tamanho dos widgets
  double _screenPercentage(double screenWith) {
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
