// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/widgets.dart';

import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothController extends ChangeNotifier {
  // SINGLETON
  static final BluetoothController _singleton = BluetoothController._internal();

  // Construtor privado para evitar a criação de instâncias fora da classe.
  BluetoothController._internal();

  factory BluetoothController() {
    return _singleton;
  }
  //END SINGLETON

  //device conectado ao app
  late BluetoothDevice _deviceConnected = BluetoothDevice.fromId("");
  set deviceConnected(BluetoothDevice device) => _deviceConnected = device;
  BluetoothDevice get deviceConnected => _deviceConnected;

  //ouvir se o device foi disconectado
  late StreamSubscription<BluetoothConnectionState> _deviceState;
  set deviceState (StreamSubscription<BluetoothConnectionState> state) => _deviceState = state;
  StreamSubscription<BluetoothConnectionState> get deviceState => _deviceState;

  //sinal do bluetooth
  int _rssi = 999; //999 ao inves de null
  set rssi(int rssi) => _rssi = rssi;
  int get rssi => _rssi;

  //tamanho do mtu
  //int? _mtuSize;

  //servicos disponibilizados pela conexao
  List<BluetoothService> _services = [];
  set services(List<BluetoothService> services) {
    _services = services;

    //verifica se a service esta vazia ou nao
    //para avisar ao fluxo
    _servicesController.sink.add(_services.isEmpty ? false : true);
  }
  List<BluetoothService> get services => _services;

  //fluxo para verificar se há services (usado noo placar, necessario refatorar depois)
  final _servicesController = StreamController<bool>();
  Stream<bool> get isServicesStream => _servicesController.stream; 

  //characteristics
  BluetoothCharacteristic? _charaToReceive;
  //BluetoothCharacteristic? _charaToSend;

  set characteristic(BluetoothCharacteristic? characteristic) => _charaToReceive = characteristic;
  //set characteristicToSend(BluetoothCharacteristic? characteristic) => _charaToSend = characteristic;
  BluetoothCharacteristic? get characteristic => _charaToReceive;
  //BluetoothCharacteristic? get characteristicToSend => _charaToSend;

  //estado do bluetooth
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  BluetoothAdapterState get adapterState {
    return _adapterState;
  }

  StreamSubscription<BluetoothAdapterState> get adapterStateStateSubscription =>
      _adapterStateStateSubscription;
  set adapterState(BluetoothAdapterState state) => _adapterState = state;

  set adapterStateStateSubscription(
          StreamSubscription<BluetoothAdapterState> stream) =>
      _adapterStateStateSubscription = stream;

  //dispositivos conectados
  List<BluetoothDevice> _connectedDevices = [];

  set connectedDevices(List<BluetoothDevice> devices) =>
      _connectedDevices = devices;

  List<BluetoothDevice> get connectedDevices => _connectedDevices;

  //resultado da varredura
  List<ScanResult> _scanResults = [];
  set scanResults(List<ScanResult> results) => _scanResults = results;
  List<ScanResult> get scanResults => _scanResults;

  //estado da conexao
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;

  set connectionState(BluetoothConnectionState state) => _connectionState = state;
  BluetoothConnectionState get connectionState => _connectionState;

  /*late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;*/

  

  //verificar uso
  /*bool _isDiscoveringServices = false;

  bool _isConnectingOrDisconnecting = false;
  late StreamSubscription<bool> _isConnectingOrDisconnectingSubscription;*/
}
