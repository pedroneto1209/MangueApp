import 'package:flutter/material.dart';
import 'package:mangueapp/init.dart';
import 'package:mangueapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeScreen extends StatefulWidget {
  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView(
            children: <Widget> [
              Container(
                height: 20,
              ),
              GestureDetector(
                child: Container(color: Colors.transparent, child: option('MangueBeat', Icon(Icons.style, color: logoColor))
                ),
                onTap: () {
                  save('colorBackD', 0xFF101820);
                  save('colorBackM', 0xFF090D11);
                  save('colorBackU', 0xFF000000);
                  save('colorText', 0xFFFFFFFF);
                  save('colorLogo', 0xFF087234);
                  save('colorCircle', 0xFF666666);
                  saves('colorImg', 'assets/Icons/Header/manguebeat.png');
                  saves('colorImgC', 'assets/Icons/Crab/manguebeat.png');
                  saves('mapStyle', 'assets/Maps/manguebeat.json');
                  setState(() {
                    backgroundDown = Color(0xFF101820);
                    backgroundMid = Color(0xFF090D11);
                    backgroundUp = Color(0xFF000000);
                    textColor = Color(0xFFFFFFFF);
                    logoColor = Color(0xFF087234);
                    circleBackground = Color(0xFF666666);
                    img = 'assets/Icons/Header/manguebeat.png';
                    crab = 'assets/Icons/Crab/manguebeat.png';
                    mapStyle = 'assets/Maps/manguebeat.json';
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  });
                },
              ),
              GestureDetector(
                child: Container(color: Colors.transparent, child: option('Caxangá', Icon(Icons.style, color: logoColor))
                ),
                onTap: () {
                  save('colorBackD', 0xFFF2F3F4);
                  save('colorBackM', 0xFFDADEDF);
                  save('colorBackU', 0xFFC1C7C9);
                  save('colorText', 0xFF000000);
                  save('colorLogo', 0xFF000000);
                  save('colorCircle', 0xFF6F7C80);
                  saves('colorImg', 'assets/Icons/Header/caxanga.png');
                  saves('colorImgC', 'assets/Icons/Crab/caxanga.png');
                  saves('mapStyle', 'assets/Maps/caxanga.json');
                  setState(() {
                    backgroundDown = Color(0xFFF2F3F4);
                    backgroundMid = Color(0xFFDADEDF);
                    backgroundUp = Color(0xFFC1C7C9);
                    textColor = Color(0xFF000000);
                    logoColor = Color(0xFF000000);
                    circleBackground = Color(0xFF6F7C80);
                    img = 'assets/Icons/Header/caxanga.png';
                    crab = 'assets/Icons/Crab/caxanga.png';
                    mapStyle = 'assets/Maps/caxanga.json';
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  });
                },
              ),
              GestureDetector(
                child: Container(color: Colors.transparent, child: option('Capibaribe', Icon(Icons.style, color: logoColor))
                ),
                onTap: () {
                  save('colorBackD', 0xFF00316E);
                  save('colorBackM', 0xFF00316E);
                  save('colorBackU', 0xFF001B3A);
                  save('colorText', 0xFFCCFFCC);
                  save('colorLogo', 0xFF0099CC);
                  save('colorCircle', 0xFF001B3A);
                  saves('colorImg', 'assets/Icons/Header/capibaribe.png');
                  saves('colorImgC', 'assets/Icons/Crab/capibaribe.png');
                  saves('mapStyle', 'assets/Maps/capibaribe.json');
                  setState(() {
                    backgroundDown = Color(0xFF00316E);
                    backgroundMid = Color(0xFF00316E);
                    backgroundUp = Color(0xFF001B3A);
                    textColor = Color(0xFFCCFFCC);
                    logoColor = Color(0xFF0099CC);
                    circleBackground = Color(0xFF001B3A);
                    img = 'assets/Icons/Header/capibaribe.png';
                    crab = 'assets/Icons/Crab/capibaribe.png';
                    mapStyle = 'assets/Maps/capibaribe.json';
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  });
                },
              ),
              GestureDetector(
                child: Container(color: Colors.transparent, child: option('Mauritsstad', Icon(Icons.style, color: logoColor))
                ),
                onTap: () {
                  save('colorBackD', 0xFFCAB7A1);
                  save('colorBackM', 0xFFCAB7A1);
                  save('colorBackU', 0xFFB29576);
                  save('colorText', 0xFF260101);
                  save('colorLogo', 0xFF881D1D);
                  save('colorCircle', 0xFF260101);
                  saves('colorImg', 'assets/Icons/Header/mauritsstad.png');
                  saves('colorImgC', 'assets/Icons/Crab/mauritsstad.png');
                  saves('mapStyle', 'assets/Maps/mauritsstad.json');
                  setState(() {
                    backgroundDown = Color(0xFFCAB7A1);
                    backgroundMid = Color(0xFFCAB7A1);
                    backgroundUp = Color(0xFFB29576);
                    textColor = Color(0xFF260101);
                    logoColor = Color(0xFF881D1D);
                    circleBackground = Color(0xFF260101);
                    img = 'assets/Icons/Header/mauritsstad.png';
                    crab = 'assets/Icons/Crab/mauritsstad.png';
                    mapStyle = 'assets/Maps/mauritsstad.json';
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  });
                },
              ),
              GestureDetector(
                child: Container(color: Colors.transparent, child: option('Jaqueira', Icon(Icons.style, color: logoColor))
                ),
                onTap: () {
                  save('colorBackD', 0xFFE5E7E1);
                  save('colorBackM', 0xFFE5E7E1);
                  save('colorBackU', 0xFFFFBAD2);
                  save('colorText', 0xFF5C604D);
                  save('colorLogo', 0xFFFD5DA8);
                  save('colorCircle', 0xFF999999);
                  saves('colorImg', 'assets/Icons/Header/jaqueira.png');
                  saves('colorImgC', 'assets/Icons/Crab/jaqueira.png');
                  saves('mapStyle', 'assets/Maps/jaqueira.json');
                  setState(() {
                    backgroundDown = Color(0xFFE5E7E1);
                    backgroundMid = Color(0xFFE5E7E1);
                    backgroundUp = Color(0xFFFFBAD2);
                    textColor = Color(0xFF5C604D);
                    logoColor = Color(0xFFFD5DA8);
                    circleBackground = Color(0xFF999999);
                    img = 'assets/Icons/Header/jaqueira.png';
                    crab = 'assets/Icons/Crab/jaqueira.png';
                    mapStyle = 'assets/Maps/jaqueira.json';
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
      ),
    );
  }

  save(String chave, int cor) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(chave, cor);
  }

  saves(String chave, String cor) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(chave, cor);
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