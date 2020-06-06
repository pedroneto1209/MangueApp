import 'package:flutter/material.dart';
import 'models/global.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'Init',
      routes: {
        'Init': (context) => InitScreen(),
        'Home': (context) => HomeScreen(),
      },
      home: InitScreen(),
    );
  }
}

class InitScreen extends StatefulWidget {
  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
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
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  children: getList(),
                ),
              ),
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

  //List of bluetooths
  List<Widget> getList() {
    return [
      option('HC - 06'),
      option('AirPods de Rafael'),
      option('Galei no cu da mãe onnn annn'),
    ];
  }

  Widget option(String name) {
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
          color: backgroundUp
        ),
        Positioned(
          bottom: 20,
          left: 33,
          child: Image.asset('assets/images/bluetooth.png', width: 20),
        ),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        child:Container(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: TabBarView(
              children: [
                Container(
                  //Makes the gradient background
                  color: Colors.transparent,
                ),
                Container(
                  //Makes the gradient background
                  color: Colors.transparent,
                ),
                Container(
                  //Makes the gradient background
                  color: Colors.transparent,
                ),
                Container(
                  //Makes the gradient background
                  color: Colors.transparent,
                ),
                Container(
                  //Makes the gradient background
                  color: Colors.transparent,
                ),
              ],
            ),
            bottomNavigationBar: Container(
              height: 70,
              color: backgroundUp,
              child: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(IconData(0xe900, fontFamily: 'Emergency'), size: 35,)
                  ),
                  Tab(
                    icon: Icon(IconData(0xe902, fontFamily: 'Map'), size: 35,)
                  ),
                  Tab(
                    icon: Icon(IconData(0xe901, fontFamily: 'Live'), size: 35,)
                  ),
                  Tab(
                    icon: Icon(IconData(0xe903, fontFamily: 'Server'), size: 35,)
                  ),
                  Tab(
                    icon: Icon(Icons.settings, size: 35)
                  )
                ],
                labelColor: logoColor,
                unselectedLabelColor: textColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: backgroundDown,
                )
              ),
            ),
          ),
          //set gradient background
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                stops: [0.10, 0.25, 0.5],
                colors: [backgroundUp, backgroundMid, backgroundDown],
            ),
          ),
        ),
      ),
    );
  }
}