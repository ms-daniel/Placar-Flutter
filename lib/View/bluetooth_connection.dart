import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:yon_scoreboard/Controller/bluetooth_controller.dart';

import 'Bluetooth/bluetooth_off.dart';

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

    //inscrição para ouvir mudança de estado no hardware do bluetooth
    _bluetoothController.adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _bluetoothController.adapterState = state;
      setState(() {});
    });
  }

   @override
  void dispose() {
    //cancelar inscrição no fluxo qnd flechar esta tela
    _bluetoothController.adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget? screen = _bluetoothController.adapterState == BluetoothAdapterState.off ? BluetoothOff(adapterState: _bluetoothController.adapterState) : null;

    return MaterialApp(
      color: Colors.lightBlue,
      home: screen,
      //navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}


class BluetoothAdapterStateObserver extends NavigatorObserver {
  /*StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/DeviceScreen') {
      // Começa a ouvir o estado do bluetooth quando muda para uma nova rota/tela
      _adapterStateSubscription ??= FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          // Desempilha a rota atual caso desligue o bluetooth
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancela a inscrição quando a rota é removida da pilha
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }*/
}