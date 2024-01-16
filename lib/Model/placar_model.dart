class PlacarModel {
  static PlacarModel? _instance;

  int _teamOnePoints = 0;
  int _teamTwoPoints = 0;
  int _teamOneSets = 0;
  int _teamTwoSets = 0;
  int _maxPoints = 15; //padrão
  bool _inverterPlacar = false;

  //get
  ///inverte o placar fisico ou nao
  bool get inverterPlacar => _inverterPlacar;

  ///retorna pontos do primeiro time
  int get teamOnePoints => _teamOnePoints;

  ///retorna set do primeiro time
  int get teamOneSets => _teamOneSets;

  ///retorna pontos do segundo time
  int get teamTwoPoints => _teamTwoPoints;

  ///retorna set do segundo time
  int get teamTwoSets => _teamTwoSets;

  ///retorna pontuacao maxima
  int get maxPoints => _maxPoints;

  //set
  //////inverte o placar fisico ou nao
  set inverterPlacar(bool value) => _inverterPlacar = value;

  ///altera pontuacao do time 1
  set teamOnePoints(int newPoint) =>
      newPoint >= 0 ? _teamOnePoints = newPoint : null;

  ///altera set do time 1
  set teamOneSets(int newPoint) =>
      newPoint >= 0 ? _teamOneSets = newPoint : null;

  ///altera pontuacao do time 2
  set teamTwoPoints(int newPoint) =>
      newPoint >= 0 ? _teamTwoPoints = newPoint : null;

  ///altera set do time 2
  set teamTwoSets(int newPoint) =>
      newPoint >= 0 ? _teamTwoSets = newPoint : null;

  ///altera pontuacao maxima
  set maxPoints(int newPoint) => newPoint > 0 ? _maxPoints = newPoint : null;

  ///class singleton: permite que apenas uma instancia dessa classe seja
  factory PlacarModel() {
    _instance ??=
        PlacarModel._internal(); //atribue apenas se _instance for null

    return _instance!;
  }

  ///cria uma instancia da class atual
  PlacarModel._internal();
  //fim singleton
}
