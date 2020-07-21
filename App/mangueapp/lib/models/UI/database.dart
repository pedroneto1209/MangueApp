import 'package:flutter/material.dart';
import 'global.dart';

class DataBasePage extends StatefulWidget {
  @override
  _DataBasePageState createState() => _DataBasePageState();
}

class _DataBasePageState extends State<DataBasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Set appbar to control system icons color
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: backgroundUp,
        )
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 65, 0, 0),
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                    Container(
                      height: 180,
                      width: 292
                    ),
                  Positioned(
                    bottom: 50,
                    child: Image.asset('assets/images/HeaderLogo.png', width: 134),
                  ),
                  Text(
                    'mangue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Ageoextrabold',
                      fontSize: 80,
                      color: logoColor
                    )
                  ),
                ],
              ),
            ),
            Container(
              height: 4,
              width: 345,
              color: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                    color: textColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text(
                'Olá, Conecte-se ao baja!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Ageoextrabold',
                  fontSize: 25,
                  color: textColor
                ),
              ),
            ),
            //List of bluetooths
            Container(
              height: 250,
            ),
            //Link pro home
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'Home');
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 42, 0, 0),
                child: Text(
                  'Não quer se conectar? clique aqui para acessar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontFamily: 'Ageoextrabold',
                    fontSize: 15,
                    color: logoColor
                  ),
                ),
              )
            ),
          ],
        ),
        //Makes the gradient background
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              stops: [0.10, 0.25, 0.5],
              colors: [backgroundUp, backgroundMid, backgroundDown],
          ),
        ),
      )
    );
  }
}