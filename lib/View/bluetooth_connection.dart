import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:yon_scoreboard/Controller/bluetooth_controller.dart';

class BluetoothMain extends StatefulWidget {
  const BluetoothMain({super.key});

  @override
  State<BluetoothMain> createState() => _BluetoothMainState();
}

class _BluetoothMainState extends State<BluetoothMain> {
  BluetoothController _bluetoothController = BluetoothController();

  @override
  void initState(){
    super.initState();

    _bluetoothController.adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _bluetoothController.adapterState = state;
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    Widget? screen;

    return MaterialApp(
      home: screen,
      navigatorObservers: [],
    );
  }
}