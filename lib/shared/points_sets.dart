import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TeamPoints extends StatelessWidget {
  final int _points;
  final double _fontAdjust;

  const TeamPoints(this._points, this._fontAdjust, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: AutoSizeText(
          _points < 10
              ? '0$_points'
              : _points.toString(),
          style: TextStyle(
            fontSize: 230 * _fontAdjust,
            color: Colors.white,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
            fontFamily: 'Nova Square',
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
    return Container(
      margin: EdgeInsets.only(top: 26 * _fontAdjust),
      alignment: Alignment.topCenter,
      child: AutoSizeText(
        _sets.toString(),
        style: TextStyle(
          fontSize: 74 * _fontAdjust,
          color: Colors.white,
          fontFamily: 'Nova Square',
        ),
      ),
    );
  }
}