class PlacarModel {
  static PlacarModel? _instance;

  int _teamOnePoints = 0;
  int _teamTwoPoints = 0;
  int _teamOneSets = 0;
  int _teamTwoSets = 0;
  int _maxPoints = 15; //padrão

  //get
  int get teamOnePoints => _teamOnePoints; //retorna pontos do primeiro time
  int get teamOneSets => _teamOneSets; //retorna set do primeiro time
  int get teamTwoPoints => _teamTwoPoints; //retorna pontos do segundo time
  int get teamTwoSets => _teamTwoSets; //retorna set do segundo time
  int get maxPoints => _maxPoints; //retorna pontuação máxima

  //set
  set teamOnePoints(int newPoint) =>
      newPoint >= 0 ? _teamOnePoints = newPoint : null;

  set teamOneSets(int newPoint) =>
      newPoint >= 0 ? _teamOneSets = newPoint : null;

  set teamTwoPoints(int newPoint) =>
      newPoint >= 0 ? _teamTwoPoints = newPoint : null;

  set teamTwoSets(int newPoint) =>
      newPoint >= 0 ? _teamTwoSets = newPoint : null;

  set maxPoints(int newPoint) => newPoint > 0 ? _maxPoints = newPoint : null;

  //singleton
  factory PlacarModel() {
    _instance ??=
        PlacarModel._internal(); //atribue apenas se _instance for null

    if (_instance != null)
      print(
          'entrou aquiAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');

    return _instance!;
  }

  PlacarModel._internal(); //cria uma instancia da class atual
  //fim singleton
}
