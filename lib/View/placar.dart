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
  late final PlacarController _placarController;
  Size? _screenSize;
  double _percentageAdjust = 1;

  bool _isInicialized = false;

  final BluetoothController _bluetoothController = BluetoothController();

  //inscrição para valor enviado pelo servdiro ble
  late StreamSubscription<List<int>> _lastValueReceiveSubscription;

  //verifica se a inscriçao esta ativa
  bool _isSubscriptionLastValue = false;

  late StreamSubscription<OnConnectionStateChangedEvent> _connectionStateSubscription;

  late StreamSubscription<bool> _servicesStreamSubscription;

  late BluetoothCharacteristic _charac ;

  List<int> _valueToSend  = [];
  List<int> _valueReceive = [];

  String _logText = "Sem serviço ou Desconectado";

  //saber se ta separando os characteristics
  bool isRunning = false;

  //saber se os characteristics foram separados e estão prontos para uso
  bool isReady = false;

  String dados = "";

  @override
  void initState(){
    super.initState();

    _servicesStreamSubscription = _bluetoothController.isServicesStream.listen((isServices) async {
      if(isServices){
        setState(() {
          isRunning = true;
        });
        
        await _separateCharacteristics();
        
        _tryInitStream();
      }
      else{
        if(_isSubscriptionLastValue){
          _lastValueReceiveSubscription.cancel();
          _isSubscriptionLastValue = false;
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
      _lastValueReceiveSubscription = _bluetoothController.characteristic!.lastValueStream.listen((value) async {
        _valueReceive = value;

        setState(() {
          _logText = "Valor recebido: ${String.fromCharCodes(value)}";
        });

        _separateData();

      });

      _isSubscriptionLastValue = true;
    }catch(e){
      //TODO
    }
  }

  @override
  void dispose(){
    _servicesStreamSubscription.cancel();
    
    if(_isSubscriptionLastValue){
      _lastValueReceiveSubscription.cancel();
      _valueReceive = [];
      _isSubscriptionLastValue = false;
    }

    _connectionStateSubscription.cancel();
    
    isReady = false;

    super.dispose();
  }

  ///Faz a separacao dos characterisitics
  ///para envio e recebimento de dados
  Future<void> _separateCharacteristics() async{
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
        _bluetoothController.characteristic = service.characteristics.where((c) => c.uuid == Guid("beb5483e-36e1-4688-b7f5-ea07361b26a8")).firstOrNull;

        

        if(_bluetoothController.characteristic != null){
          _charac = _bluetoothController.characteristic!;
          _charac.setNotifyValue(true);

          isRunning = false;
          isReady = true;
          setState(() {
            _logText = "Pronto para receber dados!";
          });

          _sendData();
        }
          
      }
    }
  }

  ///Separar dados recebidos do servidor para atualizar na tela
  Future<void> _separateData() async{
    String strData;
    List<String> substrings;

    if(_valueReceive.isNotEmpty){
      strData = String.fromCharCodes(_valueReceive);

      substrings = strData.split(';');
    }
  }

  ///Construção do log de conexao bluetooth
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

  ///Usado para enviar dados para o servidor
  Future<void> _sendData() async{
    if(!_placarController.inverterPlacar) {
      dados = "${_placarController.teamOnePoints};${_placarController.teamOneSets};${_placarController.teamTwoPoints};${_placarController.teamTwoSets}";
    } else {
      dados = "${_placarController.teamTwoPoints};${_placarController.teamTwoSets};${_placarController.teamOnePoints};${_placarController.teamOneSets}";
    } 

    _valueToSend = dados.codeUnits;

    try{
      await _charac.write(_valueToSend, withoutResponse: _charac.properties.writeWithoutResponse);
      if(_charac.properties.read) {
        await _charac.read();
      }

    }catch(e){
      Snackbar.show(ABC.a, "Error ao tentar enviar dados. $e", success: false);
    }
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
      _screenSize = MediaQuery.of(context).size;
      _percentageAdjust = _screenPercentage(_screenSize!.width);

      _placarController = context.watch<PlacarController>();

      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!_isInicialized){
      _placarController = context.watch<PlacarController>();
      _oneTimeInstructions(context);

      _isInicialized = true;
    }

    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 25*_percentageAdjust, 15,0),
        child: Column(
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
                      _pointsButton(Teams.one, increment: 1, icon: Icons.add_circle_outline, color: Colors.green),
                        
                      //botao de menos do time 1
                      _pointsButton(Teams.one, increment: -1, icon: Icons.remove_circle_outline, color: Colors.red),
                    ],
                  ),
              
                  //time 1: pontos
                  TeamPoints(_placarController.teamOnePoints, _percentageAdjust),
                  //time 1: sets
                  TeamSets(_placarController.teamOneSets, _percentageAdjust),
              
                  _resetButton(context),
                  
                  //time 2: sets
                  TeamSets(_placarController.teamTwoSets, _percentageAdjust),
                  //time 2: pontos
                  TeamPoints(_placarController.teamTwoPoints, _percentageAdjust),
              
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //botao de mais do time 1
                      _pointsButton(Teams.two, increment: 1, icon: Icons.add_circle_outline, color: Colors.green),
                        
                      //botao de menos do time 1
                      _pointsButton(Teams.two, increment: -1, icon: Icons.remove_circle_outline, color: Colors.red),
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

  /// Constroi botoes de incremento e decremento do placar
  /// [team] a qual time sera atribuido
  /// [increment] incremento e decremento (+n/-n)
  /// [icon] icone do botao
  /// [color] Cor do icone
  Widget _pointsButton(Teams team, {required int increment, required IconData icon, required Color color} ) {
    return IconButton(
              onPressed: () async{
                _placarController.addTeamPoints(team, increment);

                if(_isSubscriptionLastValue){
                   _sendData();
                }
              },
              iconSize: 50 * _percentageAdjust,
              color: color,
              icon: Icon(icon),
              //mouseCursor: MaterialState.focused,
            );
  }

  Widget _resetButton(BuildContext context) {
    return
      //botao de reset
      Container(
        margin: EdgeInsets.only(top: 150*_percentageAdjust),
        alignment: Alignment.center,
        //margin: EdgeInsets.fromLTRB(0, screenSize.height * 0.30, 0, 0),
        //inkwell para adicionar long press
        child: InkWell(
          onLongPress: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _resetAlertDialogSets(context);
                },
              ),
          //placarController.resetSets,
          child:IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _resetAlertDialogPoints(context);
                },
              ),
              //placarController.resetPoints,
              iconSize: (60 * _percentageAdjust),
              color: Colors.blue[900],
              icon: const Icon(Icons.refresh_outlined),
            ),
          
        ),
      );
  }

  AlertDialog _resetAlertDialogSets(BuildContext context) {
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
                  _placarController.resetSets();
                },
              ),
            ],
          );
  }

  Widget _resetAlertDialogPoints(BuildContext context) {
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
                  _placarController.resetPoints();
                },
              ),
            ],
          );
  }
  
}