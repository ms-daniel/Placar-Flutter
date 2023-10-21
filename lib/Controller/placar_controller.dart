import 'package:flutter/material.dart';
import 'package:yon_scoreboard/Model/PlacarModel.dart';
import 'package:yon_scoreboard/shared/enums.dart';

class PlacarController extends ChangeNotifier {
  final PlacarModel _placarModel = PlacarModel();

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

  void resetPoints() {
    _resetTeamOnePoints();
    _resetTeamTwoPoints();
    notifyListeners();
  }

  /// Alterar pontuacaoo maxima do placar:
  /// - [newPoints]: Inteiro contendo o novo valor
  set maxPoints(int newPoint) {
    _placarModel.maxPoints = newPoint;
    notifyListeners();
  }

  get teamOnePoints => _placarModel.teamOnePoints;
  get teamOneSets => _placarModel.teamOneSets;
  get teamTwoPoints => _placarModel.teamTwoPoints;
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

  ///reseta pontuacao do time 2
  void _resetTeamTwoPoints() => _placarModel.teamTwoPoints = 0;
}
