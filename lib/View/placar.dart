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
  late final placarController;
  Size? screenSize;
  double percentageAdjust = 1;

  bool isInicialized = false;

  BluetoothController _bluetoothController = BluetoothController();

  //inscrição para valor enviado pelo servdiro ble
  late StreamSubscription<List<int>> _lastValueReceiveSubscription;

  //verifica se a inscriçao esta ativa
  bool isSubscriptionLastValue = false;

  late StreamSubscription<OnConnectionStateChangedEvent> _connectionStateSubscription;

  late StreamSubscription<bool> _servicesStreamSubscription;

  List<int> _valueToSend  = [];
  List<int> _valueReceive = [];

  String _logText = "Sem serviço ou Desconectado";

  //saber se ta separando os characteristics
  bool isRunning = false;

  //saber se os characteristics foram separados e estão prontos para uso
  bool isReady = false;

  @override
  void initState(){
    super.initState();

    _servicesStreamSubscription = _bluetoothController.isServicesStream.listen((isServices) async {
      if(isServices){
        _separateCharacteristics();
        //tryInitStream();

        //setState(() {});
      }
      else{
        if(isSubscriptionLastValue){
          _lastValueReceiveSubscription.cancel();
          isSubscriptionLastValue = false;
        }
        
        isReady = false;
        setState(() {
          _logText = "Sem serviço ou Desconectado";
        });
      }
    });
  }

  //tenta criar inscrição no fluxo de recebimento de dados do bluetooth
  Future<void> _tryInitStream() async{
    try{
      _lastValueReceiveSubscription = _bluetoothController.characteristicToReceive!.lastValueStream.listen((value) async {
        _valueReceive = value;

        _separateData();

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
    
    isReady = false;

    super.dispose();
  }

  Future<void> _separateCharacteristics() async{
    isRunning = true;
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

      setState(() {
        _logText = "Separando caracteristicas....";
      });

      //se existir o servico que queremos iremos procurar agora o
      //characteristics especifico
      if(service != null){
        _bluetoothController.characteristicToReceive = service.characteristics.where((c) => c.uuid == Guid("beb5483e-36e1-4688-b7f5-ea07361b26a8")).firstOrNull;

        

        if(_bluetoothController.characteristicToReceive != null){
          _bluetoothController.characteristicToReceive!.setNotifyValue(true);

          isRunning = false;
          isReady = true;
          setState(() {
            _logText = "Pronto para receber dados!";
          });
        }
          
      }
    }
  }

  Future<void> _separateData() async{
    String strData;
    List<String> substrings;

    if(_valueReceive.isNotEmpty){
      strData = String.fromCharCodes(_valueReceive);

      substrings = strData.split(';');
    }
  }

  Widget _buildLogWidget(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IndexedStack(
            index: (isRunning) ? 1 : (isReady)? 2 : 0,
            children: const <Widget>[
              Icon(
                Icons.close_outlined,
                color: Color.fromARGB(255, 114, 8, 8),
              ),
              SizedBox(
                width: 18.0,
                height: 18.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.grey),
                ),
              ),
              Icon(
                Icons.done,
                color: Color.fromARGB(255, 8, 114, 8),
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
      ),
    );
  }

  //para ajustar o tamanho dos widgets
  double _screenPercentage(double screenWith) {
    //print("Screen tamnho: $screenWith");
    return (screenWith / 850 );
  }

  //gambiarra para contornar erro de ajuste de tamanhos
  Future<void> _oneTimeInstructions(BuildContext context) async {
    Future.delayed(const Duration(milliseconds: 1000), () {
      //evitar multiplas atribuições
      screenSize = MediaQuery.of(context).size;
      percentageAdjust = _screenPercentage(screenSize!.width);

      placarController = context.watch<PlacarController>();

      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!isInicialized){
      placarController = context.watch<PlacarController>();
      _oneTimeInstructions(context);

      isInicialized = true;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15,0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  //botao de menos do time 1
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //botao de mais do time 1
                      IconButton(
                        onPressed: () {
                          placarController.addTeamPoints(Teams.one, 1);
                        },
                        iconSize: 60 * percentageAdjust,
                        color: Colors.green[900],
                        icon: const Icon(Icons.add_circle_outline),
                        //mouseCursor: MaterialState.focused,
                      ),
                        
                      //botao de menos do time 1
                      IconButton(
                        onPressed: () {
                          placarController.addTeamPoints(Teams.one, -1);
                        },
                        iconSize: 60 * percentageAdjust,
                        color: Colors.red[900],
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                    ],
                  ),
              
                  //time 1: pontos
                  TeamPoints(placarController.teamOnePoints, percentageAdjust),
                  //time 1: sets
                  TeamSets(placarController.teamOneSets, percentageAdjust),
              
                  _resetButton(context),
                  
                  //time 2: sets
                  TeamSets(placarController.teamTwoSets, percentageAdjust),
                  //time 2: pontos
                  TeamPoints(placarController.teamTwoPoints, percentageAdjust),
              
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //botao de mais do time 2
                      IconButton(
                        onPressed: () {
                          placarController.addTeamPoints(Teams.two, 1);
                        },
                        iconSize: 60 * percentageAdjust,
                        color: Colors.green[900],
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                      //botao de menos do time 2
                      IconButton(
                        onPressed: () {
                          placarController.addTeamPoints(Teams.two, -1);
                        },
                        iconSize: 60 * percentageAdjust,
                        color: Colors.red[900],
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildLogWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _resetButton(BuildContext context) {
    return
      //botao de reset
      Container(
        margin: EdgeInsets.only(bottom: 20*percentageAdjust),
        alignment: Alignment.bottomCenter,
        //margin: EdgeInsets.fromLTRB(0, screenSize.height * 0.30, 0, 0),
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
              iconSize: (70 * percentageAdjust),
              color: Colors.blue[900],
              icon: const Icon(Icons.refresh_outlined),
            ),
          
        ),
      );
  }
}