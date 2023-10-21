import 'package:flutter/material.dart';

class Configurations extends StatelessWidget {
  const Configurations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Configurações'),
        ),
        body: ListView(
          children: const <Widget>[
            ListTile(
              title: Text('Pontuação máxima'),
              subtitle: Text('Definir pontuação máxima para finalizar o set'),
            ),
          ],
        ));
  }
}
