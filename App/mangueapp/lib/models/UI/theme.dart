import 'package:flutter/material.dart';
import 'package:mangueapp/models/UI/global.dart';

class ThemeScreen extends StatefulWidget {
  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: <Widget> [
            Container(
              height: 20,
            ),
            GestureDetector(
              child: Container(child: option('Ektia', Icon(Icons.style, color: logoColor))
              ),
              onTap: () {
                setState(() {
                  backgroundDown = Color(0xFFFFCDA5);
                  backgroundMid = Color(0xFFFFCDA5);
                  backgroundUp = Color(0xFFEE4D5F);
                  textColor = Color(0xFF000000);
                  logoColor = Color(0xFFF650A0);
                  circleBackground = Color(0xFFFFFFFF);
                  Navigator.pushNamed(context, 'Home');
                });
              },
            ),
          ],
        ),
      ),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            stops: [0.10, 0.25, 0.5],
            colors: [backgroundUp, backgroundMid, backgroundDown],
        ),
      ),
    );
  }

  Widget option(String name, Widget icon) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Container(
          height: 60,
        ),
        Positioned(
          bottom: 20,
          left: 60,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'HP',
              fontSize: 15,
              color: textColor
            ),
          ),
        ),
        Container(
          height: 2,
          width: 330,
          color: textColor
        ),
        Positioned(
          bottom: 18,
          left: 33,
          child: icon
        ),
      ],
    );
  }
}