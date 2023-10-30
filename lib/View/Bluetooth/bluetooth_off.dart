import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../Utils/snackbar.dart';

class BluetoothOff extends StatelessWidget {
  const BluetoothOff({Key? key, this.adapterState}) : super(key: key);

  final BluetoothAdapterState? adapterState;

  Widget buildBluetoothOffIcon(BuildContext context) {
    return const Icon(
      Icons.bluetooth_disabled,
      size: 200.0,
      color: Color.fromARGB(137, 255, 255, 255),
    );
  }

  Widget buildTitle(BuildContext context) {
    String? state = adapterState?.toString().split(".").last;
    return Text(
      'Função Bluetooth ${state == 'on' ? 'ativada' : 'não ativada'}',
      style: Theme.of(context).primaryTextTheme.titleSmall?.copyWith(color: Colors.white),
    );
  }

  Widget buildTurnOnButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
          shadowColor: MaterialStateProperty.all(Color.fromARGB(255, 0, 67, 143)),
          padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(40,0,40,0)), // Aumenta o tamanho do botão
        ),
        onPressed: () async {
          try {
            if (Platform.isAndroid) {
              await FlutterBluePlus.turnOn();
            }
          } catch (e) {
            Snackbar.show(ABC.a, prettyException("Erro ao tentar ligar: ", e), success: false);
          }
        },
        child: const Text('Ligar'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: Snackbar.snackBarKeyA,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildBluetoothOffIcon(context),
              buildTitle(context),
              if (Platform.isAndroid) buildTurnOnButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
