import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yon_scoreboard/Controller/placar_controller.dart';

class Configurations extends StatefulWidget {
  const Configurations({Key? key}) : super(key: key);

  @override
  _ConfigurationsState createState() => _ConfigurationsState();
}

class _ConfigurationsState extends State<Configurations> {
  late int dropdownValue;
  late bool invertPontuacao;

  @override
  void initState() {
    super.initState();
    final placarController = context.read<PlacarController>();
    dropdownValue = placarController.maxPoints;
    invertPontuacao = placarController.inverterPlacar;
  }

  @override
  Widget build(BuildContext context) {
    final placarController = context.watch<PlacarController>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Configurações',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Adicione esta linha
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.white),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text(
              'Pontuação máxima',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            subtitle: const Text('Definir pontuação máxima para finalizar o set'),
            textColor: Colors.white,
            trailing: Container(
              alignment: Alignment.center,
              width: 60,
              height: double.infinity,
              child: DropdownButton(
                dropdownColor: const Color.fromARGB(255, 60, 60, 60),
                isExpanded: true,
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down_outlined),
                elevation: 16,
                onChanged: (int? value) {
                  if (value != null) {
                    setState(() {
                      dropdownValue = value;
                    });
                    placarController.maxPoints = value;
                  }
                },
                items: List<DropdownMenuItem<int>>.generate(14, (index) {
                  return DropdownMenuItem<int>(
                    value: 12 + index,
                    child: Text(
                      '${12 + index}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Inverter Pontuação',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Checkbox(
                  value: invertPontuacao,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        invertPontuacao = value;
                      });
                      placarController.inverterPlacar = value;
                    }
                  },
                ),
              ],
            ),
            subtitle: const Text(
              'Inverte pontuação do placar físico',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 11, 11, 11),
    );
  }
}
