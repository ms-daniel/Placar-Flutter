import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yon_scoreboard/Controller/placar_controller.dart';
import 'package:yon_scoreboard/View/barra_superior_placar.dart';
import 'package:yon_scoreboard/View/placar.dart';
import 'package:provider/provider.dart';

main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PlacarController(),
      child: const PlacarApp(),
    ),
  );
}

class PlacarApp extends StatefulWidget {
  const PlacarApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PlacarState createState() {
    return _PlacarState();
  }
}

class _PlacarState extends State<PlacarApp> {
  /*void _alterMaxPoints(int value) {
    setState(() {
      if (value > 0) {
        this._maxPoints = value;
      }
    });
    print('pontaçai max: $_maxPoints');
  }*/

  @override
  void initState() {
    super.initState();
    //define a orientação do app
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    //define a tela em full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            BarraSuperiorPlacar(),
            Placar(),
          ],
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}
