import 'package:flutter/material.dart';
import 'package:yon_scoreboard/Model/placar_model.dart';
import 'package:yon_scoreboard/shared/enums.dart';

class PlacarController extends ChangeNotifier {
  final PlacarModel _placarModel = PlacarModel();

  ///Incrementa ou decrementa pontuação de algum dos times
  /// - [team]: recebe um enumerado Teams: one, two
  /// - [newPoint]: recebe um inteiro referente a pontuacao a ser adicionada
  void addTeamPoints(Teams team, int newPoint) {
    if (newPoint != 0) {
      switch (team) {
        case Teams.one:
          _addTeamOnePoints = newPoint;
          break;
        case Teams.two:
          _addTeamTwoPoints = newPoint;
          break;
        default:
          //TODO
          break;
      }

      //esses dois if's verificam se algum dos times
      //alcancou a pontuacao maxima
      if (teamOnePoints == maxPoints) {
        _resetTeamOnePoints();
        _resetTeamTwoPoints();

        _addTeamOneSet = 1;
      }
      if (teamTwoPoints == maxPoints) {
        _resetTeamOnePoints();
        _resetTeamTwoPoints();

        _addTeamTwoSet = 1;
      }

      notifyListeners();
    }
  }

  void resetSets(){
    if(teamOneSets > 0 || teamTwoSets > 0){
      _resetTeamOneSets();
      _resetTeamTwoSets();

      _resetTeamOnePoints();
      _resetTeamTwoPoints();

      notifyListeners();
    }
  }

  ///Reseta a pontuacao de ambos os times
  void resetPoints() {
    if (teamOnePoints > 0 || teamTwoPoints > 0) {
      _resetTeamOnePoints();
      _resetTeamTwoPoints();
      notifyListeners();
    }
  }

  /// Alterar pontuacaoo maxima do placar:
  /// - [newPoints]: Inteiro contendo o novo valor
  set maxPoints(int newPoint) {
    if (newPoint > 0) {
      _placarModel.maxPoints = newPoint;
      notifyListeners();
    }
  }

  ///retorna o valor da pontuação do time 1
  get teamOnePoints => _placarModel.teamOnePoints;

  ///retorna o valor do set do time 1
  get teamOneSets => _placarModel.teamOneSets;

  ///retorna o valor da pontuação do time 2
  get teamTwoPoints => _placarModel.teamTwoPoints;

  ///retorna o valor do set do time 2
  get teamTwoSets => _placarModel.teamTwoSets;

  ///Retorna a pontuação maxima do placar
  int get maxPoints => _placarModel.maxPoints;

  /// Alterar pontuação do time 1:
  /// - [newPoints]: Inteiro contendo o novo valor
  set _addTeamOnePoints(int newPoint) => _placarModel.teamOnePoints += newPoint;

  /// Alterar set do time 1:
  /// - [newPoints]: Inteiro contendo o novo valor
  set _addTeamOneSet(int newPoint) => _placarModel.teamOneSets += newPoint;

  /// Alterar pontuacao do time 2:
  /// - [newPoints]: Inteiro contendo o novo valor
  set _addTeamTwoPoints(int newPoint) => _placarModel.teamTwoPoints += newPoint;

  /// Alterar set do time 2:
  /// - [newPoints]: Inteiro contendo o novo valor
  set _addTeamTwoSet(int newPoint) => _placarModel.teamTwoSets += newPoint;

  ///reseta pontuacao do time 1
  void _resetTeamOnePoints() => _placarModel.teamOnePoints = 0;

  ///reseta o set do time 1
  void _resetTeamOneSets() => _placarModel.teamOneSets = 0;

  ///reseta pontuacao do time 2
  void _resetTeamTwoPoints() => _placarModel.teamTwoPoints = 0;

  ///reseta o set do time 22
  void _resetTeamTwoSets() => _placarModel.teamTwoSets = 0;
}
