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

  //estado do bluetooth
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  BluetoothAdapterState get adapterState{
    return _adapterState;
  }

  StreamSubscription<BluetoothAdapterState> get adapterStateStateSubscription => _adapterStateStateSubscription;
  set adapterState(BluetoothAdapterState state) => _adapterState = state;

  //get adapterStateStateSubscription => _adapterStateStateSubscription;
  set adapterStateStateSubscription(StreamSubscription<BluetoothAdapterState> stream) => _adapterStateStateSubscription = stream;
  
  

  //dispositivos conectados
  List<BluetoothDevice> _connectedDevices = [];
  //resultado da varredura
  List<ScanResult> _scanResults = [];

  //status da varredura
  bool _isScanning = false;

  //inscrição no fluxo do scan
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;

  //inscrição no estado do fluxo do scan
  late StreamSubscription<bool> _isScanningSubscription;

  //estado da conexao
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;
  late StreamSubscription<BluetoothConnectionState> _connectionStateSubscription;

  //servicos disponibilizados pela conexao
  List<BluetoothService> _services = [];

  //verificar uso
  bool _isDiscoveringServices = false;

  bool _isConnectingOrDisconnecting = false;
  late StreamSubscription<bool> _isConnectingOrDisconnectingSubscription;


}