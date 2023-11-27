import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:yon_scoreboard/Utils/extra.dart';
import 'package:yon_scoreboard/View/placar.dart';
import 'package:yon_scoreboard/main.dart';

import '../../Controller/bluetooth_controller.dart';
import '../../Utils/snackbar.dart';
import 'connected_device_tile.dart';
import 'scan_result_tile.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  BluetoothController _bluetoothController = BluetoothController();

  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();

    FlutterBluePlus.systemDevices.then((devices) {
      _bluetoothController.connectedDevices = devices;
      setState(() {});
    });

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _bluetoothController.scanResults = results;
      setState(() {});
    }, onError: (e) {
      Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future onScanPressed() async {
    try {
      // android is slow when asking for all advertisments,
      // so instead we only ask for 1/8 of them
      int divisor = Platform.isAndroid ? 8 : 1;

      await FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 15),
          continuousUpdates: true,
          continuousDivisor: divisor);
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("Start Scan Error:", e),
          success: false);
    }
    setState(() {}); // force refresh of systemDevices
  }

  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("Stop Scan Error:", e),
          success: false);
    }
  }

  //dispositivos conectados
  List<Widget> _buildConnectedDeviceTiles(BuildContext context) {
    return _bluetoothController.connectedDevices
        .map(
          (d) => ConnectedDeviceTile(
            device: d,
            /*onOpen: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DeviceScreen(device: d),
                settings: RouteSettings(name: '/DeviceScreen'),
              ),
            ),*/
            onDisconnect: () => {

            },
            onConnect: () => onConnectPressed(d),
          ),
        )
        .toList();
  }

   void onConnectPressed(BluetoothDevice device) {
    //disconectada do dispositivo em qque estava conectado
    //caso ele seja diferente do atual
    if(_bluetoothController.deviceConnected != device){
      _bluetoothController.deviceConnected.disconnect();
    }

    _bluetoothController.deviceConnected = device;  
    

    device.connectAndUpdateStream().catchError((e) {
      Snackbar.show(ABC.c, prettyException("Connect Error:", e), success: false);
    });
    /*MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => DeviceScreen(device: device), settings: RouteSettings(name: '/DeviceScreen'));*/
    //Navigator.of(context).pop();
    Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => PlacarApp()),
              (Route<dynamic> route) => false,
            );
  }

  void onDisconnectPressed(BluetoothDevice device){
    device.disconnect();
  }

  Future onRefresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    setState(() {});
    return Future.delayed(Duration(milliseconds: 500));
  }

  Widget buildScanButton(BuildContext context) {
    if (FlutterBluePlus.isScanningNow) {
      return FloatingActionButton(
        child: const Icon(Icons.stop),
        onPressed: onStopPressed,
        backgroundColor: Colors.red,
      );
    } else {
      return FloatingActionButton(child: const Text("SCAN"), onPressed: onScanPressed);
    }
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return _bluetoothController.scanResults
        .map(
          (r) => ScanResultTile(
            result: r,
            onTap: () => onConnectPressed(r.device),
          ),
        )
        .toList();
  }



  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: Snackbar.snackBarKeyB,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 68, 102, 136),
          title: const Center(
            child:
              Text(
                'Find Devices',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            children: <Widget>[
              const Divider(
                height: 3,
                thickness: 3,
                color: Colors.black,
              ),
              ..._buildConnectedDeviceTiles(context),
              ..._buildScanResultTiles(context),
            ],
          ),
        ),
        floatingActionButton: buildScanButton(context),
      ),
    );
  }
}
