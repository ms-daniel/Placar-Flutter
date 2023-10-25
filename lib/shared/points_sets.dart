import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TeamPoints extends StatelessWidget {
  final int _points;
  final double _fontAdjust;

  const TeamPoints(this._points, this._fontAdjust, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.center,
              child: AutoSizeText(
                _points < 10
                    ? '0$_points'
                    : _points.toString(),
                style: TextStyle(
                  fontSize: (210 * _fontAdjust),
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
                maxLines: 1,
              ),
            ),
          );
  }
}

class TeamSets extends StatelessWidget {
  final int _sets;
  final double _fontAdjust;

  const TeamSets(this._sets, this._fontAdjust, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              alignment: Alignment.topLeft,
              child: Text(
                _sets.toString(),
                style: TextStyle(
                  fontSize: (74 * _fontAdjust),
                  color: Colors.white,
                ),
              ),
            ),
          );
  }
}