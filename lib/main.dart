import './BarraSuperiorPlacar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './placar.dart';

main() {
  runApp(PlacarApp());
}

class _PlacarState extends State<PlacarApp> {
  // ignore: unused_field
  var _teamOnePoints = 0,
      _teamTwoPoints = 0,
      _teamOneSets = 0,
      _teamTwoSets = 0;
  var _maxPoints = 15;

  @override
  void initState() {
    super.initState();
    //define a orientação do app
    SystemChrome.setPreferredOrientations([
      //DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    //define a tela em full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        /*appBar: AppBar(
          title: const Text('Placar - Yonkous'),
          centerTitle: true,
          backgroundColor: Colors.black,
          foregroundColor: Colors.red[400],
        ),*/
        body: Column(
          children: <Widget>[
            BarraSuperiorPlacar(),
            Placar(_teamOnePoints, _teamOneSets, _teamTwoPoints, _teamTwoSets,
                _maxPoints),
          ],
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}

class PlacarApp extends StatefulWidget {
  const PlacarApp({super.key});

  @override
  _PlacarState createState() {
    return _PlacarState();
  }
}
