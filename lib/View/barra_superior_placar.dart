import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:yon_scoreboard/View/configurations.dart';

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
  
  //empilhar tela de configuração na tela atual
  void _OpenConfigurations(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const Configurations(),
    ));
  }

  void _OpenBluetooth(BuildContext context){
    //TODO
  }

  Widget _ConnectedDisconnectedButton(){
    return TextButton(
      onPressed: () {},
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
          child: _ConnectedDisconnectedButton(),
          ),
        SizedBox(
          child: IconButton(
            onPressed: () {
              _OpenConfigurations(context);
            },
            color: Colors.white,
            icon: const Icon(Icons.settings), // Ícone de voltar
          ),
        ),
      ],
    );
  }
}
