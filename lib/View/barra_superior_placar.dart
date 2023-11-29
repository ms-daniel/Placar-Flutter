import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:yon_scoreboard/View/configurations.dart';

import '../Controller/bluetooth_controller.dart';
import '../Utils/snackbar.dart';
import 'bluetooth_connection.dart';

class BarraSuperiorPlacar extends StatefulWidget {

  BarraSuperiorPlacar({super.key});

  @override
  State<BarraSuperiorPlacar> createState() => _BarraSuperiorPlacarState();
}

class _BarraSuperiorPlacarState extends State<BarraSuperiorPlacar> {
  BluetoothController _bluetoothController = BluetoothController();

  //estado do bluetooth
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  BluetoothConnectionState _deviceState = BluetoothConnectionState.disconnected;

  bool _isDiscoveringServices = false;

  /*BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;
  late StreamSubscription<BluetoothConnectionState> _connectionStateStateSubscription;*/

  @override
  void initState() {
    super.initState();

    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      setState(() {});
    });
  }

  //apenas para qnd voltar a essa tela tentar novamente se inscrever no fluxo
  //do device conectado
  Future<void> tryInitState() async {
    //TRY CATCH pois a variavel é late
    try{
      //verifica se dispositivo esta conectado
       _bluetoothController.deviceState = _bluetoothController.deviceConnected.connectionState.listen((BluetoothConnectionState state) async {
          _deviceState = state;

          if (state == BluetoothConnectionState.connected && _bluetoothController.services.isEmpty) {
            _bluetoothController.services = []; // must rediscover services
          }
          if (state == BluetoothConnectionState.connected && _bluetoothController.rssi == 999) {
            _bluetoothController.rssi = await _bluetoothController.deviceConnected.readRssi();
          }

          if(state == BluetoothConnectionState.disconnected){
            _bluetoothController.services = [];
          }

          setState(() {
          });
      });

      if(_deviceState == BluetoothConnectionState.connected 
          && _bluetoothController.services.isEmpty 
          && !_isDiscoveringServices){
        discoverServices();
        
      }
        
    }catch (e){
      _deviceState = BluetoothConnectionState.disconnected;
       _bluetoothController.services = [];
      //TODO
    }
  }

  @override
  void dispose(){
    try{
      _bluetoothController.deviceState.cancel();
      _bluetoothController.services = [];
    }catch(e){
      //TODO
    }
    
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  Future discoverServices() async {
    //Snackbar.show(ABC.a, "Descobrindo serviços...", success: true);

    setState(() {
      _isDiscoveringServices = true;
    });

    try {
      _bluetoothController.services = await _bluetoothController.deviceConnected.discoverServices();
      Snackbar.show(ABC.a, "Discover Services: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.a, prettyException("Discover Services Error:", e), success: false);
    }
    setState(() {
      _isDiscoveringServices = false;
    });
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
    tryInitState();
    String deviceName = _deviceState == BluetoothConnectionState.connected ? _bluetoothController.deviceConnected.platformName : "Disconectado";

    return TextButton(
      onPressed: () {
        _openBluetooth();
      },
      child: Text(
        //alterar estado qnd conectar em um dispositivo
        //verifica se o status do bluetooth é ligado
        //se for ele verifica se ta conectado a algum dispositivo
        _adapterState == BluetoothAdapterState.on ? _deviceState == BluetoothConnectionState.connected ? '${deviceName} | Conectado' : '${deviceName} | On' : '${deviceName} | Off',
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
