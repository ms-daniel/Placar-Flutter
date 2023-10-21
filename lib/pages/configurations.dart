import 'package:flutter/material.dart';

class Configurations extends StatelessWidget {
  var dropdownValue = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Configurações')),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0), // Altura da borda
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    width: 1, color: Colors.white), // Estilo da borda
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
            subtitle:
                const Text('Definir pontuação máxima para finalizar o set'),
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
                    dropdownValue =
                        value; // criar função para renderizar a view
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
        ],
      ),
      backgroundColor: Color.fromARGB(255, 11, 11, 11),
    );
  }
}
