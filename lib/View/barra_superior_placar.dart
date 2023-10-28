import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:yon_scoreboard/View/configurations.dart';

import 'bluetooth_connection.dart';

class BarraSuperiorPlacar extends StatefulWidget {

  BarraSuperiorPlacar({super.key});

  @override
  State<BarraSuperiorPlacar> createState() => _BarraSuperiorPlacarState();
}

class _BarraSuperiorPlacarState extends State<BarraSuperiorPlacar> {
  //estado do bluetooth
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      setState(() {});
    });
  }

  @override
  void dispose(){
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }
  
  //empilhar tela de configuração na tela atual
  void _openConfigurations() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const Configurations(),
    ));
  }

  void _openBluetooth(){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const BluetoothMain(),
    ));
  }

  Widget _connectedDisconnectedButton(){
    return TextButton(
      onPressed: () {
        _openBluetooth();
      },
      child: Text(
        _adapterState == BluetoothAdapterState.on ? 'Conectado' : 'Disconectado',
        style: TextStyle(
          color: _adapterState == BluetoothAdapterState.on ? Colors.green[900] : Colors.red[900],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          child: _connectedDisconnectedButton(),
          ),
        SizedBox(
          child: IconButton(
            onPressed:_openConfigurations,
            color: Colors.white,
            icon: const Icon(Icons.settings), // Ícone de voltar
          ),
        ),
      ],
    );
  }
}
