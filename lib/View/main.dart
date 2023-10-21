import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yon_scoreboard/View/BarraSuperiorPlacar.dart';
import 'package:yon_scoreboard/View/placar.dart';

main() {
  runApp(const PlacarApp());
}

class PlacarApp extends StatefulWidget {
  const PlacarApp({super.key});

  @override
  _PlacarState createState() {
    return _PlacarState();
  }
}

class _PlacarState extends State<PlacarApp> {
  // ignore: unused_field
  final _teamOnePoints = 0,
      _teamTwoPoints = 0,
      _teamOneSets = 0,
      _teamTwoSets = 0;

  var _maxPoints = 15;

  void _alterMaxPoints(int value) {
    setState(() {
      if (value > 0) {
        this._maxPoints = value;
      }
    });
    print('pontaçai max: $_maxPoints');
  }

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
