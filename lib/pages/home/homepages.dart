import 'package:flutter/material.dart';
import 'package:nubank_inspiration/pages/home/widgets/bottom_menu.dart';
import 'package:nubank_inspiration/pages/home/widgets/item_menu_bottom.dart';
import 'package:nubank_inspiration/pages/home/widgets/menu_app.dart';
import 'package:nubank_inspiration/pages/home/widgets/my_app_bar.dart';
import 'package:nubank_inspiration/pages/home/widgets/my_dots_app..dart';
import 'package:nubank_inspiration/pages/home/widgets/page_view_app.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _showMenu;
  late int _currentIndex;
  late double _yPosition;

  @override
  void initState() {
    super.initState();
    _showMenu = false;
    _currentIndex = 0;
    _yPosition = 0;
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeigth = MediaQuery.of(context).size.height;
    if (_yPosition == null) {
      _yPosition = _screenHeigth * .20;
    }

    return Scaffold(
      backgroundColor: Colors.purple[700],
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          MyAppBar(
            showMenu: _showMenu,
            onTap: () {
              setState(() {
                _showMenu = !_showMenu;
                _yPosition =
                    _showMenu ? _screenHeigth * .75 : _screenHeigth * .24;
              });
            },
          ),
          MenuApp(
            top: _screenHeigth * .18,
            showMenu: _showMenu,
          ),
          BottomMenu(
            showMenu: _showMenu,
          ),
          MyDotsApp(
            showMenu: _showMenu,
            top: _screenHeigth * .70,
            currentIndex: _currentIndex,
          ),
          PageViewApp(
            showMenu: _showMenu,
            top:
                _yPosition, //!_showMenu ? _screenHeigth * .24 : _screenHeigth * .75,
            onChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            onPanUpdate: (details) {
              double positionBottomLimit = _screenHeigth * .75;
              double positionTopLimit = _screenHeigth * .24;
              double midlePosition = positionBottomLimit - positionTopLimit;
              midlePosition = midlePosition / 2;
              setState(() {
                _yPosition += details.delta.dy;

                _yPosition = _yPosition < positionTopLimit
                    ? positionTopLimit
                    : _yPosition;

                _yPosition = _yPosition > positionBottomLimit
                    ? positionBottomLimit
                    : _yPosition;

                if (_yPosition != positionBottomLimit && details.delta.dy > 0) {
                  _yPosition =
                      _yPosition > positionTopLimit + midlePosition - 50
                          ? positionBottomLimit
                          : _yPosition;
                }
                if (_yPosition != positionTopLimit && details.delta.dy < 0) {
                  _yPosition = _yPosition < positionBottomLimit - midlePosition
                      ? positionTopLimit
                      : _yPosition;
                }
                if (_yPosition == positionBottomLimit) {
                  _showMenu = true;
                } else if (_yPosition == positionTopLimit) {
                  _showMenu = false;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
